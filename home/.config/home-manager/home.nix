{ config, pkgs, ...}:

let

  nixpkgs = import <nixpkgs> {
    config.allowUnfree = true;
  };

  shellConfig = import ~/.config/home-manager/shell.nix {};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ms";
  home.homeDirectory = "/home/ms";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = shellConfig ++ [
    pkgs.alacritty         # Terminal emulator
    pkgs.mysql-workbench   # MySQL database design and management tool
    pkgs.i3                # Tiling window manager
    pkgs.i3status-rust     # i3 status bar
    pkgs.youtube-music     # Music streaming service
    pkgs.vscode            # Code editor
    pkgs.obs-studio        # Open Broadcaster Software
    pkgs.discord           # Chat and collaboration platform
    pkgs.pipewire          # Audio and video server
    pkgs.slack             # Collaboration platform for teams
    pkgs.telegram-desktop  # Telegram client
    pkgs.dbeaver-bin           # Database manager
    pkgs.drawio            # Diagramming tool
    pkgs.mpv               # Video player
    pkgs.neomutt           # Email client
    pkgs.gtkmm4            # C++ bindings for GTK+4
    pkgs.sqlitebrowser     # SQLite database management tool
    pkgs.wayland           # Display server protocol
    pkgs.ffmpeg            # Multimedia framework
    pkgs.obsidian          # Note-taking software
    pkgs.pdftk             # PDF toolkit
    pkgs.vimiv-qt          # Image viewer and Vim-like interface
    pkgs.neomutt           # Email client
    pkgs.ripgrep           # CLI search tool
    pkgs.wayland           # Display server protocol
    pkgs.gtk4              # Toolkit for creating GUIs
    pkgs.imagemagick       # Image processing tools
    pkgs.zathura           # PDF / DJVU file viewer
    pkgs.vlc               # Media player
    pkgs.gnome-keyring     # GNOME's password management tool
    pkgs.calc              # Calculator application
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ms/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
