{ ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "BlackAndWhite";
      package = null;
    };
    iconTheme = {
      name = "hicolor";
      package = null;
    };
    font = {
      name = "Cantarell";
      package = null;
      size = 11;
    };
    cursorTheme = {
      name = "Adwaita";
      package = null;
      size = 0;
    };
    gtk2.extraConfig = ''
      include "/home/ms/.gtkrc.mine"
    '';
    gtk2.force = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };
  };
}
