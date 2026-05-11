{ pkgs, ... }:

let
  enabledFeatures = [
    "Vulkan"
    "DefaultANGLEVulkan"
    "VulkanFromANGLE"
  ];
in
{
  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--enable-features=${pkgs.lib.concatStringsSep "," enabledFeatures}"
    ];
  };
}
