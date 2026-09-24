{
  pkgs,
  pkgs-unstable,
  nixvim,
  nvim-mcp,
  system,
}:

let
  nvimMcpPackage = nvim-mcp.packages.${system}.default;
  nvimMcpPlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-mcp";
    version = nvim-mcp.shortRev or "unstable";
    src = nvim-mcp;
  };

  nixvimPackage = nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = {
      inherit nvimMcpPlugin pkgs-unstable;
    };
    module = import ./module.nix;
  };
in
pkgs.symlinkJoin {
  name = "nvim";
  paths = [
    nixvimPackage
    nvimMcpPackage
  ];
  postBuild = ''
    ln -s nvim "$out/bin/vimdiff"
  '';
  meta.mainProgram = "nvim";
}
