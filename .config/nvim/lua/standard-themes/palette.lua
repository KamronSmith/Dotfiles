local M = {}
-- A lot of the colors that define `code-colors` are taken from my Emacs' kam-decolorify-mode. This mode turns off a lot of the colors that are present because of treesitter and the like to make a more readable, uniform experience. I have annotated the changed colors with what they would have been if the mode was not 'enabled'.

M.colors = {
    bg = "#000000",
    fg = "#ffffff",
    bg_dim = "#272727",
    fg_dim = "#a6a6a6",
    cursor = "#f9d82b",
    red = "#ff6f60",
    red_warmer = "#ff7f24",
    red_cooler = "#ff778f",
    red_faint = "#ee5c42",
    green = "#44cc44",
    green_warmer = "#7abd0f",
    green_cooler = "#98fb98",
    green_faint = "#61a06c",
    yellow = "#eedd82",
    yellow_warmer = "#fec43f",
    yellow_cooler = "#ffa07a",
    yellow_faint = "#dfb08f",
    blue = "#87ceff",
    blue_warmer = "#80aaff",
    blue_cooler = "#02cfff",
    blue_faint = "#b0c4de",
    magenta = "#df8faf",
    magenta_warmer = "#ff8fe7",
    magenta_cooler = "#ce82ff",
    magenta_faint = "#efafdf",
    cyan = "#00ffff",
    cyan_warmer = "#87cefa",
    cyan_cooler = "#7fffd4",
    cyan_faint = "#6acbcb",
    err = "#ff6f60", -- red
    warning = "#fec43f", -- yellow_warmer
    info = "#44cc44",             -- green
    builtin = "#ffffff",         -- blue_faint
    comment = "#ff7f24",        -- red_warmer
    constant = "#ffffff",    -- cyan_cooler
    fnname = "#ffffff",    -- cyan_warmer
    fnname_call = "#ffffff",        -- cyan_faint
    keyword = "#00ffff",              -- cyan
    preprocessor = "#a6a6a6",        -- blue_faint
    docstring = "#ffa07a",       -- yellow_cooler
    string = "#ffa07a",         -- yellow_cooler
    type = "#a6a6a6",        -- green_cooler
    variable = "#ffffff",       -- fg_main
    variable_use = "#dfb08f",            -- yellow_faint
    rx_backslash = "#44cc44",               -- green
    fg_link = "#00ffff"
}

return M
