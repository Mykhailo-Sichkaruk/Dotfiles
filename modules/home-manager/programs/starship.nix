{ config, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML (
      builtins.readFile ../../../home/.config/starship.toml
    );
  };

  home.file."${config.xdg.configHome}/starship.toml".force = true;
}
