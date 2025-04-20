{ pkgs, lib, config, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    virtualbox.host.enable = true;
  };

  users.extraGroups.vboxusers.members = [ "kam" ];
}
