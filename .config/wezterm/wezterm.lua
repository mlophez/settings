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
	--color_scheme = "Dracula (Official)",
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium", italic = false }),
	bold_brightens_ansi_colors = "BrightAndBold",
	font_size = 11.0,
	window_decorations = "TITLE",
	hide_tab_bar_if_only_one_tab = true,
	window_background_opacity = 1.0,
	text_background_opacity = 1.0,
	win32_system_backdrop = "Mica",
	disable_default_key_bindings = true,
	-- default_domain = "WSL:Archlinux",
	-- default_prog = { "wsl", "--cd", "/home/mlr", "-e", "/bin/bash" },
	default_prog = {
		"wsl",
		"--cd",
		"/home/mlr",
		"-e",
		"/bin/bash",
		"-c",
		"tmux attach-session -t '0' || tmux -2 new-session -s '0' -n 'HOME'",
	},
	set_environment_variables = {
		ZDOTDIR = "$HOME/.config/zsh",
	},
	keys = {
		{ key = "C", mods = "CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
		{ key = "t", mods = "ALT", action = wezterm.action.SpawnTab({ DomainName = "WSL:Archlinux" }) },
	},
}

-- local config = {}
-- if wezterm.config_builder then
-- 	config = wezterm.config_builder()
-- end
