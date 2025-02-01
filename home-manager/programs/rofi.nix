{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    theme = "/dev/null";
    font = "Libre Caslon Regular";
    extraConfig = {
      display-drun = "Applications";
      display-window = "Windows";
      drun-display-format = "{icon} {name}";
      modi = "window,run,drun";
      show-icons = true;
      border = 0;
      margin = 0;
      padding = 0;
      spacing = 0;
      width = "45%";
    };
    plugins = [
 #    pkgs.rofi-power-menu
 #    pkgs.rofi-systemd
 #    pkgs.rofi-mpd
    ];
  };
}
