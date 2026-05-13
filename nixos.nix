{
  config,
  lib,
  pkgs,
  ...
}:

let
  speechPython = pkgs.python312.withPackages (
    ps: with ps; [
      faster-whisper
      noisereduce
    ]
  );
in
{
  imports = [
    ./hardware-configuration.nix
    ./programs/system/tlp.nix
  ];

  nix = {
    optimise.automatic = true;
    settings = {
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      download-buffer-size = 6710886400;
      preallocate-contents = true;
      max-jobs = "auto";
      cores = 7;
      trusted-users = [ "ms" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
      };
    };
    initrd.luks.devices.root = {
      device = "/dev/disk/by-uuid/210151fe-69d0-4635-982d-ea2d6cdf907a";
      preLVM = true;
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0792-F22C";
    fsType = "vfat";
  };

  networking = {
    hostName = "mykhailos_nixos";
    wireless.enable = false;
    networkmanager.enable = false;
    extraHosts = "";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    supplicant.wlo1 = {
      configFile.path = "/etc/wpa_supplicant/wpa_supplicant.conf";
      configFile.writable = true;
      userControlled.enable = true;
    };
    useDHCP = false;
    dhcpcd = {
      enable = true;
      extraConfig = ''
        allowinterfaces en* eth* enx* wl* br-*

        interface en*
          metric 50
        interface eth*
          metric 50
        interface enx*
          metric 50
        interface br*
          metric 50

        interface wl*
          metric 200
      '';
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  time.timeZone = "Europe/Bratislava";
  systemd.network.wait-online.enable = false;
  systemd.coredump.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [ "65228d8d6d070ea3" ];
      port = 9993;
    };
    openvpn.servers.stubaVPN = {
      autoStart = false;
      config = ''
        config /home/ms/Downloads/client.ovpn
      '';
    };
    atd.enable = true;
    fstrim.enable = true;
    displayManager = {
      defaultSession = "none+i3";
      logToFile = true;
      enable = true;
      autoLogin.user = "ms";
      autoLogin.enable = true;
    };
    blueman.enable = true;
    logind.settings.Login = {
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "poweroff";
      HandleHibernateKey = "hibernate";
      HandleLidSwitch = "hibernate";
      HandleLidSwitchDocked = "hibernate";
      HandleLidSwitchExternalPower = "hibernate";
      PowerKeyIgnoreInhibited = "yes";
      SuspendKeyIgnoreInhibited = "yes";
      HibernateKeyIgnoreInhibited = "yes";
      LidSwitchIgnoreInhibited = "yes";
      RebootKeyIgnoreInhibited = "yes";
    };
    xserver = {
      videoDrivers = lib.mkForce [
        "amdgpu"
        "nvidia"
      ];
      xkb.layout = "us,ua";
      xkb.options = "caps:escape,grp:alt_shift_toggle,compose:rctrl";
      autoRepeatInterval = 50;
      autoRepeatDelay = 250;
      enable = true;
      desktopManager.xterm.enable = false;
      windowManager.i3.enable = true;
      displayManager.sessionCommands = ''
        xset r rate 250 50
        xset b off
      '';
      displayManager.lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          user = "ms";
        };
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        tappingButtonMap = "lrm";
        additionalOptions = ''
          Option "ClickMethod" "buttonareas"
        '';
      };
    };
    openssh.enable = true;
    pcscd.enable = true;
    udev.extraRules = ''
      SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{power/control}="auto"
    '';
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      extraConfig = ''
        Defaults timestamp_timeout=60
      '';
    };
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    doas.enable = true;
  };

  users.users.ms = {
    home = "/home/ms";
    isNormalUser = true;
    linger = true;
    extraGroups = [
      "dialout"
      "wheel"
      "video"
      "render"
      "transmission"
      "input"
      "tss"
    ];
    packages = [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld.enable = true;
    openvpn3.enable = true;
    fish.enable = true;
    light.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam.enable = false;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/ms/newDot/Dotfiles";
    };
    dconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      cargo
      deepfilternet
      man-pages
      man-pages-posix
      mesa-demos
      stdmanpages
      gtk3
      cachix
      gnupg
      i3status-rust
      fish
      wget
      vim
      neovim
      git
      gh
      alacritty
      autorandr
      rofi
      pulsemixer
      xdotool
      lenovo-legion
      audacity
      ffmpeg
      noisetorch
      openai-whisper
      speechPython
      whisper-cpp
      nvtopPackages.full
      pciutils
    ];
    variables = {
      TERMINAL = "alacritty";
      GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
    };
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
    };
  };

  virtualisation.docker.enable = false;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    package = pkgs.docker_29;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-color-emoji
  ];

  system = {
    autoUpgrade = {
      enable = false;
      allowReboot = false;
    };
    stateVersion = "25.11";
  };
}
