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
    #pkgs.spice-vdagent
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
    pkgs.xclip
    pkgs.oh-my-fish
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
  
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_cursor_insert line
        set fish_greeting
        fish_config theme choose "Dracula Official"
        function fish_mode_prompt; end
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
            src = pkgs.fishPlugins.grc.src; 
          }
          {
            name = "z";
            src = pkgs.fishPlugins.z.src; 
          }
          {
            name = "fzf-fish";
            src = pkgs.fishPlugins.fzf-fish.src;
          }
          {
            name = "plugin-git";
            src = pkgs.fishPlugins.plugin-git.src;
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
