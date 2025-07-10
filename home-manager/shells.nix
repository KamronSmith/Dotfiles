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
                                keybindings: [
                                             {
                                              name: test_keybind
                                              modifier: control
                                              keycode: char_h
                                              mode: emacs
                                              event: { edit: backspaceword }
                                             }
                                ]
                  }
       '';
        environmentVariables = {
          LIBVA_DRIVER_NAME = "nvidia";
          NVD_BACKEND = "direct";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          EDITOR = "emacsclient -c -a \"\"";
          TERM = "kitty";
          NIXOS_OZONE_WL = 1;
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          NIXPKGS_ALLOW_UNFREE = 1;
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "wayland";
          GDK_BACKEND = "wayland";
          CLUTTER_BACKEND = "wayland";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOW_DECORATION = 0;
          QT_AUTO_SCREEN_SCALE_FACTOR = 1;
          GTK_THEME = "adw-gtk";
          SDL_VIDEO_DRIVER = "wayland";
          XCURSOR_THEME = "Bibata-Modern-Ice";
          XCURSOR_SIZE = 30;
          MOZ_ENABLE_WAYLAND = 1;
          SSH_AUTH_SOCK= "~/.1password/agent.sock";
          # WAYLAND_DISPLAY = ":0";
          # DISPLAY = ":0";
        };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    zsh = {
      enable = true;
      autocd = true;
      cdpath = [ " . ~ " ];
      sessionVariables = {
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "30";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        EDITOR = "emacsclient -c -a \"\"";
        TERM = "kitty";
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
        MOZ_ENABLE_WAYLAND = 1;
        SSH_AUTH_SOCK= "~/.1password/agent.sock";
        # WAYLAND_DISPLAY = ":0";
        # DISPLAY = ":0";
      };
      shellAliases = {
        ll = "ls -al";
      };
      dotDir = ".config/zsh";
      enableCompletion = true;
      history = {
        share = true;
        size = 10000;
        expireDuplicatesFirst = true;
      };
      initContent = ''
        setopt AUTOPUSHD
        setopt NO_CASE_GLOB
        setopt NO_CASE_MATCH
      '';
    };

    bash = {
      enable = true;
      historyControl = ["ignoredups"];
      enableVteIntegration = true;
      shellAliases = {
        ll = "ls -l";
        ".." = "cd ..";
      };      
    };
  };
}
