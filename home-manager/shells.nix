{ config, pkgs, ... }:

{
  programs = {
    nushell = {
      enable = true;
        extraConfig = ''
                    let carapace_completer = {|spans| carapace $spans.0 nushell ...$spans | from json }
                   $env.config = {
                               show_banner: false,
                                completions: {
                                             case_sensitive: false
                                             partial: true
                                             algorithm: "fuzzy"
                                             external: {
                                                       enable: true
                                                       max_results: 100
                                                       completer: $carapace_completer
                                             }
                                }

                                edit_mode: emacs
                                shell_integration: {
                                                   osc2: true
                                                   osc7: true
                                                   osc8: true
                                                   osc9_9: true
                                                   osc133: true
                                                   osc633: true
                                                   reset_application_mode: true
                                }

                                buffer_editor: "emacsclient -c -a \"\""
                                color_config: {
                                              string: "#ffa07a"
                                              variable: "#eedd82"
                                }
                                keybindings: [{
                                             name: ctrl_backspace
                                             modifier: control
                                             keycode: backspace
                                             mode: emacs
                                             event: {edit: backspaceword }
                                }]
                  }
       '';
        environmentVariables = {
          EDITOR = "emacsclient -c -a \"\"";
          NIXOS_OZONE_WL = 1;
          NIXPKGS_ALLOW_UNFREE = 1;
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "wayland";
          GDK_BACKEND = "wayland";
          CLUTTER_BACKEND = "wayland";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOW_DECORATION = 0;
          QT_AUTO_SCREEN_SCALE_FACTOR = 1;
          SDL_VIDEO_DRIVER = "wayland";
          XCURSOR_SIZE = 24;
          MOZ_ENABLE_WAYLAND = 1;
          SSH_AUTH_SOCK= "~/.1password/agent.sock";
        };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    
  };
}
