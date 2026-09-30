{ pkgs, ... }:


{

  services.sxhkd = {
    enable = true;
    extraConfig = ''
      # brightness control
      XF86MonBrightness{Up,Down}
        ${pkgs.brightnessctl}/bin/brightnessctl set {10%+, 10%-}

      # volume control
      XF86Audio{Raise,Lower}Volume
        ${pkgs.pulsemixer}/bin/pulsemixer --change-volume {+,-}5 --max-volume 100

      # volume toggle mute
      XF86AudioMute
        ${pkgs.pulsemixer}/bin/pulsemixer --toggle-mute

      XF86Audio{Next,Prev}
        ${pkgs.playerctl}/bin/playerctl --all-players {next,previous}

      XF86AudioPlay
        ${pkgs.playerctl}/bin/playerctl --all-players play-pause

      XF86AudioStop
        ${pkgs.playerctl}/bin/playerctl --all-players stop

      XF86AudioRewind
        ${pkgs.playerctl}/bin/playerctl --all-players play

      XF86AudioPause
        ${pkgs.playerctl}/bin/playerctl --all-players play-pause


      # screenshot
      Print
        ${pkgs.flameshot}/bin/flameshot gui

      ctrl + Print
        ${pkgs.flameshot}/bin/flameshot full
    '';
  };
}
