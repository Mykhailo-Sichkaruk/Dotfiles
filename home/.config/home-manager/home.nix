{ config, pkgs, ... }:

let
  # Import shell configuration
  shellConfig = import ./shell.nix {};

  # Import GUI configuration
  youtubeMusicConfig = import ./programs/gui.nix { inherit pkgs; };
in
{
  home.username = "ms";
  home.homeDirectory = "/home/ms";
  home.stateVersion = "24.05";

  # Define the packages to be installed
  home.packages = shellConfig ++ [
    pkgs.rofi
    pkgs.keepassxc
    pkgs.neomutt
    pkgs.sxhkd           # Simple X hotkey daemon
    pkgs.pulsemixer    # PulseAudio mixer
    pkgs.easyeffects
    pkgs.vifm
    pkgs.mysql-workbench
    pkgs.spice-vdagent
    pkgs.youtube-music  # Install YouTube Music here
    pkgs.vscode
    pkgs.obs-studio
    pkgs.discord
    pkgs.betterdiscordctl
    pkgs.pipewire
    pkgs.slack
    pkgs.telegram-desktop
    pkgs.dbeaver-bin
    pkgs.drawio
    pkgs.mpv
    pkgs.obsidian
    pkgs.vimiv-qt
    pkgs.zathura
    pkgs.calc
    pkgs.vieb
    pkgs.google-chrome
    pkgs.peek
    pkgs.kooha
    pkgs.mpv               # Media player
    pkgs.glibcLocales
    pkgs.nerdfonts
    pkgs.alacritty
    pkgs.dex
    pkgs.offlineimap
    pkgs.i3lock
    pkgs.dunst
  ];

#xsession.windowManager.i3 = {
#   enable = true;
#   config = {
#     bars = [
#     { 
#       position = "bottom";
#j     statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config.toml";
#     }
#     ];
#   };
# };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
        "text/html" = "vieb.desktop";
        "x-scheme-handler/http" = "vieb.desktop";
        "x-scheme-handler/https" = "vieb.desktop";
        "x-scheme-handler/about" = "vieb.desktop";
        "x-scheme-handler/unknown" = "vieb.desktop";
        #"text/html" = "${pkgs.vieb}/bin/vieb";
        #"x-scheme-handler/http" = "${pkgs.vieb}/bin/vieb";
        #"x-scheme-handler/https" = "${pkgs.vieb}/bin/vieb";
        #"x-scheme-handler/about" = "${pkgs.vieb}/bin/vieb";
        #"x-scheme-handler/unknown" = "${pkgs.vieb}/bin/vieb";
    };
  };
  # Add the external GUI config (which includes the YouTube Music desktop entry)
  imports = [
    ./programs/gui.nix
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
