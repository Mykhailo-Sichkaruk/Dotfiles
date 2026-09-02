{
  pkgs,
  pkgs-unstable,
  localPackages,
  ...
}:

let
  peekWithoutFfmpegPipeDeadlock = pkgs.peek.overrideAttrs (oldAttrs: {
    # Peek waits for FFmpeg to exit before reading its redirected output. Once
    # that pipe fills, FFmpeg cannot exit and Peek remains on "Rendering"
    # forever. Keep only the recording control pipe and inherit FFmpeg output.
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace src/recording/cli-screen-recorder.vala \
        --replace-fail \
          'SubprocessFlags.STDIN_PIPE | SubprocessFlags.STDOUT_PIPE | SubprocessFlags.STDERR_MERGE' \
          'SubprocessFlags.STDIN_PIPE'

      substituteInPlace src/post-processing/cli-post-processor.vala \
        --replace-fail \
          'SubprocessFlags.STDOUT_PIPE | SubprocessFlags.STDERR_MERGE' \
          'SubprocessFlags.NONE'
    '';
  });

  dbeaverWithMetalLaf = pkgs.dbeaver-bin.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      dbeaverIni="$out/opt/dbeaver/dbeaver.ini"
      grep -qx -- '-vmargs' "$dbeaverIni"
      sed -i '/^-vmargs$/a-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel' "$dbeaverIni"
      grep -qx -- '-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel' "$dbeaverIni"
    '';
  });

  vimivWithModernFormats = pkgs.vimiv-qt.overrideAttrs (oldAttrs: {
    # Provide Qt's WebP (and other extended image-format) plugins to Vimiv's wrapper.
    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.qt5.qtimageformats ];

    # Backport https://github.com/karlch/vimiv-qt/commit/b0507ff9688b621c916ae3886ba5d5974530f5d5
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace vimiv/utils/imageheader.py \
        --replace-fail \
          'return h[:2] == b"\x3C\x3F" and (h[2:5] in [b"\x78\x6D\x6C", b"\x73\x76\x67"])' \
          'return h[:4] == b"\x3C\x73\x76\x67" or (h[:2] == b"\x3C\x3F" and h[2:5] in [b"\x78\x6D\x6C", b"\x73\x76\x67"])'
    '';
  });
in
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
    ./programs/home/local-apps.nix
  ];

  my.apps = {
    archi.enable = true;
    comfyui.enable = false;
    whisperCuda.enable = false;
  };

  home = {
    username = "ms";
    homeDirectory = "/home/ms";
    packages = [
      pkgs-unstable.claude-code
    ]
    ++ (with pkgs; [
      moonlight
      moonlight-qt
      sunshine
      calibre
      vscode
      playerctl
      obsidian
      # languagetool
      yt-dlp
      neomutt
      pulsemixer
      pipewire
      drawio
      vimivWithModernFormats
      pkgs.nur.repos."vieb-nix".vieb
      pear-desktop
      peekWithoutFfmpegPipeDeadlock
      discord
      telegram-desktop
      teams-for-linux
      whatsapp-electron
      # mattermost-desktop
      # slack
      dbeaverWithMetalLaf
      # packaging 26.1 changed PEP 508 URL formatting; pipx 1.8.0 still asserts the old spacing.
      # pipx
      # (pipx.overridePythonAttrs (old: {
      #   disabledTests = (old.disabledTests or [ ]) ++ [
      #     "test_fix_package_name"
      #     "test_parse_specifier_for_metadata"
      #   ];
      # }))
      libnotify
      keepassxc
      openvpn3
      comma
      i3lock
      sxhkd
      smem
      atop
      pagemon
      swapview
      # figma-linux
    ]);
  };

  xresources.properties = {
    "Xft.dpi" = 112;
    "Xft.antialias" = 1;
    "Xft.autohint" = 0;
    "Xft.hinting" = 1;
    "Xft.hintstyle" = "slight";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.rgba" = "none";
  };

  xsession.numlock.enable = true;

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
      profiles."User 1".sync = {
        username = "mykhailo.sichkaruk@gmail.com";
        keyFile = "/home/ms/.secrets/anki-sync-key";
        autoSync = true;
        syncMedia = true;
      };
    };
    i3status-rust.enable = true;
    keychain = {
      enable = true;
      keys = [ "bos_class_vm" ];
    };
  };

  xdg.mimeApps = {
    enable = true;

    associations.added = {
      "x-scheme-handler/figma" = "figma-linux.desktop";
    };

    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";

      "x-scheme-handler/figma" = "figma-linux.desktop";
    };
  };

  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings.folders."/home/ms/Sync".id = "laptop_phone";
  };

  systemd.user.services.languagetool = {
    Unit = {
      Description = "LanguageTool HTTP server";
      Documentation = [ "https://dev.languagetool.org/http-server.html" ];
    };

    Service = {
      ExecStart = "${pkgs.languagetool}/bin/languagetool-http-server --port 8081";
      Environment = [ "JAVA_TOOL_OPTIONS=-Xmx2G" ];
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
