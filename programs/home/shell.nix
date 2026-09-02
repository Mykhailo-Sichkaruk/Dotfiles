{ pkgs }:
with pkgs;
[
  render-cli
  gnumake
  python314Packages.huggingface-hub
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
  # offlineimap
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
  nodejs_26
  # lazydocker
  # lazygit
  yarn
  # esbuild
  vitejs
]
