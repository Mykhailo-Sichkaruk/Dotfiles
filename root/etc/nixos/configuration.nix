# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix = {
    optimise.automatic = true;
    settings = {
      cores = 7;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  imports = [
    ./hardware-configuration.nix
    ./tlp.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true; # To detect otther OSs on the disk (e.g. Windows)
      };
    };
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/210151fe-69d0-4635-982d-ea2d6cdf907a";
        preLVM = true;
      };
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0792-F22C";
    fsType = "vfat";
  };

  # Pick only one of the below networking options.
  networking = {
    hostName = "mykhailos_nixos"; # Define your hostname.
    wireless.enable = false; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = false; # Easiest to use and most distros use this by default.
    extraHosts = ''
    '';
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    interfaces."wlo1" = {
      macAddress = "00:1A:1E:66:4b:a5";
    };
    supplicant.wlo1 = {
      configFile.path = "/etc/wpa_supplicant/wpa_supplicant.conf";
      configFile.writable = true;
      userControlled.enable = true;
    };
    useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        22
      ];
    };
  };

  time.timeZone = "Europe/Bratislava";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    openvpn.servers = {
      stubaVPN = {
        autoStart = false;
        config = ''
          config /home/ms/Downloads/client.ovpn
        '';
      };
    };
    atd = {
      enable = true;
    };
    fstrim.enable = true;
    displayManager = {
      defaultSession = "none+i3";
      logToFile = true;
      enable = true;
      autoLogin.user = "ms";
      autoLogin.enable = true;
    };
    blueman.enable = true;
    logind = {
      lidSwitch = "hibernate";
      lidSwitchDocked = "hibernate";
      lidSwitchExternalPower = "hibernate";
    };
    xserver = {
      videoDrivers = [ "modesetting" ];
      xkb.layout = "us,ua";
      xkb.options = "caps:escape,grp:alt_shift_toggle";
      autoRepeatInterval = 50;
      autoRepeatDelay = 250;
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      windowManager = {
        i3.enable = true;
      };

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
    libinput.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ms = {
    home = "/home/ms";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "video"
      "render"
      "transmission"
      "input"
    ]; # Enable ‘sudo’ for the user.
    packages = [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  environment = {
    systemPackages = with pkgs; [
      cachix
      pass
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
      safe-rm
      rofi
      pulsemixer
      nh
      xdotool
      man-pages
    ];
    variables = {
      RM = "safe-rm";
      TERMINAL = "alacritty"; # Set Alacritty as the default terminal
    };
  };

  programs = {
    openvpn3.enable = true;
    fish.enable = true;
    light.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = false;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/ms/newDot/Dotfiles";
    };
  };
  virtualisation.docker.enable = true;

  fonts.packages = [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
    stateVersion = "25.05";
  };
}
