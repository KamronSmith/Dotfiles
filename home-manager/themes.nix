{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
  
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark"; ## to test
      style.package = pkgs.adwaita-qt;
    };

    home.pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 30;
    };
}
