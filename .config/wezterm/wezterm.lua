local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

wezterm.on("format-window-title", function()
	return "Terminal"
end)

return {
	default_domain = "WSL:Archlinux",
	color_scheme = "Dracula (Official)",
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium", italic = false }),
	bold_brightens_ansi_colors = "BrightAndBold",
	font_size = 10.0,
	window_decorations = "TITLE",
	hide_tab_bar_if_only_one_tab = true,
	window_background_opacity = 1.0,
	text_background_opacity = 1.0,
	win32_system_backdrop = "Mica",
}

-- local config = {}
-- if wezterm.config_builder then
-- 	config = wezterm.config_builder()
-- end
