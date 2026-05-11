{ pkgs, pkgs-cuda }:

let
  cudaRuntimeLibraryPath = pkgs.lib.makeLibraryPath [
    pkgs-cuda.cudaPackages.cuda_cudart
    pkgs-cuda.cudaPackages.libcublas
  ];

  whisperCppCuda = pkgs-cuda.whisper-cpp.override {
    cudaSupport = true;
  };
in
pkgs.writeShellScriptBin "whisper-cpp-cuda" ''
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export __VK_LAYER_NV_optimus=NVIDIA_only
  export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:${cudaRuntimeLibraryPath}:$LD_LIBRARY_PATH"
  exec ${whisperCppCuda}/bin/whisper-cli "$@"
''
