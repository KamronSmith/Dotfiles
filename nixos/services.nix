{ config, lib, pkgs, ... }:

{
  services.anki-sync-server = {
    enable = true;
  };
}
