{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./themes.nix
    ./shells.nix
    ./xdg.nix
    ./secrets.nix
    ./services.nix
    ./hypr.nix
    ./programs/emacs.nix
    ./programs/git.nix
    ./programs/waybar.nix
    ./programs/rofi.nix
    ./programs/browsers.nix
    ./programs/term.nix
    ./programs/direnv.nix
  ];
  
  home.username = "kam";
  home.homeDirectory = "/home/kam";
  
  home.packages = with pkgs; [
    # system utilities
    hyprpolkitagent
    inputs.hyprland-qtutils.packages."${pkgs.system}".default
    pavucontrol
    dunst
    bluez
    bluez-tools
    blueman
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
    wl-clipboard
    cliphist
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
    mpvpaper
    ffmpeg
    neofetch
    vlc
    mpv
    emacs30
    calibre
    remmina
    anki
    anki-sync-server
    pamixer
    playerctl
    waybar-mpris
    wayshot
    prismlauncher
  ];
  
  home.file = {
    
  };

  # xdg.configFile = {
  #   "hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/user/hyprland.conf";
  # };
  
  home.sessionVariables = {
    # Doesnt work with nushell
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
