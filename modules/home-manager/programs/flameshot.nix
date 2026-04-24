{ ... }:

{
  services.flameshot = {
    enable = true;
    settings.General = {
      contrastOpacity = 188;
      drawColor = "#0000ff";
      drawThickness = 6;
      saveLastRegion = true;
      savePath = "/home/ms/recording";
    };
  };

  xdg.configFile."flameshot/flameshot.ini".force = true;
}
