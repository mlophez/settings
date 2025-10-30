local wezterm = require("wezterm")

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Config
return {
  color_scheme = "Catppuccin Mocha",
  font_size = 14.0,
  enable_wayland = true,
  window_close_confirmation = 'NeverPrompt',
  window_background_opacity = 0.95,
  win32_system_backdrop = "Mica",
  text_background_opacity = 1.0,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  default_prog = { "zsh" },
  disable_default_key_bindings = true,
  debug_key_events = true,
  send_composed_key_when_right_alt_is_pressed = true,
  --macos_left_command_as_control = true,
  keys = { -- showkeys: wezterm show-keys --lua | less
    { mods = "CTRL", key = "C",      action = wezterm.action.CopyTo("Clipboard") },
    { mods = "CTRL", key = "V",      action = wezterm.action.PasteFrom("Clipboard") },
    { mods = "CTRL", key = "+",      action = wezterm.action.IncreaseFontSize },
    { mods = "CTRL", key = "-",      action = wezterm.action.DecreaseFontSize },
    { mods = "CTRL", key = "0",      action = wezterm.action.ResetFontSize },
    { mods = "CTRL", key = "X",      action = wezterm.action.ActivateCopyMode },
    -- Adapter for zellij prefix
    { mods = "ALT",  key = "Space",  action = wezterm.action.SendKey({ key = "F10" }) },
    -- KEYS
    { mods = "ALT",  key = "j",      action = wezterm.action.SendKey({ key = "LeftArrow" }) },
    { mods = "ALT",  key = "k",      action = wezterm.action.SendKey({ key = "DownArrow" }) },
    { mods = "ALT",  key = "l",      action = wezterm.action.SendKey({ key = "UpArrow" }) },
    { mods = "ALT",  key = "raw:47", action = wezterm.action.SendKey({ key = "RightArrow" }) },
    { mods = "ALT",  key = "raw:41", action = wezterm.action.SendKey({ key = "RightArrow" }) }, -- MacOS
  },
}

-- Helper function to detect if the foreground process is a multiplexor (zellij or tmux)
-- local if_not_multiplexor = function(key, action)
--   return wezterm.action_callback(function(win, pane)
--     local pname = pane:get_foreground_process_name()
--     if pname and (string.match(pname, "zellij") or string.match(pname, "tmux")) then
--       win:perform_action(wezterm.action.SendKey(key), pane)
--     else
--       win:perform_action(action, pane)
--     end
--   end)
-- end

-- TABS (Intercept when not use zellij)
-- { mods = "ALT",  key = 'n',      action = if_not_multiplexor({ mods = "ALT", key = 'n' }, wezterm.action.SpawnTab('CurrentPaneDomain')) },
-- { mods = "ALT",  key = '1',      action = if_not_multiplexor({ mods = "ALT", key = '1' }, wezterm.action.ActivateTab(0)) },
-- { mods = "ALT",  key = '2',      action = if_not_multiplexor({ mods = "ALT", key = '2' }, wezterm.action.ActivateTab(1)) },
-- { mods = "ALT",  key = '3',      action = if_not_multiplexor({ mods = "ALT", key = '3' }, wezterm.action.ActivateTab(2)) },
-- { mods = "ALT",  key = '4',      action = if_not_multiplexor({ mods = "ALT", key = '4' }, wezterm.action.ActivateTab(3)) },
-- { mods = "ALT",  key = '5',      action = if_not_multiplexor({ mods = "ALT", key = '5' }, wezterm.action.ActivateTab(4)) },
-- { mods = "ALT",  key = '6',      action = if_not_multiplexor({ mods = "ALT", key = '6' }, wezterm.action.ActivateTab(5)) },
-- { mods = "ALT",  key = '7',      action = if_not_multiplexor({ mods = "ALT", key = '7' }, wezterm.action.ActivateTab(6)) },
-- { mods = "ALT",  key = '8',      action = if_not_multiplexor({ mods = "ALT", key = '8' }, wezterm.action.ActivateTab(7)) },
-- { mods = "ALT",  key = '9',      action = if_not_multiplexor({ mods = "ALT", key = '9' }, wezterm.action.ActivateTab(8)) },
-- { mods = "ALT",  key = '0',      action = if_not_multiplexor({ mods = "ALT", key = '0' }, wezterm.action.ActivateTab(9)) },
