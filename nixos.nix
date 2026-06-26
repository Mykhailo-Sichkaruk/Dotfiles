{
  config,
  lib,
  pkgs,
  ...
}:

let
  laptopDisplayLayout = pkgs.writeShellApplication {
    name = "laptop-display-layout";
    runtimeInputs = with pkgs; [
      gnugrep
      xrandr
    ];
    text = ''
      set -euo pipefail

      dpi=96

      if xrandr --query | grep -q '^HDMI-A-1-0 connected'; then
        xrandr \
          --output eDP-1-0 --primary \
          --output HDMI-A-1-0 --mode 2560x1440 --rate 143.99 --above eDP-1-0 \
          --dpi "$dpi"
      elif xrandr --query | grep -q '^HDMI-A-0 connected'; then
        xrandr \
          --output eDP --primary \
          --output HDMI-A-0 --mode 2560x1440 --rate 143.99 --above eDP \
          --dpi "$dpi"
      elif xrandr --query | grep -q '^eDP-1-0 connected'; then
        xrandr --output eDP-1-0 --primary --auto --dpi "$dpi"
      else
        xrandr --output eDP --primary --auto --dpi "$dpi" || xrandr --dpi "$dpi"
      fi
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./programs/system/tlp.nix
  ];

  nix = {
    optimise.automatic = true;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
    settings = {
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      download-buffer-size = 6710886400;
      preallocate-contents = true;
      min-free = 3 * 1024 * 1024 * 1024;
      max-free = 4 * 1024 * 1024 * 1024;
      max-jobs = 2;
      cores = 3;
      max-substitution-jobs = 4;
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
    wireless = {
      enable = true;
      interfaces = [ "wlo1" ];
      userControlled = true;
      allowAuxiliaryImperativeNetworks = true;
      secretsFile = "/etc/wpa_supplicant-secrets.conf";
      networks = {
        eduroam = {
          authProtocols = [ "WPA-EAP" ];
          auth = ''
            proto=RSN
            pairwise=CCMP
            auth_alg=OPEN
            eap=PEAP
            identity="xsichkaruk@stuba.sk"
            password=ext:password_eduroam
            phase2="auth=MSCHAPV2"
            mesh_fwding=1
            disabled=0
          '';
          priority = 5;
        };
        Ynet = {
          authProtocols = [ "WPA-EAP" ];
          auth = ''
            proto=RSN
            pairwise=CCMP
            auth_alg=OPEN
            eap=PEAP
            identity="misha0510@ynet.sk"
            password=ext:password_ynet
            phase2="auth=MSCHAPV2"
            mesh_fwding=1
            disabled=0
          '';
          priority = 11;
        };
        visitors = {
          pskRaw = "ext:psk_visitors";
          extraConfig = ''
            mesh_fwding=1
          '';
        };
        Uniit = {
          pskRaw = "ext:psk_uniit";
          extraConfig = ''
            mesh_fwding=1
            disabled=0
          '';
          priority = 6;
        };
      };
    };
    networkmanager.enable = false;
    extraHosts = "";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
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
  systemd.services.touchpad-off-at-boot = {
    description = "Turn off the laptop touchpad at boot";
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "/sys/bus/platform/devices/PNP0C09:00/touchpad";
    serviceConfig.Type = "oneshot";
    script = ''
      echo 0 > /sys/bus/platform/devices/PNP0C09:00/touchpad
    '';
  };

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
        "nvidia"
      ];
      dpi = 96;
      xkb.layout = "us,ua";
      xkb.options = "caps:escape,grp:alt_shift_toggle,compose:rctrl";
      autoRepeatInterval = 50;
      autoRepeatDelay = 250;
      enable = true;
      desktopManager.xterm.enable = false;
      windowManager.i3.enable = true;
      displayManager.sessionCommands = ''
        ${laptopDisplayLayout}/bin/laptop-display-layout || true
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
      finegrained = false;
    };

    prime = {
      sync.enable = true;
      reverseSync.enable = false;
      offload = {
        enable = false;
        enableOffloadCmd = false;
      };

      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
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
      "wpa_supplicant"
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
    steam = {
      enable = false;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    kdeconnect.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld.enable = true;
    openvpn3.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
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
      laptopDisplayLayout
      rofi
      pulsemixer
      xdotool
      lenovo-legion
      ffmpeg
      openai-whisper
      whisper-cpp
      nvtopPackages.full
      pciutils
      brightnessctl
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

  specialisation."amd-power-saving".configuration = {
    boot.blacklistedKernelModules = lib.mkAfter [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];

    services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];

    hardware.nvidia = {
      modesetting.enable = lib.mkForce false;
      nvidiaSettings = lib.mkForce false;
      powerManagement = {
        enable = lib.mkForce false;
        finegrained = lib.mkForce false;
      };
      prime = {
        sync.enable = lib.mkForce false;
        reverseSync.enable = lib.mkForce false;
        offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = false;
      allowReboot = false;
    };
    stateVersion = "26.05";
  };
}
