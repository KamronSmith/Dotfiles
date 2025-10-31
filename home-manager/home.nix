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
    udiskie
    udisks
    backintime-qt
    gdb
    # coding
    git
    python3
    bootdev-cli
    docker
    gcc
    man-pages
    man-pages-posix
    direnv
    cmake # for Emacs + Vterm
    libtool
    clang-tools
    clang-manpages
    cppcheck
    tmux
    # user apps
    kdePackages.qt6ct
    ghostty
    waybar
    gimp
    rofi-wayland
    swww
    mpvpaper
    ffmpeg
    vlc
    reaper # audio
    davinci-resolve # editing
    bitwig-studio # music
    obs-studio # recording screen
    calibre
    syncthing
    libreoffice
    anki
    pamixer
    playerctl
    waybar-mpris
    obsidian
    wayshot
    slurp
    prismlauncher
    qbittorrent
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
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
    ".config/emacs/init.el" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/init.el";
    };
    ".config/emacs/early-init.el" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/early-init.el";
    };
  };

  home.sessionPath = [
    "/home/kam/.dotfiles/bin/"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
