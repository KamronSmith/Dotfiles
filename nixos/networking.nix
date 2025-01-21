{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "nixos";

    wireless.enable = true;

    networkmanager.enable = true;

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  programs.nm-applet.enable = true;
}
