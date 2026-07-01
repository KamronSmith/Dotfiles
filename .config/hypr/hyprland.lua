local rules = require("window-rules")
local binds = require("binds")

hl.on("hyprland.start", function ()
                            hl.exec_cmd("wl-paste --type text --watch cliphist store")
                            hl.exec_cmd("wl-paste --type image --watch cliphist store")
                            hl.exec_cmd("dbus-update-activation-environment --systemd --all")
                            hl.exec_cmd("firefox")
                            hl.exec_cmd("hyprpaper")
                            hl.exec_cmd("udiskie")
                        end)

hl.monitor({
    output = "DP-5",
    mode = "2560x1440@144",
    position = "0x0",
    scale = 1,
})

hl.config({
    general = {
        gaps_in = 8,
        gaps_out = 20,
        border_size = 0,
        -- col.active_border = "#ffffffff",
        -- col.inactive_border = "#ffffffff",
        resize_on_border = true,
        resize_corner = 4,
        allow_tearing = false,
        layout = "master"
    },

    debug = {
        disable_logs = true
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.15,

        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "#1a1a1aee",
            color_inactive = "#00000000"
        },

        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true,
            vibrancy = 0.1696,
            xray = true
        }
    },

    animations = {
        enabled = false
    },

    master = {
        new_status = "master",
        mfact = 0.50,
        orientation = "center",
    },

    input = {
        kb_layout = "us",
        touchpad = {
            natural_scroll = false
        }
    },

    misc = {
        force_default_wallpaper = 0,
        vrr = 1,
        disable_hyprland_logo = true,
        disable_splash_rendering = false,
        focus_on_activate = false
    }
})
