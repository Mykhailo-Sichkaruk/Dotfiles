{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
  shellConfig = import ./shell.nix {};
in shellConfig ++ [
  visual-studio-code-bin # Visual Studio Code IDE
  obs-studio        # Open Broadcaster Software
  qt6-base          # Core Qt framework
  lm_sensors        # CLI hardware monitoring tool
  texinfo           # GNU documentation tool
  discord           # Chat and collaboration platform
  pipewire          # Audio and video server
  slack-desktop     # Collaboration platform for teams
  electron          # Desktop application framework
  telegram-desktop  # Telegram client
  xorg-server-xephyr # Nested X server
  xorg-server-xnest # Nested X server
  youtube-music     # Music streaming service
  youtube-dl        # Video downloader
  dbeaver           # Database manager
  drawio-desktop    # Diagramming tool
  telegram-desktop  # Telegram client
  mpv               # Video player
  neomutt           # Email client
  gtkmm4            # C++ bindings for GTK+4
  sqlitebrowser     # SQLite database management tool
  wayland           # Display server protocol
  ffmpeg            # Multimedia framework
  obsidian          # Note-taking software
  pdftk             # PDF toolkit
  vimiv             # Image viewer and Vim-like interface
  drawio-desktop    # Diagramming tool
  neomutt           # Email client
  ripgrep           # CLI search tool
  wayland           # Display server protocol
  gtk4              # Toolkit for creating GUIs
  imagemagick       # Image processing tools
  zathura-djvu      # DjVu file viewer
  vlc               # Media player
  gnome-keyring     # GNOME's password management tool
  calc              # Calculator application
]
