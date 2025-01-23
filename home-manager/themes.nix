{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Arc-dark";
      package = pkgs.arc-theme;
    };
  };
}
