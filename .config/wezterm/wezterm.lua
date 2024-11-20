local wezterm = require("wezterm")

local if_not_multiplexor = function(key, action)
  return wezterm.action_callback(function(win, pane)
    local pname = pane:get_foreground_process_name()
    if pname and (string.match(pname, "zellij") or string.match(pname, "tmux")) then
      win:perform_action(wezterm.action.SendKey(key), pane)
    else
      win:perform_action(action, pane)
    end
  end)
end

return {
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", italic = false }),
  font_size = 11.0,
  initial_rows = 30,
  initial_cols = 140,
  enable_wayland = true,
  window_decorations = "NONE",
  window_close_confirmation = 'NeverPrompt',
  window_background_opacity = 0.9,
  --window_background_image = os.getenv("HOME") .. '/.local/share/backgrounds/Img-10.png',
  win32_system_backdrop = "Mica",
  text_background_opacity = 1.0,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  default_prog = { "/usr/bin/zsh" },
  set_environment_variables = {
    ZDOTDIR = os.getenv("HOME") .. "/.config/zsh",
  },
  disable_default_key_bindings = true,
  debug_key_events = false,
  keys = { -- showkeys: wezterm show-keys --lua | less
    { mods = "CTRL", key = "C",      action = wezterm.action.CopyTo("Clipboard") },
    { mods = "CTRL", key = "V",      action = wezterm.action.PasteFrom("Clipboard") },
    { mods = "CTRL", key = "+",      action = wezterm.action.IncreaseFontSize },
    { mods = "CTRL", key = "-",      action = wezterm.action.DecreaseFontSize },
    { mods = "CTRL", key = "0",      action = wezterm.action.ResetFontSize },
    { mods = "CTRL", key = "X",      action = wezterm.action.ActivateCopyMode },
    --{ mods = "ALT",  key = "t",     action = wezterm.action.SpawnTab({ DomainName = "WSL:Archlinux" }) },
    -- Adapter for zellij prefix
    { mods = "ALT",  key = "Space",  action = wezterm.action.SendKey({ key = "F10" }) },
    -- KEYS
    { mods = "ALT",  key = "j",      action = wezterm.action.SendKey({ key = "LeftArrow" }) },
    { mods = "ALT",  key = "k",      action = wezterm.action.SendKey({ key = "DownArrow" }) },
    { mods = "ALT",  key = "l",      action = wezterm.action.SendKey({ key = "UpArrow" }) },
    { mods = "ALT",  key = "raw:47", action = wezterm.action.SendKey({ key = "RightArrow" }) },
    -- TABS
    { mods = "ALT",  key = 'n',      action = if_not_multiplexor({ mods = "ALT", key = 'n' }, wezterm.action.SpawnTab('CurrentPaneDomain')) },
    { mods = "ALT",  key = '1',      action = if_not_multiplexor({ mods = "ALT", key = '1' }, wezterm.action.ActivateTab(0)) },
    { mods = "ALT",  key = '2',      action = if_not_multiplexor({ mods = "ALT", key = '2' }, wezterm.action.ActivateTab(1)) },
    { mods = "ALT",  key = '3',      action = if_not_multiplexor({ mods = "ALT", key = '3' }, wezterm.action.ActivateTab(2)) },
    { mods = "ALT",  key = '4',      action = if_not_multiplexor({ mods = "ALT", key = '4' }, wezterm.action.ActivateTab(3)) },
    { mods = "ALT",  key = '5',      action = if_not_multiplexor({ mods = "ALT", key = '5' }, wezterm.action.ActivateTab(4)) },
    { mods = "ALT",  key = '6',      action = if_not_multiplexor({ mods = "ALT", key = '6' }, wezterm.action.ActivateTab(5)) },
    { mods = "ALT",  key = '7',      action = if_not_multiplexor({ mods = "ALT", key = '7' }, wezterm.action.ActivateTab(6)) },
    { mods = "ALT",  key = '8',      action = if_not_multiplexor({ mods = "ALT", key = '8' }, wezterm.action.ActivateTab(7)) },
    { mods = "ALT",  key = '9',      action = if_not_multiplexor({ mods = "ALT", key = '9' }, wezterm.action.ActivateTab(8)) },
    { mods = "ALT",  key = '0',      action = if_not_multiplexor({ mods = "ALT", key = '0' }, wezterm.action.ActivateTab(9)) },
  },
}
