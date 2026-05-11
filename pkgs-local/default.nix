{
  nixvim,
  pkgs,
  pkgs-cuda,
  pkgs-unstable,
  system,
}:

let
  archiMcpPort = 8766;
in
rec {
  archi = pkgs.callPackage ./archi/package.nix {
    inherit archiMcpPort;
  };

  archiMcpPlugin = pkgs.callPackage ./archi-mcp-plugin/package.nix {
    port = archiMcpPort;
  };

  jarchi = pkgs.callPackage ./jarchi/package.nix {
    inherit archi;
  };

  archiDropins = pkgs.symlinkJoin {
    name = "archi-dropins";
    paths = [
      jarchi
      archiMcpPlugin
    ];
  };

  nixvimMinimal = import ./nixvim-minimal/package.nix {
    inherit
      nixvim
      pkgs
      pkgs-unstable
      system
      ;
  };

  playwrightBrowsers1217 = pkgs.callPackage ./playwright-browsers-1217/package.nix { };

  whisperCppCuda = pkgs.callPackage ./whisper-cpp-cuda/package.nix {
    inherit pkgs-cuda;
  };
}
