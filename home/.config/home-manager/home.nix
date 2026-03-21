{ pkgs, pkgs-unstable, ... }:

let
  shellConfig = import ./programs/shell.nix {
    inherit pkgs;
    inherit pkgs-unstable;
  };
in
{
  imports = [ ./programs/gui.nix ];

  home = {
    username = "ms";
    homeDirectory = "/home/ms";
    stateVersion = "25.11";
    packages = [
      pkgs-unstable.vscode
      # pkgs-unstable.google-cloud-sdk
    ]
    ++ shellConfig
    ++ (with pkgs; [
      # NOTE: Multimedia
      libreoffice-fresh
      playerctl
      obsidian
      yt-dlp
      neomutt
      pulsemixer
      pipewire
      drawio
      mpv
      vimiv-qt
      zathura
      pkgs.nur.repos."vieb-nix".vieb
      google-chrome
      flameshot
      newsboat
      obs-studio
      youtube-music
      peek
      # NOTE: Communication
      discord
      telegram-desktop
      teams-for-linux
      whatsapp-electron
      mattermost-desktop
      slack
      # NOTE: Dev
      dbeaver-bin
      pipx
      remmina
      # NOTE: Other
      rofi
      libnotify
      keepassxc
      alacritty
      openvpn3
      comma
      i3lock
      dunst
      sxhkd
      nix-index
    ])
    ++ [
    ];
  };

  xsession = {
    numlock.enable = true;
    profileExtra = ''
      xdotool key XF86TouchpadOff
    '';
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    i3status-rust = {
      enable = true;
    };
    home-manager.enable = true;
    # home-manager.backupFileExtension = "backup";
    alacritty = {
      enable = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_cursor_insert line
        set fish_greeting
        fish_config theme choose "Dracula Official"
        function fish_mode_prompt; end
        alias rm="safe-rm"
        alias e="eza -ab --group-directories-first --icons"
        alias ex="eza -ab --group-directories-first --icons -lTL 1 --no-time --git --no-user"
        alias ls="ls --color -L"
        alias la="eza"
        alias l="ex"
        alias h="history 1 | grep"
        alias rm="rm -rf"
        alias cp="cp -r"
        alias ..="cd .."
        alias ...="cd ../.."
        alias ....="cd ../../.."
        alias .....="cd ../../../.."
        alias cls="clear"
        alias gitclown="git clone"
        abbr --add nd nix develop
        abbr --add nr sudo nixos-rebuild switch --flake ~/newDot/Dotfiles/#MS_NixLaptop

        fish_vi_key_bindings
        bind ctrl-space -M insert accept-autosuggestion
        bind \cg forget_last_command
        bind --mode insert \cg forget_last_command
        bind --mode insert \tn nvim .

        starship init fish | source
        zoxide init --cmd cd fish | source
      '';
      plugins = [
        {
          name = "grc";
          inherit (pkgs.fishPlugins.grc) src;
        }
        {
          name = "z";
          inherit (pkgs.fishPlugins.z) src;
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
        {
          name = "plugin-git";
          inherit (pkgs.fishPlugins.plugin-git) src;
        }
        # {
        #   name = "nvm";
        #   inherit (pkgs.fishPlugins.nvm) src;
        # }
      ];
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

  services = {
    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
      settings.folders = {
        "/home/ms/Sync" = {
          id = "laptop_phone";
        };
      };
    };
  };

}
