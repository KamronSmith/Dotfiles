{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        output = "HDMI-A-1";
        position = "top";
        height = 30;
        
        modules-left = [
          "cpu"
          "memory"
          "network"
          "hyprland/workspaces"
        ];
        
        modules-center = [
          "clock"
          "hyprland/window"
        ];
        
        modules-right = [
          "mpris"
          "pulseaudio"
          "tray"
          "custom/power"
          "clock"
        ];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            Main = "";
            Side = "";
            Gaming = "󰊴";
          };
          on-click = "activate";
          persistent-workspaces = {
            "*" = [ "Main" "Side" "Gaming" ];
          };
          sort-by = "id";
        };

        "hyprland/window" = {
          max-length = 70;
        };

        "cpu" = {
          interval = 5;
          format = "  {usage}%";
          max-length = 10;
        };

        "memory" = {
          interval = 30;
          format = "  {used:0.1f}GB";
          format-alt = "  {}%";
          max-length = 10;
        };

        "network" = {
          format = "{icon}";
          format-ethernet = "󰈁";
          format-disconnected = "󰈂";
        };

        "clock" = {
          format = "<b>{:%H:%M %b %d %Y}</b>";
          format-alt = "{:%b %d %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pamixer -t";
          on-scroll-up = "pamixer -i 1";
          on-scroll-down = "pamixer -d 1";
          on-click-right = "exec pavucontrol-qt";
          tooltip-format = "Volume {volume}%";
          scroll-step = 1;
        };

        "tray" = {
          spacing = 10;
        };

        "mpris" = {
          format = "{player_icon} {title}";
          format-paused = " {status_icon} <i>{title}</i>";
          max-length = 80;
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
        };
      };
    };

    style = ''
        * {
          font-family: Iosevka Comfy, JetBrainsMono Nerd Font;
          font-size: 17px;
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          /* 26 27 38 0.5 */
          background-color: #000000; 
          color: #ffffff;
          opacity: 0.8;
        }

        /* General styling for the individual modules */
        #clock,
        #cpu,
        #memory,
        #mpris,
        #workspaces,
        #window,
        #tray {
          background-color: #222034;
          font-size: 14px;
          color: #8a909e;
          padding: 3px 8px;
          border-radius: 8px;
          margin: 8px 2px;
          opacity: 1.0;
        }

        #workspaces button.active {
          color: #bbbbbb;
        }

        #network,
        #pulseaudio {
          background-color: #222034;
          font-size: 20px;
          padding: 3px 8px;
          margin: 8px 2px;
          border-radius: 8px;
        }

        #cpu { color: #fb958b; }

        #network.ethernet { color: #50C878; }
        #network.disconnected { color: #90EE90; }

        
      '';
  };
}
