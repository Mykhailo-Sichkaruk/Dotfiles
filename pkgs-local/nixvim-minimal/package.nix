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
pkgs.writeShellApplication {
  name = "nixvim-minimal";
  runtimeInputs = [ nixvimPackage ];
  text = ''
    exec ${nixvimPackage}/bin/nvim "$@"
  '';
}
