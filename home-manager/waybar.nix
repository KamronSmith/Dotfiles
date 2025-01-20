{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "HDMI-A-4"
        ];
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "clock"
          "tray"
          "custom/power"
        ];
        "hyprland/workspaces" = {
          active-only = true;
        };
      };
    };
  };
}
