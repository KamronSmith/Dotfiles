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
    gnupg
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
    backintime-qt
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
    clang-tools
    clang-manpages
    cppcheck
    tmux
    # user apps
    OVMF
    megasync
    ghostty
    kitty
    virtualbox
    waybar
    gimp
    rofi-wayland
    swww
    mpvpaper
    ffmpeg
    neofetch
    vlc
    mpv
    emacs30
    calibre
    libreoffice
    remmina
    anki
    pamixer
    playerctl
    waybar-mpris
    lutris
    obsidian
    wayshot
    slurp
    prismlauncher
    nexusmods-app-unfree
  ];
  
  home.file = {
    ".config/tmux/tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/tmux.conf";
    };
    ".config/nvim/init.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/init.lua";
    };
    ".config/kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/kitty.conf";
    };
  };
  
  home.sessionVariables = {
    # Doesnt work with nushell
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
