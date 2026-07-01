local window_rules = {}

hl.window_rule({
    name = "Fix Xwayland Drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "Firefox",
    match = { class = "^(firefox)$" },
    workspace = 1,
})

hl.window_rule({
    name = "Emacs",
    match = { class = "^(emacs)$" },
    workspace = 2,
    opacity = "1.0 1.0"
})

hl.window_rule({
    name = "Suppress",
    match = { class = ".*" },
    suppress_event = "maximize activate activatefocus",
})

hl.window_rule({
    name = "Steam",
    match = { class = "^(steam)$", title = "^(Steam)$" },
    workspace = 3,
})

hl.window_rule({
    name = "Steam Games",
    match = { class = "steam_app_" }, --maybe?
    fullscreen = true,
    workspace = 3,
})

hl.window_rule({
    name = "Idle Inhibit",
    match = { class = ".*" },
    idle_inhibit = "fullscreen",
})

hl.window_rule({
    name = "Open File Dialog",
    match = { title = "^(Open File)(.*)$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "Select File Dialog",
    match = { title = "^(Select a File)(.*)$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "Choose Wallpaper Dialog",
    match = { title = "^(Choose wallpaper)(.*)$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "Open Folder Dialog",
    match = { title = "^(Open Folder)(.*)$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "Save As Dialog",
    match = { title = "^(Save As)(.*)$" },
    center = true,
    float = true,
})


hl.window_rule({
    name = "Library Dialog",
    match = { title = "^(Library)(.*)$" },
    center = true,
    float = true,
})


hl.window_rule({
    name = "File Upload Dialog",
    match = { title = "^(File Upload)(.*)$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "Picture in Picture",
    match = { title = "^(Picture(-| )in(-| )[Pp]icture)$" },
    keep_aspect_ratio = true,
    -- move = "",
    size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
    float = true,
    pin = true,
})

hl.window_rule({
    name = "Volume Control",
    match = { title = "^(Volume Control)$" },
    float = true,
})


hl.window_rule({
    name = "Bluetooth Devices",
    match = { title = "^(Bluetooth Devices)$" },
    float = true,
})

hl.window_rule({
    name = "Anki",
    match = { class = "^(anki)$" },
    float = true,
})

return window_rules
