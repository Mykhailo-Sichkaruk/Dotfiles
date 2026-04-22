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

  # Keep Chrome rendering experiments in Nix so they are easy to audit and
  # toggle instead of being buried in chrome://flags state.
  chromeEnabledFeatures = [
    "Vulkan"
    "DefaultANGLEVulkan"
    "VulkanFromANGLE"
  ];

  chromeExtraFlags = [
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
  ]
  ++ pkgs.lib.optionals (chromeEnabledFeatures != [ ]) [
    "--enable-features=${pkgs.lib.concatStringsSep "," chromeEnabledFeatures}"
  ];

  chromeWithFlags =
    let
      baseChrome = pkgs.google-chrome;
      wrapperFlags = pkgs.lib.concatMapStringsSep " " (
        flag: "--add-flags ${pkgs.lib.escapeShellArg flag}"
      ) chromeExtraFlags;
    in
    pkgs.symlinkJoin {
      name = "google-chrome-with-flags";
      paths = [ baseChrome ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm "$out/bin/google-chrome-stable"
        makeWrapper ${baseChrome}/bin/google-chrome-stable "$out/bin/google-chrome-stable" \
          ${wrapperFlags}

        rm "$out/share/applications/google-chrome.desktop"
        cp ${baseChrome}/share/applications/google-chrome.desktop \
          "$out/share/applications/google-chrome.desktop"
        substituteInPlace "$out/share/applications/google-chrome.desktop" \
          --replace-fail "${baseChrome}/bin/google-chrome-stable" "$out/bin/google-chrome-stable"
      '';
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
      pkgs-unstable.claude-code
      pkgs-unstable.github-copilot-cli
      localPackages.archi
      localPackages.playwrightBrowsers1217
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
      # chromeWithFlags
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
      antigravity
      bubblewrap
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
    ])
    ++ (with pkgs-unstable; [
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
          config = {
            port = 8765;
          };
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
        set -gx PLAYWRIGHT_BROWSERS_PATH "${localPackages.playwrightBrowsers1217}";
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
