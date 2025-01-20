{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacs30;
    defaultEditor = true;
    socketActivation.enable = true;
    startWithUserSession = true;
  };

  services.lorri.enable = true;

  systemd.user.enable = true;

  systemd.user.services = {
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
}
