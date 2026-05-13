-- Hyprland config (Lua). Equivalent of hyprland.conf.
-- Docs: https://wiki.hypr.land/Configuring/Start/

-- ===== Helpers =====
local function which(bin)
  local f = io.popen("command -v " .. bin .. " 2>/dev/null")
  if not f then return false end
  local path = f:read("*l")
  f:close()
  return path ~= nil and path ~= ""
end

local function run_terminal()
  local candidates = {
    { bin = "wezterm",   args = "start --always-new-process" },
    { bin = "alacritty", args = "" },
    { bin = "foot",      args = "" },
    { bin = "ptyxis",    args = "--new-window" },
  }
  for _, t in ipairs(candidates) do
    if which(t.bin) then
      hl.dispatch(hl.dsp.exec_cmd("uwsm-app -- " .. t.bin .. " " .. t.args))
      return
    end
  end
end

local function run_panel()
  local cmd =
  "uwsm-app -- waybar -c $HOME/.config/waybar/${XDG_CURRENT_DESKTOP,,}.json -s $HOME/.config/waybar/${XDG_CURRENT_DESKTOP,,}.css"
  hl.dispatch(hl.dsp.exec_cmd(cmd))
  --hl.exec_cmd(
  --  "uwsm-app -- waybar -c $HOME/.config/waybar/${XDG_CURRENT_DESKTOP,,}.json -s $HOME/.config/waybar/${XDG_CURRENT_DESKTOP,,}.css")
end

local function reload()
  run_panel()
end

-- ===== Env =====
--hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. (os.getenv("PATH") or ""))
hl.env("PATH", "$PATH:$HOME/.local/bin")
-- hl.env("MOZ_ENABLE_WAYLAND", "1")
-- hl.env("GDK_BACKEND", "wayland")
-- hl.env("QT_QPA_PLATFORM", "wayland-egl;wayland;xcb")
-- hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hl.env("CLUTTER_BACKEND", "wayland")
-- hl.env("SDL_VIDEODRIVER", "wayland")
-- hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- hl.env("SAL_USE_VCLPLUGIN", "kf5")
-- hl.env("ZDOTDIR=", "$HOME/.config/zsh")
-- hl.env("BROWSER", "org.mozilla.firefox")

-- ===== Monitors =====
--hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "0x0", scale = 1 })
--
--for _, output in ipairs({ "DP-2", "DP-3", "DP-4", "DP-5", "DP-6", "DP-7", "DP-8", "DP-9", "HDMI-A-1" }) do
--  hl.monitor({ output = output, mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })
--end
--
--hl.monitor({ output = "", disabled = true })

-- ===== Autostart =====
hl.on("hyprland.start", function()
  run_panel()
end)

-- ===== General / look'n'feel =====
hl.config({
  general = {
    gaps_in = 10,
    gaps_out = 20,
    border_size = 3,
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
    layout = "dwindle",
    allow_tearing = false,
  },

  debug = {
    disable_logs = false,
    enable_stdout_logs = true,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  input = {
    kb_layout = "es",
    kb_options = "ctrl:nocaps",
    kb_model = "thinkpad",
    follow_mouse = 0,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },

  cursor = {
    no_hardware_cursors = true,
  },

  decoration = {
    rounding = 15,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    shadow = {
      range = 30,
      render_power = 3,
      color = "0x66000000",
    },
    blur = {
      enabled = true,
      size = 2,
      passes = 2,
      xray = true,
      ignore_opacity = true,
      special = true,
      popups = false,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    force_default_wallpaper = 0,
    focus_on_activate = true,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    initial_workspace_tracking = 1,
  },
})

-- ===== Animations =====
--hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "default" })
--hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
--hl.animation({ leaf = "layers", enabled = true, speed = 7, bezier = "default" })
--hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
--hl.animation({ leaf = "border", enabled = true, speed = 7, bezier = "default" })
--hl.animation({ leaf = "borderangle", enabled = true, speed = 7, bezier = "default" })
--hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "default" })
--hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 7, bezier = "default", style = "slidefadevert" })

-- ===== Bindings =====
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Kill active window" })
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind("SUPER + T", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"), { description = "Toggle group" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Fullscreen" })
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprctl dispatch pin"), { description = "Pin window" })
hl.bind("SUPER + N", hl.dsp.exec_cmd("deskcmd menu"), { description = "Menu" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("deskcmd terminal toggle"), { description = "Terminal toggle" })
hl.bind("SUPER + H", hl.dsp.exec_cmd("deskcmd files"), { description = "Files" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("deskcmd files"), { description = "Files" })
hl.bind("SUPER + W", hl.dsp.exec_cmd("deskcmd wallpaper"), { description = "Wallpaper" })
hl.bind("SUPER + RETURN", run_terminal, { description = "Terminal" })
hl.bind("SUPER + Z", hl.dsp.exec_cmd("deskcmd lock"), { description = "Lock" })
hl.bind("SUPER + I", hl.dsp.exec_cmd("makoctl dismiss"), { description = "Dismiss notification" })

hl.bind("SUPER + SHIFT + RETURN", run_terminal, { description = "Terminal" })
hl.bind("F1", hl.dsp.exec_cmd([[sh -c 'echo "exec ok at $(date)"' > /tmp/hyprtest.log]]),
  { description = "Hypr test ping" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("deskcmd menu exit"), { description = "Exit menu" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -f hex -n -a"), { description = "Color picker" })
--hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland" })
hl.bind("SUPER + SHIFT + R", run_panel, { description = "Reload Hyprland" })
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("hyprctl kill"), { description = "Kill picker" })

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("deskcmd volume inc"), { description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("deskcmd volume dec"), { description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { description = "Mute sink" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { description = "Mute mic" })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { description = "Brightness down" })

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("deskcmd screenshot"), { description = "Screenshot" })

-- Move focus (arrows)
hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Move focus (vim-ish, Spanish layout)
hl.bind("SUPER + J", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + ntilde", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Move window
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind("SUPER + SHIFT + ntilde", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

-- Workspaces 1..10
for key, workspace in pairs({ ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["0"] = 10 }) do
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(workspace) }),
    { description = "Workspace " .. workspace })
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace) }),
    { description = "Move window to workspace " .. workspace })
end

-- Move / resize with mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Minimize via special workspace (replicates the 5-step conf sequence)
hl.bind("SUPER + S", function()
  hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
  hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
  hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end, { description = "Minimize/restore via special workspace" })
