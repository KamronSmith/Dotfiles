local binds = {}

local terminal = "ghostty"
local fileManager = "emacsclient -c -a \"\""
local menu = "rofi -show combi -modes combi -combi-modes \"window,drun\" -config ~/.dotfiles/.config/rofi/config.rasi -theme ~/.dotfiles/.config/rofi/theme.rasi"
local window_switcher = "rofi -show window -config ~/.dotfiles/.config/rofi/config.rasi -theme ~/.dotfiles/.config/rofi/theme.rasi"
local editor = "emacsclient -c -a \"\""
local browser = "firefox"
local clipboard = "cliphist list | rofi -dmenu -display-columns 2 -config ~/.dotfiles/.config/rofi/dmenu.rasi -theme ~/.dotfiles/.config/rofi/theme.rasi -p \"Paste: \" | cliphist decode | wl-copy"


local main_mod = "SUPER + "

hl.bind(main_mod .. "b", hl.dsp.focus({ direction = "left"}))
hl.bind(main_mod .. "c", hl.dsp.window.move({ workspace = 1 }))
hl.bind(main_mod .. "d", function ()
                            local exists = false
                            for _, w in ipairs(hl.get_windows()) do
                                if w.class == browser then
                                    exists = true
                                end
                            end
                            if exists then
                                hl.dispatch(hl.dsp.focus({ workspace = 1 }))
                            else
                                hl.dispatch(hl.dsp.exec_cmd(browser))
                                hl.dispatch(hl.dsp.focus({ workspace = 1 }))
                            end
                        end)

hl.bind(main_mod .. "e", hl.dsp.exec_cmd(fileManager))
hl.bind(main_mod .. "f", hl.dsp.focus({ direction = "right"}))
hl.bind(main_mod .. "g", hl.dsp.window.fullscreen())
hl.bind(main_mod .. "i", hl.dsp.layout("swapwithmaster master"))
hl.bind(main_mod .. "j", hl.dsp.window.float({ action = toggle }))

hl.bind(main_mod .. "l", hl.dsp.window.move({ workspace = 2 }))
hl.bind(main_mod .. "m", hl.dsp.window.move({ workspace = 3 }))

hl.bind(main_mod .. "q", hl.dsp.window.close(hl.get_active_window()))
hl.bind(main_mod .. "r", function ()
                            local exists = false
                            for _, w in ipairs(hl.get_windows()) do
                                if w.class == "emacs" then
                                    exists = true
                                end
                            end
                            if exists then
                                hl.dispatch(hl.dsp.focus({ workspace = 2 }))
                            else
                                hl.dispatch(hl.dsp.exec_cmd(editor))
                                hl.dispatch(hl.dsp.focus({ workspace = 2 }))
                            end
                        end)

hl.bind(main_mod .. "s", hl.dsp.focus({ workspace = 4 }))
hl.bind(main_mod .. "t", hl.dsp.focus({ workspace = 3 }))
-- hl.bind(mainMod .. "v", hl.dsp.window.float({ action = "toggle"}))
hl.bind(main_mod .. "v", hl.dsp.window.move({ workspace = 4 }))
hl.bind(main_mod .. "x", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. "y", hl.dsp.exec_cmd(clipboard))
hl.bind(main_mod .. "z", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. "Tab", hl.dsp.exec_cmd(window_switcher))

hl.bind(main_mod .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(main_mod .. "mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(main_mod .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%-"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

return binds
