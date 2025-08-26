{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "nixos";

    # wireless.enable = true;

    networkmanager.enable = true;

    extraHosts = ''
               10.0.0.108 pi
    '';

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  programs.nm-applet.enable = true;
}
