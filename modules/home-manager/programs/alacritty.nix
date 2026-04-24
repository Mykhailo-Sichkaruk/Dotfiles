{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (
      builtins.readFile ../../../home/.config/alacritty/alacritty.toml
    );
  };
}
