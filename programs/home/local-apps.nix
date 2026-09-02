{
  config,
  lib,
  localPackages,
  ...
}:

let
  cfg = config.my.apps;
in
{
  options.my.apps = {
    archi.enable = lib.mkEnableOption "the local Archi application and its drop-ins";
    comfyui.enable = lib.mkEnableOption "the local CUDA-enabled ComfyUI application";
    whisperCuda.enable = lib.mkEnableOption "the local CUDA-enabled whisper.cpp CLI";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.archi.enable {
      home.packages = [ localPackages.archi ];

      home.file.".archi/dropins" = {
        source = "${localPackages.archiDropins}/share/archi-dropins";
        recursive = true;
      };

      home.file."Documents/Archi/scripts/.keep".text = "";
    })

    (lib.mkIf cfg.comfyui.enable {
      home.packages = [ localPackages.comfyui ];

      home.sessionVariables = {
        COMFYUI_DATA_DIR = "/home/ms/AI/comfyui";
        COMFYUI_PATH = "/home/ms/AI/comfyui";
        COMFYUI_URL = "http://127.0.0.1:8188";
      };

      xdg.desktopEntries.comfyui = {
        name = "ComfyUI";
        comment = "Local node-based generative media interface";
        exec = "${localPackages.comfyui}/bin/comfyui";
        categories = [ "Graphics" ];
        terminal = false;
      };
    })

    (lib.mkIf cfg.whisperCuda.enable {
      home.packages = [ localPackages.whisperCppCuda ];
    })
  ];
}
