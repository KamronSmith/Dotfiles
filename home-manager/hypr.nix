{config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # systemd = {
      # enable = true;
    # };
    
    extraConfig = ''
           exec-once = dbus-update-activation-environment --systemd --all
           exec-once = hyprctl dispatch workspace name:Main
           exec-once = wl-paste --type text --watch cliphist store
           exec-once = wl-paste --type image --watch cliphist store

           monitor= HDMI-A-1,2560x1440@144,0x0,1
           $terminal = kitty
           $fileManager = emacsclient -c -a 
           $menu = rofi -show drun
           $editor = emacsclient -c -a ""

           general {
               gaps_in = 2
               gaps_out = 8
               border_size = 3
               col.active_border = rgba(33CCFFFF)
               col.inactive_border = rgba(00000000)
               no_border_on_floating = false
               resize_on_border = true
               resize_corner = 4
               allow_tearing = false
               layout = master
           }

           debug {
               disable_logs = true
           }

           decoration {
               rounding = 0
               active_opacity = 1.0
               inactive_opacity = 1.0
               shadow {
                      enabled = false
                      range = 4
                      render_power = 3
                      color = rgba(1a1a1aee)
                      color_inactive = rgba(00000000)
               }

               blur {
                    enabled = true
                    size = 6
                    passes = 3
                    new_optimizations = on
                    vibrancy = 0.1696
                    xray = true
               }
           }

           animations {
                      enabled = true
                      bezier = easeOutQuint,0.23,1,0.32,1
                      bezier = easeInOutCubic,0.65,0.05,0.36,1
                      bezier = linear,0,0,1,1
                      bezier = almostLinear,0.5,0.5,0.75,1.0
                      bezier = quick,0.15,0,0.1,1
                      animation = global, 1, 10, default
                      animation = border, 1, 5.39, easeOutQuint
                      animation = windows, 1, 4.79, easeOutQuint
                      animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
                      animation = windowsOut, 1, 1.49, linear, popin 87%
                      animation = fadeIn, 1, 1.73, almostLinear
                      animation = fadeOut, 1, 1.46, almostLinear
                      animation = fade, 1, 3.03, quick
                      animation = layers, 1, 3.81, easeOutQuint
                      animation = layersIn, 1, 4, easeOutQuint, fade
                      animation = layersOut, 1, 1.5, linear, fade
                      animation = fadeLayersIn, 1, 1.79, almostLinear
                      animation = fadeLayersOut, 1, 1.39, almostLinear
                      animation = workspaces, 1, 1.94, almostLinear, fade
                      animation = workspacesIn, 1, 1.21, almostLinear, fade
                      animation = workspacesOut, 1, 1.94, almostLinear, fade
           }

           master {
                  new_status = master
                  mfact = 0.50
                  orientation = center
           }

           misc {
                force_default_wallpaper = 0
                disable_hyprland_logo = true
                vrr = on
           }

           input {
                 kb_layout = us
                 kb_variant =
                 kb_model =
                 kb_options =
                 kb_rules =
                 follow_mouse = 1
                 sensitivity = 0
                 touchpad {
                          natural_scroll = false
                 }
           }

           $mainMod = ALT

           bind = $mainMod, C, fullscreen, 0
           bind = $mainMod, Q, killactive
           bind = $mainMod, E, exec, $fileManager
           bind = $mainMod, V, togglefloating
           bind = $mainMod, M, exit
           # bind = $mainMod, F, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy
           bind = Control_L&Super_L&Shift_L&Alt_L, B, exec, $menu
           bind = Control_L&Super_L&Shift_L&Alt_L, D, exec, playerctl play-pause
           bind = Control_L&Super_L&Shift_L&Alt_L, W, exec, $editor
           bind = $mainMod, Tab, exec, rofi -show window
           bind = $mainMod, X, togglespecialworkspace, kitty

           bind = $mainMod, b, movefocus, l
           bind = $mainMod, n, movefocus, d
           bind = $mainMod, p, movefocus, u
           bind = $mainMod, f, movefocus, r
           bind = $mainMod, i, layoutmsg, swapwithmaster
           bind = Control_L&Super_L&Shift_L&Alt_L, A, focuscurrentorlast

           bind = $mainMod, d, workspace, name:Main
           bind = $mainMod, r, workspace, name:Side
           bind = $mainMod, t, workspace, name:Gaming
           # bind = $mainMod, s, workspace, 4
           # bind = $mainMod, 5, workspace, 5
           # bind = $mainMod, 6, workspace, 6
           # bind = $mainMod, 7, workspace, 7

           bind = $mainMod SHIFT, d, movetoworkspacesilent, name:Main
           bind = $mainMod SHIFT, r, movetoworkspacesilent, name:Side
           bind = $mainMod SHIFT, t, movetoworkspacesilent, name:Gaming
           bind = $mainMod SHIFT, s, movetoworkspacesilent, 4
           bind = $mainMod SHIFT, 5, movetoworkspace, 5
           bind = $mainMod SHIFT, 6, movetoworkspace, 6
           bind = $mainMod SHIFT, 7, movetoworkspace, 7
           bind = $mainMod SHIFT, 8, movetoworkspace, 8
           bind = $mainMod SHIFT, 9, movetoworkspace, 9
           bind = $mainMod SHIFT, 0, movetoworkspace, 10

           bind = $mainMod, mouse_down, workspace, e+1
           bind = $mainMod, mouse_up, workspace, e-1

           bindm = $mainMod, mouse:272, movewindow
           bindm = $mainMod, mouse:273, resizewindow

           bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
           bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
           bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
           bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
           bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
           bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

           bindl = , XF86AudioNext, exec, playerctl next
           bindl = , XF86AudioPause, exec, playerctl play-pause
           bindl = , XF86AudioPlay, exec, playerctl play-pause
           bindl = , XF86AudioPrev, exec, playerctl previous

           windowrulev2 = suppressevent maximize, class:.*
           windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
           windowrulev2 = workspace name:Side,class:^(kitty)$,title:^(kitty)$
           windowrulev2 = workspace name:Main,class:^(Emacs)$
           windowrulev2 = workspace name:Main,class:^(firefox)$

           ## smart gaps
           # workspace = w[tv1], gapsout:0, gapsin:0
           # workspace = f[1], gapsout:0, gapsin:0
           # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
           # windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
           # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
           # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

           windowrulev2 = opacity 0.80 0.80, class:^(Emacs)$
           windowrulev2 = opacity 0.80 0.80, class:^(Kitty)$

           workspace = name:Main,default:true,monitor:HDMI-A-1,id:1
           workspace = name:Side,monitor:HDMI-A-1,id:2
           workspace = name:Gaming,monitor:HDMI-A-1,id:3
           workspace = special:kitty

           layerrule = blur,waybar

           # gaming
           windowrulev2 = float,class:^(steam)$
           windowrulev2 = workspace name:Gaming,class:^(steam)$,title:^(Steam)$
           windowrulev2 = fullscreen,class:^steam_app\d+$
           windowrulev2 = workspace name:Gaming,class:^steam_app_\d+$
           windowrulev2 = workspace name:Gaming,class:^Minecraft\*
           workspace = Gaming, border:false, rounding:false

           # dialogs
           windowrulev2 = center,title:^(Open File)(.*)$
           windowrulev2 = center,title:^(Select a File)(.*)$
           windowrulev2 = center,title:^(Choose wallpaper)(.*)$
           windowrulev2 = center,title:^(Open Folder)(.*)$
           windowrulev2 = center,title:^(Save As)(.*)$
           windowrulev2 = center,title:^(Library)(.*)$
           windowrulev2 = center,title:^(File Upload)(.*)$

           windowrulev2 = float,title:^(Open File)(.*)$
           windowrulev2 = float,title:^(Select a File)(.*)$
           windowrulev2 = float,title:^(Choose wallpaper)(.*)$
           windowrulev2 = float,title:^(Open Folder)(.*)$
           windowrulev2 = float,title:^(Save As)(.*)$
           windowrulev2 = float,title:^(Library)(.*)$
           windowrulev2 = float,title:^(File Upload)(.*)$

           # Picture-in-Picture
           windowrulev2 = keepaspectratio,title:^(Picture(-| )in(-| )[Pp]icture)$
           windowrulev2 = move 73% 72%,title:^(Picture(-| )in(-| )[Pp]icture)$ 
           windowrulev2 = size 25%,title:^(Picture(-| )in(-| )[Pp]icture)$
           windowrulev2 = float,title:^(Picture(-| )in(-| )[Pp]icture)$
           windowrulev2 = pin,title:^(Picture(-| )in(-| )[Pp]icture)$

           # floats
           windowrulev2 = float,title:^(Volume Control)$
           windowrulev2 = float,title:^(Bluetooth Devices)$
           windowrulev2 = float,class:^(1Password)$
           
         '';    
  };
}
