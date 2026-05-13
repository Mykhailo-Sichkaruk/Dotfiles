{
  lib,
  pkgs,
  pkgs-unstable,
  localPackages ? null,
  ...
}:

let
  shellPackages = import ./programs/home/shell.nix {
    inherit pkgs pkgs-unstable;
  };

  localShellPackages = lib.optionals (localPackages != null && localPackages ? nixvimMinimal) [
    localPackages.nixvimMinimal
  ];
in
{
  imports = [
    ./programs/home/starship.nix
    ./programs/home/git.nix
    ./programs/home/ssh.nix
    ./programs/home/btop.nix
    ./programs/home/fish.nix
  ];

  home = {
    stateVersion = "25.11";
    packages = localShellPackages ++ shellPackages;
  };

  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
