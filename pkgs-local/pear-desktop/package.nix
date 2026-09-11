{
  coreutils,
  jq,
  lib,
  makeWrapper,
  pear-desktop,
  symlinkJoin,
  writeShellApplication,
  writeText,
}:

{
  chromiumArgs ? [ ],
  package ? pear-desktop,
  settings ? { },
}:

let
  settingsFile = writeText "pear-desktop-declarative-settings.json" (builtins.toJSON settings);

  syncConfig = writeShellApplication {
    name = "pear-desktop-sync-config";
    runtimeInputs = [
      coreutils
      jq
    ];
    text = ''
      config_home="''${XDG_CONFIG_HOME:-$HOME/.config}"
      config_dir="$config_home/YouTube Music"
      config_file="$config_dir/config.json"

      mkdir -p "$config_dir"
      temporary_file="$(mktemp "$config_dir/.config.json.nix.XXXXXX")"

      cleanup() {
        rm -f -- "$temporary_file"
      }
      trap cleanup EXIT

      if [[ -s "$config_file" ]]; then
        jq --exit-status --slurp '.[0] * .[1]' \
          "$config_file" \
          ${lib.escapeShellArg settingsFile} \
          >"$temporary_file"
      else
        cp ${lib.escapeShellArg settingsFile} "$temporary_file"
      fi

      if [[ -e "$config_file" ]]; then
        chmod --reference="$config_file" "$temporary_file"
      else
        chmod 0600 "$temporary_file"
      fi

      if [[ -e "$config_file" ]] && cmp --silent "$config_file" "$temporary_file"; then
        exit 0
      fi

      mv --force "$temporary_file" "$config_file"
      trap - EXIT
    '';
  };

  wrapperArgs = [
    "--run"
    "${syncConfig}/bin/pear-desktop-sync-config"
  ]
  ++ lib.optionals (chromiumArgs != [ ]) [
    "--add-flags"
    (lib.escapeShellArgs chromiumArgs)
  ];
in
symlinkJoin {
  name = "pear-desktop-configured-${lib.getVersion package}";
  paths = [ package ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/pear-desktop" ${lib.escapeShellArgs wrapperArgs}
  '';

  inherit (package) meta;
  passthru = (package.passthru or { }) // {
    inherit settingsFile;
    unwrapped = package;
  };
}
