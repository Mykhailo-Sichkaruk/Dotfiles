{ pkgs, pkgs-unstable }:
let
  vimPackages = import ./nvim.nix { inherit pkgs; inherit pkgs-unstable; };
in
vimPackages
++ (with pkgs; [
  # safe-rm
  rsync
  stow
  ncdu
  eza
  zip
  starship
  zoxide
  gh
  tlp
  fd
  ripgrep
  ripgrep-all
  # vim
  # jq
  # docker
  curl
  findutils
  powertop
  neofetch
  # patch
  btop
  offlineimap
  bat
  # texinfo
  tree
  speedtest-cli
  tldr
  fzf
  grc
  fish
  fishPlugins.fzf-fish
  fishPlugins.grc
  fishPlugins.z
  fishPlugins.plugin-git
  vifm
  xclip
  # oh-my-fish
  syncthing
  nix-du
  # dex
  offlineimap
  # ffmpeg
  unzip
  nix-ld
  lazydocker
  lazygit
])
