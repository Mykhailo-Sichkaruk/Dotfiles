{
  pkgs,
  pkgs-unstable,
  localPackages,
  ...
}:

let
  shellConfig = import ./programs/shell.nix {
    inherit pkgs;
    inherit pkgs-unstable;
  };
in
{
  imports = [
    ./programs/gui.nix
    ../../modules/home-manager/programs/starship.nix
    ../../modules/home-manager/programs/git.nix
    ../../modules/home-manager/programs/ssh.nix
    ../../modules/home-manager/programs/gtk.nix
    ../../modules/home-manager/programs/newsboat.nix
    ../../modules/home-manager/programs/alacritty.nix
    ../../modules/home-manager/programs/mpv.nix
    ../../modules/home-manager/programs/zathura.nix
    ../../modules/home-manager/programs/btop.nix
    ../../modules/home-manager/programs/rofi.nix
    ../../modules/home-manager/programs/dunst.nix
    ../../modules/home-manager/programs/flameshot.nix
    ../../modules/home-manager/programs/fish.nix
    ../../modules/home-manager/programs/chrome.nix
  ];

  home = {
    username = "ms";
    homeDirectory = "/home/ms";
    stateVersion = "25.11";
    packages = [
      pkgs-unstable.vscode
      pkgs-unstable.claude-code
      pkgs-unstable.github-copilot-cli
      localPackages.archi
      localPackages.nixvimMinimal
      localPackages.playwrightBrowsers1217
    ]
    ++ shellConfig
    ++ (with pkgs; [
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
      remmina
      antigravity
      bubblewrap
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
    keychain.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    i3status-rust.enable = true;
    home-manager.enable = true;
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
