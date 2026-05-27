{
  pkgs,
  pkgs-unstable,
  localPackages,
  ...
}:

{
  imports = [
    ./home-portable.nix
    ./programs/home/gui.nix
    ./programs/home/gtk.nix
    ./programs/home/newsboat.nix
    ./programs/home/alacritty.nix
    ./programs/home/mpv.nix
    ./programs/home/zathura.nix
    ./programs/home/rofi.nix
    ./programs/home/dunst.nix
    ./programs/home/flameshot.nix
    ./programs/home/chrome.nix
  ];

  home = {
    username = "ms";
    homeDirectory = "/home/ms";
    packages = [
      pkgs-unstable.vscode
      pkgs-unstable.claude-code
      pkgs-unstable.github-copilot-cli
      localPackages.archi
      localPackages.playwrightBrowsers1217
      localPackages.whisperCppCuda
    ]
    ++ (with pkgs; [
      audacity
      libreoffice-fresh
      playerctl
      obsidian
      yt-dlp
      neomutt
      pulsemixer
      pipewire
      drawio
      vimiv-qt
      pkgs.nur.repos."vieb-nix".vieb
      obs-studio
      youtube-music
      peek
      discord
      telegram-desktop
      teams-for-linux
      whatsapp-electron
      mattermost-desktop
      slack
      dbeaver-bin
      pipx
      libnotify
      keepassxc
      openvpn3
      comma
      i3lock
      sxhkd
    ]);
  };

  home.file.".archi/dropins" = {
    source = "${localPackages.archiDropins}/share/archi-dropins";
    recursive = true;
  };

  home.file."Documents/Archi/scripts/.keep".text = "";

  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${localPackages.playwrightBrowsers1217}";
  };

  xsession = {
    numlock.enable = true;
    profileExtra = ''
      xdotool key XF86TouchpadOff
    '';
  };

  programs = {
    anki = {
      enable = true;
      addons = [
        (pkgs.ankiAddons.anki-connect.withConfig {
          config.port = 8765;
        })
        pkgs.ankiAddons.review-heatmap
      ];
      theme = "dark";
      sync.username = "mykhailo.sichkaruk@gmail.com";
      sync.keyFile = "/home/ms/.secrets/anki-sync-key";
      sync.autoSync = true;
      sync.syncMedia = true;
    };
    i3status-rust.enable = true;
    keychain = {
      enable = true;
      keys = [ "bos_class_vm" ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };

  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings.folders."/home/ms/Sync".id = "laptop_phone";
  };
}
