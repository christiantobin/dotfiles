-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- dwm-style master/stack layout (from old setup).
hl.config({
  general = { layout = "master" },
  master = { new_status = "slave", mfact = 0.55 },
})

-- Claude scratchpad window (SUPER + A).
o.window("^(claude-code)$", { float = true, size = "60% 70%", center = true, workspace = "special:claude" })

-- More transparent terminals (all themes). Blur keeps text readable over the wallpaper.
hl.config({ decoration = { blur = { enabled = true, size = 3, passes = 2 } } })
o.window({ tag = "terminal" }, { opacity = "0.80 0.72" })

-- Old-dotfiles look (rounded corners, blur, soft shadow, tight gaps, slide
-- workspaces), applied only while the Aether theme is active. Switching theme
-- reloads Hyprland, so this re-evaluates automatically.
local function current_theme()
  local f = io.open((os.getenv("HOME") or "") .. "/.local/state/omarchy/current/theme.name", "r")
  if not f then return "" end
  local name = (f:read("*l") or ""):lower()
  f:close()
  return name
end

if current_theme() == "aether" then
  hl.config({
    general = { gaps_in = 2, gaps_out = 4, border_size = 3 },
    decoration = {
      rounding = 5,
      rounding_power = 2,
      dim_special = 0.3,
      blur = { enabled = true, size = 2, passes = 1, special = true },
      shadow = { enabled = true, range = 10, render_power = 2, color = "rgba(00000033)" },
    },
    misc = { disable_hyprland_logo = true },
  })

  hl.curve("easeOut", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
  hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "default" })
  hl.animation({ leaf = "windows", enabled = true, speed = 4.5, bezier = "easeOutQuint" })
  hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.8, bezier = "easeOutQuint", style = "popin 87%" })
  hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.2, bezier = "linear", style = "popin 87%" })
  hl.animation({ leaf = "border", enabled = true, speed = 3.0, bezier = "easeOutQuint" })
  hl.animation({ leaf = "fade", enabled = true, speed = 2.8, bezier = "quick" })
  hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeOut", style = "slide" })
end
