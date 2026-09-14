let
  selectedTheme = "tokyonight-high-contrast";

  themes = {
    tokyonight-high-contrast = ./tokyonight-high-contrast.nix;
    tokyonight = ./tokyonight.nix;
  };
in
{
  imports = [
    themes.${selectedTheme}
  ];
}
