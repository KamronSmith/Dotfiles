{ pkgs, config, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      background = "000000";
      foreground = "ffffff";
      font-size = 15;
      font-family = "Iosevka Comfy";
      font-family-bold = "Iosevka Comfy Bold";
      font-family-italic = "Iosevka Comfy Italic";
      font-family-bold-italic = "Iosevka Comfy Bold Italic";
    };
  };
}
