{ config, lib, pkgs, ... }:
{
  programs._1password = {
    enable = true;
  };
  
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "kam" ];
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
