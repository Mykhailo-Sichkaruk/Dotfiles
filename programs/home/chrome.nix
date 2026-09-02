{ ... }:
{
  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      # Vulkan/ANGLE and zero-copy repeatedly crash Chrome's GPU process on this laptop.
      "--enable-gpu-rasterization"
      "--disable-features=Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
      "--disable-zero-copy"
    ];
  };
}
