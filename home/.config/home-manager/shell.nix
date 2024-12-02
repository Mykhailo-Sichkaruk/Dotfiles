{
  pkgs ? import <nixpkgs> { },
}:

let
  nixConfig = import ./programs/nvim.nix { inherit pkgs; };
in
nixConfig
++ (with pkgs; [
  rsync
  stow
  ncdu
  eza
  zip
  starship # Shell prompt
  zoxide # Directory navigation tool
  gh # GitHub CLI
  tlp # Power management tool
  neovim # Text editor
  nodejs # JavaScript runtime
  python3 # Python programming language
  fd # A simple, fast file search tool
  ripgrep # Line-oriented search tool
  tmux # Terminal multiplexer
  #vim               # Text editor
  cargo # Rust package manager
  jq # Command-line JSON processor
  docker # Containerization tool
  #nmap              # Network scanner
  #curl              # Command-line tool for transferring data
  findutils # GNU utilities to search files
  powertop # Linux power consumption optimization tool
  neofetch # System information tool
  #valgrind          # Memory debugging tool
  patch # Apply diff files to update files
  ripgrep # Fast recursive search
  btop # Resource monitor
  offlineimap # Synchronize mail directories
  bat # A cat(1) clone with syntax highlighting
  texinfo # Info documentation system
  findutils # File search tools
  tree # Directory listing tool
  speedtest-cli # Internet speed test tool
  tldr # Simplified man pages
  fzf
  grc
  fish
  fishPlugins.fzf-fish
  fishPlugins.grc
  fishPlugins.z
  fishPlugins.plugin-git
  microsoft-edge
  opera
])
