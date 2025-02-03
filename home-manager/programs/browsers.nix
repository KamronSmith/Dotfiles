{ config, pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.kam = {
      search = {
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
      };

      bookmarks = {};
      settings = {
        "browser.startup.homepage" = "about.home";
      };
    };
  };
}
