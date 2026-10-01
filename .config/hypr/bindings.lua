-- Personal keybindings, modeled on the old dwm-style Hyprland setup.
-- Omarchy defaults that collide with the keys below are unbound first.

for _, k in ipairs({
  "SUPER + RETURN", "SUPER + SHIFT + RETURN",
  "SUPER + J", "SUPER + K", "SUPER + H", "SUPER + L", "SUPER + T", "SUPER + F",
  "SUPER + W", "SUPER + C", "SUPER + V", "SUPER + X", "SUPER + P", "SUPER + A",
  "SUPER + B", "SUPER + E", "SUPER + N", "SUPER + S", "SUPER + 0", "SUPER + TAB",
  "SUPER + SLASH", "SUPER + COMMA", "SUPER + PERIOD", "SUPER + SHIFT + COMMA",
  "SUPER + SHIFT + C", "SUPER + SHIFT + E", "SUPER + SHIFT + L", "SUPER + SHIFT + Q",
  "SUPER + SHIFT + T", "SUPER + SHIFT + S", "SUPER + SHIFT + J", "SUPER + SHIFT + K",
  "SUPER + SHIFT + code:61", "SUPER + SHIFT + SLASH", "SUPER + SHIFT + P", "SUPER + CTRL + SHIFT + R", "SUPER + SHIFT + CTRL + R", "SUPER + code:19", "SUPER + CTRL + B",
}) do
  hl.unbind(k)
end

-- Launch
o.bind("SUPER + SHIFT + RETURN", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + P", "Launcher", "omarchy-menu toggle apps")
o.bind("SUPER + SHIFT + T", "Theme menu", "omarchy-menu toggle theme")
o.bind("SUPER + A", "Claude scratchpad", function()
  for _, w in ipairs(hl.get_windows()) do
    if w.class == "claude-code" then
      hl.dispatch(hl.dsp.workspace.toggle_special("claude"))
      return
    end
  end
  -- Not running yet: launch it (the window rule shows it on special:claude).
  hl.exec_cmd("env -u CLAUDECODE foot --app-id claude-code -e bash -lc claude")
end)

-- Window management
o.bind("SUPER + SHIFT + C", "Close window", hl.dsp.window.close())
o.bind("SUPER + J", "Focus next window", hl.dsp.layout("cyclenext"))
o.bind("SUPER + K", "Focus previous window", hl.dsp.layout("cycleprev"))
o.bind("SUPER + SHIFT + J", "Swap with next window", hl.dsp.layout("swapnext"))
o.bind("SUPER + SHIFT + K", "Swap with previous window", hl.dsp.layout("swapprev"))
o.bind("SUPER + RETURN", "Swap with master", hl.dsp.layout("swapwithmaster master"))
o.bind("SUPER + H", "Shrink master", hl.dsp.layout("mfact -0.05"), { repeating = true })
o.bind("SUPER + L", "Grow master", hl.dsp.layout("mfact +0.05"), { repeating = true })

-- Layouts
o.bind("SUPER + T", "Tiled (master-stack)", hl.dsp.layout("orientationleft"))
o.bind("SUPER + SLASH", "Toggle landscape/portrait tiling", hl.dsp.layout("orientationcycle left top"))
o.bind("SUPER + F", "Monocle", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Bar / lock / session
o.bind("SUPER + B", "Toggle bar", "omarchy-toggle-bar")
o.bind("SUPER + SHIFT + L", "Lock screen", "omarchy-system-lock")
o.bind("SUPER + CTRL + SHIFT + R", "Reboot", "omarchy-system-reboot")
o.bind("SUPER + SHIFT + Q", "Log out", "omarchy-system-logout")
o.bind("SUPER + SHIFT + E", "Power menu", "omarchy-menu toggle system")

-- Workspaces (previous on 0 and Tab, like the old setup)
o.bind("SUPER + 0", "Previous workspace", hl.dsp.focus({ workspace = "previous" }))
o.bind("SUPER + TAB", "Previous workspace", hl.dsp.focus({ workspace = "previous" }))

-- Monitors
o.bind("SUPER + COMMA", "Focus previous monitor", hl.dsp.focus({ monitor = "-1" }))
o.bind("SUPER + PERIOD", "Focus next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + SHIFT + COMMA", "Move window to previous monitor", hl.dsp.window.move({ monitor = "-1" }))
o.bind("SUPER + SHIFT + PERIOD", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))

-- Utilities
o.bind("SUPER + W", "Background switcher", "omarchy-menu toggle background")
o.bind("SUPER + N", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
o.bind("SUPER + C", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + X", "System monitor", { tui = "btop" })
o.bind("SUPER + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
o.bind("SUPER + SHIFT + S", "Omarchy menu", "omarchy-menu toggle")
o.bind("SUPER + SHIFT + code:61", "Keybindings cheatsheet", "omarchy-menu-keybindings")

-- Per-workspace float mode toggle (SUPER + `)
require("hypr.floatmode")

-- Mac-style Cmd shortcuts (physical Cmd = ALT after the Super/Alt swap)
require("hypr.macmode")

-- Screenshot (was Google Photos on this key)
o.bind("SUPER + SHIFT + P", "Screenshot", "omarchy-capture-screenshot")

-- Recolor the desktop from the current wallpaper (Aether)
o.bind("SUPER + ALT + W", "Theme from wallpaper", "~/.local/bin/wallpaper-theme")
