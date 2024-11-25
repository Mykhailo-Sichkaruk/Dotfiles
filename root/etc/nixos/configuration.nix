# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.network.wait-online.enable = false;
  # boot.initrd.lvm.enable = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/210151fe-69d0-4635-982d-ea2d6cdf907a";
      preLVM = true;
    };
  };

  security.polkit.enable = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0792-F22C";
    fsType = "vfat";
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.extraHosts = ''
    10.2.0.10 dc01.local.sk.cloud
    10.2.0.7  ca.xclbr.dev
    127.0.0.1 dev.xclbr.local
  '';
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = false; # Easiest to use and most distros use this by default.
  networking.supplicant.wlo1 = {
    configFile.path = "/etc/wpa_supplicant/wpa_supplicant.conf";
    configFile.writable = true;
    userControlled.enable = true;
  };
  systemd.network.wait-online.enable = false;
  networking.dhcpcd.wait = "background";
  networking.useDHCP = true;
  #systemd.network.wait-online.anyInterface = true;

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "eth0";

  # Set your time zone.
  time.timeZone = "Europe/Bratislava";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.displayManager = {
    defaultSession = "none+i3";
    logToFile = true;
    enable = true;
    autoLogin.user = "ms";
    autoLogin.enable = true;
  };
  services.blueman.enable = true;
  services.logind = {
    lidSwitch = "hibernate";
    lidSwitchDocked = "hibernate";
    lidSwitchExternalPower = "hibernate";
  };
  services.xserver = {
    autoRepeatInterval = 50;
    autoRepeatDelay = 250;
    # videoDrivers = [ "nvidia" ];
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager = {
      i3.enable = true;
    };

    displayManager.setupCommands = ''
        #autorandr --change
    '';
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

  # Configure keymap in X11
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "caps:escape,grp:alt_shift_toggle";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

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
      "docker"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    pinentry-tty
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
  ];

  nix.optimise.automatic = true;

  programs = {
    fish.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8888
      8889
      8000
      80
      443
      4443
      3000
      3001
      22
      2222
    ];
  };

  virtualisation.docker.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "24.05"; # Did you read the comment?

}
