{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.kam = {
      search = {
        force = true;
      };

      bookmarks = {};
      settings = {
        "browser.startup.homepage" = "about.home";
      };
    };
  };
}
