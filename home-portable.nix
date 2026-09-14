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

  hasNvim = localPackages != null && localPackages ? nvim;

  localShellPackages = lib.optionals hasNvim [
    localPackages.nvim
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
    sessionVariables = lib.mkIf hasNvim {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
