{
  gnugrep,
  writeShellApplication,
  xrandr,
  dpi ? 112,
}:

writeShellApplication {
  name = "laptop-display-layout";
  runtimeInputs = [
    gnugrep
    xrandr
  ];
  text = ''
    set -euo pipefail

    if xrandr --query | grep -q '^HDMI-A-1-0 connected'; then
      xrandr \
        --output eDP-1-0 --primary \
        --output HDMI-A-1-0 --mode 2560x1440 --rate 143.99 --above eDP-1-0 \
        --dpi ${toString dpi}
    elif xrandr --query | grep -q '^HDMI-A-0 connected'; then
      xrandr \
        --output eDP --primary \
        --output HDMI-A-0 --mode 2560x1440 --rate 143.99 --above eDP \
        --dpi ${toString dpi}
    elif xrandr --query | grep -q '^eDP-1-0 connected'; then
      xrandr --output eDP-1-0 --primary --auto --dpi ${toString dpi}
    else
      xrandr --output eDP --primary --auto --dpi ${toString dpi} || xrandr --dpi ${toString dpi}
    fi
  '';
}
