{ ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    theme = ../../../home/.config/rofi/PitchBlack.rasi;
    extraConfig = {
      show-icons = true;
    };
  };
}
