{
  pkgs,
  pkgs-unstable,
  nixvim,
  system,
}:

let
  nixvimPackage = nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
    module = import ./module.nix;
  };
in
pkgs.symlinkJoin {
  name = "nvim";
  paths = [ nixvimPackage ];
  postBuild = ''
    ln -s nvim "$out/bin/vimdiff"
  '';
  meta.mainProgram = "nvim";
}
