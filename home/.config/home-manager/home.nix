{ config, pkgs, ... }:

let
  myGlibcLocales = pkgs.glibcLocales.override {
    locales = [ "en_US.UTF-8" ];
  };
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
    # pkgs.xorg.xserver  # Xorg server from Nix
    # pkgs.xorg.xinit    # If you use `startx` or `xinit` to start i3
    # pkgs.sxhkd           # Simple X hotkey daemon
    pkgs.pulsemixer    # PulseAudio mixer
    pkgs.easyeffects
    # pkgs.vifm
    pkgs.mysql-workbench
    # pkgs.i3
    # pkgs.i3status-rust
    pkgs.youtube-music  # Install YouTube Music here
    # pkgs.vscode
    pkgs.obs-studio
    pkgs.discord
    pkgs.betterdiscordctl
    # pkgs.pipewire
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
    # pkgs.kooha
    pkgs.mpv               # Media player
    # pkgs.glibcLocales
  ];

  home.sessionVariables = {
    XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:/usr/share:/usr/local/share";
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
  # Add the external GUI config (which includes the YouTube Music desktop entry)
  imports = [
    ./programs/gui.nix
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
