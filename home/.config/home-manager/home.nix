{ pkgs, ... }:

let
  # Import shell configuration
  shellConfig = import ./programs/shell.nix { inherit pkgs; };
in
{
  # Add the external GUI config (which includes the YouTube Music desktop entry)
  imports = [ ./programs/gui.nix ];
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "ms";
    homeDirectory = "/home/ms";
    stateVersion = "25.05";
    packages =
      shellConfig
      ++ (with pkgs; [
        # anki
        # at
        libnotify
        vscode
        # nvtopPackages.full
        rofi
        keepassxc
        neomutt
        sxhkd
        pulsemixer
        youtube-music
        yt-dlp
        discord
        # betterdiscordctl
        pipewire
        telegram-desktop
        drawio
        mpv
        obsidian
        vimiv-qt
        zathura
        vieb
        google-chrome
        alacritty
        i3lock
        dunst
        flameshot
        playerctl
        comma
        # nix-index
        # openvpn3
        # teams-for-linux
        newsboat
        obs-studio
      ]);
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
      ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "vieb.desktop";
      "x-scheme-handler/http" = "vieb.desktop";
      "x-scheme-handler/https" = "vieb.desktop";
      "x-scheme-handler/about" = "vieb.desktop";
      "x-scheme-handler/unknown" = "vieb.desktop";
    };
  };

  services = {
    syncthing = {
      enable = true;
      # Still not in the stable version
      /*
        guiAddress = "127.0.0.1:8384";
        settings.folders = {
            "/home/ms/Sync" = {
              id = "laptop_phone";
            };
          };
      */
    };
  };

}
