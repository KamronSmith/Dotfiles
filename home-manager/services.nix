{ config, pkgs, ... }:

{
  systemd.user = {
    enable = true;
    startServices = "sd-switch";
    sessionVariables = {
      QT_QPA_PLATFORM_THEME = "gtk3";
      TERM = "xterm-kitty";
    };
    
    services = {
      wallpaper = {
        Unit = {
          Description = "Manages the desktop wallpaper";
        };
        
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "always";
          RestartSec = 1;
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
  
  services.emacs = {
    enable = true;
    package = pkgs.emacs30;
    defaultEditor = true;
    socketActivation.enable = true;
    startWithUserSession = true;
  };

  services.lorri.enable = true;
}
