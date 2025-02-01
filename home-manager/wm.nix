{config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    
    extraConfig = ''
           exec-once = dbus-update-activation-environment --systemd --all

           monitor=HDMI-A-4, 1920x1080@60,1920x0, 1
           monitor=DVI-D-1, 1920x1080@60, 0x0, 1

           $terminal = kitty
           $fileManager = emacsclient -c -a 
           $menu = rofi -show drun
           $editor = emacsclient -c -a ""

           general {
               gaps_in = 3
               gaps_out = 8
               border_size = 2
               col.active_border = rgba(ff444444)
               col.inactive_border = rgba(00000000)
               resize_on_border = false
               allow_tearing = false
               layout = master
           }

           decoration {
               rounding = 10
               active_opacity = 1.0
               inactive_opacity = 1.0
               shadow {
                      enabled = true
                      range = 4
                      render_power = 3
                      color = rgba(1a1a1aee)
               }

               blur {
                    enabled = true
                    size = 6
                    passes = 3
                    new_optimizations = on
                    vibrancy = 0.1696
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
           }
           misc {
                force_default_wallpaper = 0
                disable_hyprland_logo = true
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

bind = $mainMod, F, exec, $terminal
bind = $mainMod, C, killactive,
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, V, togglefloating,
bind = Control_L&Super_L&Shift_L&Alt_L, B, exec, $menu
bind = Control_L&Super_L&Shift_L&Alt_L, W, exec, $editor
bind = $mainMod, Tab, exec, rofi -show window

bind = $mainMod, e, layoutmsg, cycleprev
bind = $mainMod, n, layoutmsg, cyclenext
bind = $mainMod, i, layoutmsg, swapwithmaster master
bind = Control_L&Super_L&Shift_L&Alt_L, A, focuscurrentorlast

bind = $mainMod, d, workspace, name:main
bind = $mainMod, r, workspace, name:side
# bind = $mainMod, t, workspace, 3
# bind = $mainMod, s, workspace, 4
# bind = $mainMod, 5, workspace, 5
# bind = $mainMod, 6, workspace, 6
# bind = $mainMod, 7, workspace, 7

bind = $mainMod SHIFT, d, movetoworkspace, name:main
bind = $mainMod SHIFT, r, movetoworkspace, name:side
bind = $mainMod SHIFT, t, movetoworkspace, 3
bind = $mainMod SHIFT, s, movetoworkspace, 4
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
windowrule = workspace:side, ^(firefox)$
windowrulev2 = opacity 0.80 0.80, class:^(Emacs)$
windowrulev2 = opacity 0.80 0.80, class:^(kitty)$
workspace = name:main, monitor:HDMI-A-4
workspace = name:side, monitor:DVI-D-1
                  '';
  };
}
