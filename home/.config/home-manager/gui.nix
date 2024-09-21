{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

with pkgs;
let
  shellConfig = import ./shell.nix {};
in shellConfig ++ [
  # alacritty         # Terminal emulator
  mysql-workbench   # MySQL database design and management tool
  i3                # Tiling window manager
  i3status-rust    # i3 status bar
  youtube-music     # Music streaming service
  vscode            # Code editor
  obs-studio        # Open Broadcaster Software
  # qt6-base          # Core Qt framework
  discord           # Chat and collaboration platform
  pipewire          # Audio and video server
  slack#             Collaboration platform for teams
  telegram-desktop  # Telegram client
  # xorg-server-xephyr # Nested X server
  # xorg-server-xnest # Nested X server
  youtube-music     # Music streaming service
  dbeaver           # Database manager
  drawio            # Diagramming tool
  mpv               # Video player
  neomutt           # Email client
  gtkmm4            # C++ bindings for GTK+4
  sqlitebrowser     # SQLite database management tool
  wayland           # Display server protocol
  ffmpeg            # Multimedia framework
  obsidian          # Note-taking software
  pdftk             # PDF toolkit
  vimiv-qt             # Image viewer and Vim-like interface
  neomutt           # Email client
  ripgrep           # CLI search tool
  wayland           # Display server protocol
  gtk4              # Toolkit for creating GUIs
  imagemagick       # Image processing tools
  zathura           # PDF / DJVU file viewer
  vlc               # Media player
  gnome-keyring     # GNOME's password management tool
  calc              # Calculator application
]
