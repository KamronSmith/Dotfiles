{ pkgs, config, lib, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Comfy Duo";
      size = 14;
    };
    extraConfig = ''
    window_padding_width 3
    '';
  };
}
