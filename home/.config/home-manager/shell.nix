{ pkgs ? import <nixpkgs> {} }:

with pkgs;
[
  # i3lock           # Screen locker
  rsync           # File synchronization tool
  stow             # Symlink farm manager
  ncdu              # Disk usage analyzer with an ncurses interface
  eza               # Easy aliasing tool
  zip              # Compression tool
  starship         # Shell prompt
  zoxide            # Directory navigation tool
  gh                # GitHub CLI
  tlp               # Power management tool
  neovim            # Text editor
  nodejs            # JavaScript runtime
  python3           # Python programming language
  # go                # Go programming language
  rust-analyzer     # Rust language server
  cargo             # Rust package manager
  cmake             # Build system generator
  yamllint          # YAML linter
  hadolint          # Dockerfile linter
  gcc               # GNU Compiler Collection
  buf               # Protobuf tool
  protolint         # Protobuf linter
  checkmake         # Makefile linter
  cppcheck          # C++ static analysis tool
  cpplint
  cmake-format      # Formatter for CMake files
  dotenv-linter     # Linter for `.env` files
  lua               # Scripting language
  rustfmt           # Rust code formatter
  astyle            # Code formatter
  prettierd          # Code formatter daemon
  asmfmt            # Assembler code formatter
  clang-tools       # Clang tools like `clang-tidy`
  ccls              # C/C++/Obj-C language server
  typst             # Fast markup-based typesetting
  typst-lsp         # Language server for Typst
  shellcheck        # Shell script analysis tool
  fd                # A simple, fast file search tool
  ripgrep           # Line-oriented search tool
  tmux              # Terminal multiplexer
  lz4               # Fast compression algorithm
  gcc               # C/C++ Compiler
  dotnet-sdk        # .NET Core SDK
  vim               # Text editor
  cargo             # Rust package manager
  jq                # Command-line JSON processor
  docker            # Containerization tool
  nmap              # Network scanner
  curl              # Command-line tool for transferring data
  wget              # File download tool
  git               # Version control system
  fuse3             # Filesystem in Userspace
  findutils         # GNU utilities to search files
  pciutils          # Linux PCI utilities
  efibootmgr        # Tool to manage EFI boot entries
  powertop          # Linux power consumption optimization tool
  bubblewrap        # Sandboxing tool
  neofetch          # System information tool
  valgrind          # Memory debugging tool
  gettext           # GNU internationalization utilities
  patch             # Apply diff files to update files
  ripgrep           # Fast recursive search
  i3status          # Status bar for i3 window manager
  btop              # Resource monitor
  offlineimap       # Synchronize mail directories
  mpv               # Media player
  bat               # A cat(1) clone with syntax highlighting
  fuse3             # Filesystem in Userspace
  wget              # Command-line download tool
  nano              # Simple text editor
  texinfo           # Info documentation system
  findutils         # File search tools
  tree              # Directory listing tool
  alsa-topology-conf # ALSA audio configuration files
  lm_sensors        # Hardware monitoring tool
  fakeroot          # Simulate root user file operations
  xorg.xev          # Event testing tool for X
  pipewire          # Audio/video server
  fish              # Shell with user-friendly features
]

