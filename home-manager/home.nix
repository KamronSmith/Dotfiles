{ inputs, outputs, lib, config, pkgs, ... }:
{

  imports = [
    ./sh.nix
    ./services.nix
    ./wm.nix
    ./waybar.nix
    ./firefox.nix
  ];

  nixpkgs = {
    # overlays = [
    #   outputs.overlays.additions
    #   outputs.overlays.modifications
    #   outputs.overlays.unstable-packages
    # ];

    config = {
      allowUnfree = true;
    };
  };
  home.username = "kam";
  home.homeDirectory = "/home/kam";

  programs = {
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      config = {
        hideEnvDiff = true;
        strictEnv = true;
      };
    };
  };
  
  home.packages = with pkgs; [
    git
    docker
    gcc
    kitty
    waybar
    direnv
    rofi-wayland
    swww
    bluez
    bluez-tools
    ripgrep
    fd
    neofetch
    zip
    unzip
    dnsutils
    socat
    nmap
    file
    which
    btop
    strace
    ltrace
    lsof # list open files
    sysstat
    pciutils # lspci
    usbutils # lsusb
    emacs
    ripgrep-all
    findutils
    calibre
    cmake # for Emacs + Vterm
    libtool
    awscli2
    gh
    remmina
  ];

  home.file = {
  };

  # xdg.configFile = {
  #   "hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/user/hyprland.conf";
  # };

  programs.git = {
    enable = true;
    userName = "Kamron";
    userEmail = "kamrosmith@gmail.com";
  };

  systemd.user.startServices = "sd-switch";

  programs.emacs = {
    package = pkgs.emacs30;
  };
  
  home.sessionVariables = {
    # Doesnt work with nushell
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

 home.stateVersion = "24.11";
}
