{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./themes.nix
    ./shells.nix
    ./default-apps.nix
    ./secrets.nix
    ./services.nix
    ./wm.nix
    ./programs/waybar.nix
    ./programs/rofi.nix
    ./programs/browsers.nix
    ./programs/term.nix
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
    # system utilities
    hyprpolkitagent
    pavucontrol
    dunst
    bluez
    bluez-tools
    ripgrep
    fd
    ripgrep-all
    findutils
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
    gdb
    # coding
    git
    docker
    gcc
    direnv
    cmake # for Emacs + Vterm
    libtool
    awscli2
    gh
    # user apps
    kitty
    waybar
    rofi-wayland
    swww
    neofetch
    vlc
    mpv
    emacs30
    calibre
    remmina
    anki
    pamixer
    playerctl
    waybar-mpris
    wayshot
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
