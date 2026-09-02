{
  lib,
  pkgs,
  localPackages ? null,
  ...
}:

let
  shellPackages = import ./programs/home/shell.nix {
    inherit pkgs;
  };

  hasNixvim = localPackages != null && localPackages ? nixvimMinimal;

  localShellPackages = lib.optionals hasNixvim [
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
    stateVersion = "26.05";
    packages = localShellPackages ++ shellPackages;
    sessionVariables = lib.mkIf hasNixvim {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
