{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "tcp_bbr"
    "sch_cake"
  ];
  boot.extraModulePackages = [ ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.overcommit_memory" = 0;
    "kernel.core_pattern" = "|/bin/false";
    "net.ipv4.tcp_fastopen" = 3;
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_mtu_probing" = 1;
  };
  boot.kernelParams = [
    "amd_pstate=active"
    "zswap.enabled=1"
    "zswap.compressor=lz4"
    "zswap.max_pool_percent=10"
    "zswap.shrinker_enabled=1"
    "transparent_hugepage=madvise"
  ];
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ffb7c1c3-8f4c-4a08-a077-5f5bcc4000bf";
    fsType = "ext4";
    options = [
      "discard"
      "noatime"
      "nodiratime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b3c535a1-40bd-4fcc-9d83-e92a62a3e372";
    fsType = "ext4";
    options = [
      "discard"
      "noatime"
      "nodiratime"
    ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/41fefdac-c7a1-429f-8ee9-76d29f0c61ed";
      options = [ "discard" ];
    }
  ];

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.amdgpu.opencl.enable = true;
  powerManagement.powertop.enable = false;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
}
