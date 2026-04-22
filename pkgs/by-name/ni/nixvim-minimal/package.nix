{ pkgs, pkgs-unstable, nixvim, system }:

let
  nixvimPackage = nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
    module = import ../../../../home/.config/home-manager/programs/nixvim/minimal.nix;
  };
in
pkgs.writeShellApplication {
  name = "nixvim-minimal";
  runtimeInputs = [ nixvimPackage ];
  text = ''
    exec ${nixvimPackage}/bin/nvim "$@"
  '';
}
