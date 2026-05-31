{ pkgs, pkgs-unstable }:
let
  vimPackages = import ./nvim.nix {
    inherit pkgs;
    inherit pkgs-unstable;
  };
in
vimPackages
++ (with pkgs; [
  rsync
  stow
  ncdu
  eza
  zip
  zoxide
  gh
  tlp
  fd
  ripgrep
  ripgrep-all
  curl
  findutils
  powertop
  offlineimap
  bat
  tree
  speedtest-cli
  tldr
  fzf
  grc
  vifm
  xclip
  syncthing
  nix-du
  ffmpeg
  unzip
  nix-ld
  lazydocker
  lazygit
  yarn
  esbuild
])
