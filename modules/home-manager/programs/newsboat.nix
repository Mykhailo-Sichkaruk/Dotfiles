{ ... }:

{
  programs.newsboat = {
    enable = true;
    browser = "vieb";
    autoReload = true;
    reloadTime = 60;
    extraConfig = builtins.readFile ../../../home/.newsboat/config;
  };

  home.file.".newsboat/urls".source = ../../../home/.newsboat/urls;
}
