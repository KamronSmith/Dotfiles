{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        output = "DP-2";
        position = "top";
        height = 25;
        
        modules-left = [
          "hyprland/workspaces"
          "memory"
          "cpu"
          "network"
        ];
        
        modules-center = [
          "clock"
        ];
        
        modules-right = [
          "mpris"
          "pulseaudio"
          "tray"
          "custom/power"
        ];
        
        "hyprland/workspaces" = {
          format = "{name}: {icon}";
          format-icons = {
            active = "";
            default = "";
          };
          on-click = "activate";
          persistent-workspaces = {
            "*" = [ "1" "2" "3" ];
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
       font-family: SauceCodePro Mono Nerd Font;
       font-size: 14px;
       min-height: 0;
       padding-right: 2px;
       padding-left: 2px;
       padding-bottom: 0px;
       }

       #waybar {
       background: transparent;
       color: #c6d0f5;
       margin: 2px 2px;
       }
       
       #workspaces {
       border-radius: 5px;
       margin: 5px;
       background: #101010;
       margin-left: 2px;
       }
       
       #workspaces button {
       color: #babbf1;
       border-radius: 5px;
       padding: 0.4rem;
       }
       
       #workspaces button.active {
       color: #99d1db;
       border-radius: 5px;
       }
       
       button {
       background: transparent;
       }
       
       #workspaces button:hover {
       background: #1e1e1e;
       border: 0px solid transparent;
       }
       
       #tray,
       #clock,
       #pulseaudio,
       #network,
       #cpu,
       #memory,
       #mpris {
                      background-color: #101010;
                      padding: 0.5rem 1rem;
                      margin: 5px 0;
       }
       
       #clock {
              color: #8caaee;
              border-radius: 5px;
       }
              
       #pulseaudio {
                   color: #ea999c;
                   border-radius: 5px 0px 0px 5px;
       }
          '';
  };
}
