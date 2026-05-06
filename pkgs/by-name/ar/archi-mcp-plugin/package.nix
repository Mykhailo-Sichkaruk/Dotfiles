{
  lib,
  stdenvNoCC,
  fetchurl,
  perl,
  unzip,
  zip,
  port ? 8766,
}:

let
  portString = toString port;
in
assert lib.assertMsg (builtins.stringLength portString == 4)
  "archi-mcp-plugin binary patch currently requires a four-digit port";
stdenvNoCC.mkDerivation {
  pname = "archi-mcp-plugin";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/Diozavr/archi-mcp-plugin/releases/download/v0.3.0/ru.cinimex.archimatetool.mcp_0.3.0.release.jar";
    hash = "sha256-pfaOUW6CoiBCLdqbSLa0MJ5g6rBXWleNU7euNdop5mc=";
  };

  dontUnpack = true;
  nativeBuildInputs = [
    perl
    unzip
    zip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/archi-dropins"

    unpacked="$TMPDIR/archi-mcp-plugin"
    mkdir -p "$unpacked"
    unzip -q "$src" -d "$unpacked"

    find "$unpacked" -type f ! -path "$unpacked/lib/*" -print0 | xargs -0 perl -0777pi -e '
      s/8765/${portString}/g;
    '

    find "$unpacked" -name '*.class' -print0 | xargs -0 perl -0777pi -e '
      BEGIN {
        $oldInt = pack("N", 8765);
        $newInt = pack("N", ${portString});
        $oldSipush = "\x11" . pack("n", 8765);
        $newSipush = "\x11" . pack("n", ${portString});
      }
      s/\Q$oldInt\E/$newInt/g;
      s/\Q$oldSipush\E/$newSipush/g;
    '

    find "$unpacked" -exec touch -h -d @1 {} +
    (cd "$unpacked" && zip -X -q -r "$out/share/archi-dropins/ru.cinimex.archimatetool.mcp_0.3.0.release.jar" .)

    runHook postInstall
  '';

  meta = {
    description = "MCP plugin dropin for Archi";
    homepage = "https://github.com/Diozavr/archi-mcp-plugin";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
