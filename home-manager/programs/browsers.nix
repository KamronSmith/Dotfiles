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

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        vimium
        ublock-origin
        
        # onepassword-password-manager
        ## have to figure out 1password
      ];
      
      bookmarks = {};
      settings = {
        "browser.startup.homepage" = "about:home";
      };
    };
  };
}
