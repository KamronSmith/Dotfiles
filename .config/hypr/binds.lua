local binds = {}

local terminal = "ghostty"
local fileManager = "emacsclient -c -a \"\""
local menu = "rofi -show drun"
local editor = "emacsclient -c -a \"\""
local browser = "firefox"
local clipboard = "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
local bin_dir = "/home/kam/.local/bin/"

local mainMod = "SUPER + "

hl.bind(mainMod .. "b", hl.dsp.focus({ direction = "left"}))
hl.bind(mainMod .. "c", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. "d", function ()
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

hl.bind(mainMod .. "e", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. "f", hl.dsp.focus({ direction = "right"}))
hl.bind(mainMod .. "g", hl.dsp.window.fullscreen())
hl.bind(mainMod .. "j", hl.dsp.window.float({ action = toggle }))

hl.bind(mainMod .. "l", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. "m", hl.dsp.window.move({ workspace = 3 }))

hl.bind(mainMod .. "q", hl.dsp.window.close(hl.get_active_window()))
hl.bind(mainMod .. "r", function ()
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

hl.bind(mainMod .. "s", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. "t", hl.dsp.focus({ workspace = 3 }))
-- hl.bind(mainMod .. "v", hl.dsp.window.float({ action = "toggle"}))
hl.bind(mainMod .. "v", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. "x", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. "y", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. "z", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "Tab", hl.dsp.exec_cmd("rofi -show window"))

hl.bind(mainMod .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. "mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

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
