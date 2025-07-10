# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./secret.nix
      ./virtualization.nix
      ./networking.nix
      ./services.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };
  
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia-modeset"
    "nvidia-drm"
    "nvidia-uvm"
  ];

  boot.kernelParams = [
    "quiet"
    "splash"
    "amd_iommu=on"
  ];

  boot.extraModprobeConfig = ''
  options nvidia-drm fbdev=1
  options nvidia-drm modeset=1
  '';

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  xdg.icons.enable = true;  
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };
  
  # Enable the LXQT Desktop Environment.
  services.displayManager = {
    enable = true;
    defaultSession = "hyprland-uwsm";
    # autoLogin = {
    #   enable = true;
    #   user = "kam";
    # };
  };

  services.xserver.displayManager.gdm = {
    enable = true;
  };
  
  services.xserver.desktopManager.plasma5 = {
    enable = true;
  };

  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.devmon.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  
  # Enable cups to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kam = {
    isNormalUser = true;
    shell = pkgs.zsh;
    useDefaultShell = true;
    description = "Kamron Smith";
    extraGroups = [ "docker" "libvirtd" "networkmanager" "wheel" "storage" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  # Enable automatic login for the user.

   security.polkit.enable = true;
   programs._1password.enable = true;
   
  # Install firefox.
   programs.firefox.enable = true;

   programs.steam = {
     enable = true;
   };

   programs.gamemode.enable = true;

  # Allow unfree packages
   nixpkgs.config = {
     allowUnfree = true;
     allowUnfreePredicate = (_: true);
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    zsh
    nushell
    discord
    git
    google-chrome
    _1password-gui
    _1password-cli
    terraform
    man-pages
    duplicati
    seatd
    (import ../bin/aws-op-credential-helper.nix { inherit pkgs; })
    #  wget
  ];

  environment.pathsToLink = [
    "/share/zsh"
  ];

  programs.nix-ld.enable = true;

  fonts.packages = [
    pkgs.iosevka-comfy.comfy
    pkgs.iosevka-comfy.comfy-duo
    pkgs.libre-caslon
    pkgs.garamond-libre
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.noto-fonts-cjk-sans ## japanese fonts
  ];

 fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting =  {
      enable = true;
      style = "full";
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

 hardware.nvidia = {
  package = config.boot.kernelPackages.nvidiaPackages.beta;
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = true;
};
  
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # List services that you want to enable:

  virtualisation.docker = {
    enable = true;
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      "kam" = import ../home-manager/home.nix;
    };
  };

  services.duplicati.enable = true;
  
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "9:00";
    randomizedDelaySec = "45min";
  };

  nix.settings = {
    experimental-features = [ "nix-command flakes" ];
    substituters = [ "https://hyprland.cachix.org" ]; # hyprland caching
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ]; # hyprland caching
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10";
  };
}
