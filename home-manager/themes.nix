{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Arc-dark";
      package = pkgs.arc-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };
}
