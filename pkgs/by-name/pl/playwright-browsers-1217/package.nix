{
  callPackage,
  linkFarm,
  makeFontsConf,
}:

let
  revision = "1217";
  browserVersion = "147.0.7727.15";

  chromium = callPackage ./chromium.nix {
    inherit revision browserVersion;
    fontconfig_file = makeFontsConf {
      fontDirectories = [ ];
    };
  };

  chromiumHeadlessShell = callPackage ./chromium-headless-shell.nix {
    inherit revision browserVersion;
  };
in
linkFarm "playwright-browsers-${revision}" [
  {
    name = "chromium-${revision}";
    path = chromium;
  }
  {
    name = "chromium_headless_shell-${revision}";
    path = chromiumHeadlessShell;
  }
]
