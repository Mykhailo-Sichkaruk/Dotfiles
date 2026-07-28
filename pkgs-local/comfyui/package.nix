{
  comfyuiPackage,
  writeShellApplication,
}:

writeShellApplication {
  name = "comfyui";
  runtimeInputs = [ comfyuiPackage ];
  text = ''
    comfyui_data_dir="''${COMFYUI_DATA_DIR:-$HOME/AI/comfyui}"

    exec ${comfyuiPackage}/bin/comfy-ui \
      --base-directory "$comfyui_data_dir" \
      --enable-manager \
      --enable-assets \
      --lowvram \
      --preview-method none \
      --open \
      "$@"
  '';
}
