{ pkgs }:
let
  nixConfig = import ./nvim.nix { inherit pkgs; };
in
nixConfig
++ (with pkgs; [
  safe-rm
  rsync
  stow
  ncdu
  eza
  zip
  starship
  zoxide
  gh
  tlp
  # nodejs_23
  python3
  fd
  ripgrep
  tmux
  vim
  cargo
  jq
  docker
  curl
  findutils
  powertop
  neofetch
  patch
  ripgrep
  btop
  offlineimap
  bat
  texinfo
  findutils
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
  # git-filter-repo
  vifm
  xclip
  oh-my-fish
  syncthing
  nix-du
  dex
  offlineimap
  ffmpeg
  unzip
  steam-run
  nix-ld
  # imagemagick
  pnpm
  zgrviewer
  graphviz
])
