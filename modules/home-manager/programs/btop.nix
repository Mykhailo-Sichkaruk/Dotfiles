{ ... }:

{
  programs.btop = {
    enable = true;
    extraConfig = builtins.readFile ../../../home/.config/btop/btop.conf;
  };
}
