local wezterm = require("wezterm")
local mux = wezterm.mux

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings --
config.color_scheme = "Dracula"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 10.0

config.window_decorations = "TITLE"
config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 0.5
config.text_background_opacity = 1.0
config.win32_system_backdrop = "Mica"

--config.default_prog = { "wsl.exe", "--cd" }
config.default_domain = "WSL:Archlinux"

-- Events --
wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

wezterm.on("format-window-title", function()
	return "Terminal"
end)

return config
