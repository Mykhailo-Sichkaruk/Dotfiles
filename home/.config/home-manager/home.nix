{ pkgs, ... }:

let
  # Import shell configuration
  shellConfig = import ./shell.nix { };
in
{
  # Add the external GUI config (which includes the YouTube Music desktop entry)
  imports = [ ./programs/gui.nix ];

  home = {
    username = "ms";
    homeDirectory = "/home/ms";
    stateVersion = "24.11";
    packages =
      shellConfig
      ++ (with pkgs; [
        safe-rm
        rofi
        keepassxc
        neomutt
        sxhkd
        pulsemixer
        easyeffects
        vifm
        mysql-workbench
        spice-vdagent
        youtube-music
        vscode
        obs-studio
        discord
        betterdiscordctl
        pipewire
        slack
        telegram-desktop
        dbeaver-bin
        drawio
        mpv
        obsidian
        vimiv-qt
        zathura
        calc
        vieb
        google-chrome
        peek
        mpv # Media player
        nerdfonts
        alacritty
        dex
        offlineimap
        i3lock
        dunst
        xclip
        oh-my-fish
        syncthing
        nix-du
        insomnia
        flameshot
        light
        playerctl
        keepmenu
      ]);
  };

  programs = {
    # Let Home Manager manage itself
    home-manager.enable = true;
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

        bind -k nul -M insert accept-autosuggestion
        bind \cg forget_last_command
        bind --mode insert \cg forget_last_command

        starship init fish | source
        fish_vi_key_bindings
        eval "$(zoxide init --cmd cd fish)"
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

  services.syncthing = {
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

}
