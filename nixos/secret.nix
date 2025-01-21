{ config, lib, pkgs, ... }:
{
  programs._1password-gui = {
    polkitPolicyOwners = [ "kam" ];
  };
}
