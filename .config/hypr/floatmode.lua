-- dwm-style per-workspace float mode (ported from the old float-mode scripts).
-- Toggle with SUPER + `: tiled <-> floating for every window on the workspace.
-- While a workspace is in float mode, new windows open floating, 50% size, centered.

local float_ws = {}   -- [workspace id] = true while in float mode
local saved = {}      -- [workspace id] = { [address] = { x, y, w, h } }

local function sel(w) return "address:" .. w.address end
local function xy(t) return t[1] or t.x, t[2] or t.y end

local function ws_windows(id)
  local list = {}
  for _, w in ipairs(hl.get_workspace_windows(id)) do
    if not w.hidden then list[#list + 1] = w end
  end
  return list
end

local function toggle()
  local ws = hl.get_active_workspace()
  if not ws then return end
  local id = ws.id
  local wins = ws_windows(id)

  local floating = 0
  for _, w in ipairs(wins) do if w.floating then floating = floating + 1 end end

  local to_tiled
  if #wins == 0 then to_tiled = float_ws[id] else to_tiled = floating > #wins / 2 end

  if to_tiled then
    float_ws[id] = nil
    saved[id] = {}
    for _, w in ipairs(wins) do
      if w.floating then
        local x, y = xy(w.at)
        local sw, sh = xy(w.size)
        saved[id][w.address] = { x, y, sw, sh }
      end
      hl.dispatch(hl.dsp.window.float({ action = "disable", window = sel(w) }))
    end
    local mon = ws.monitor
    local mw, mh = xy(mon.size or { mon.width, mon.height })
    hl.dispatch(hl.dsp.layout((mh and mw and mh > mw) and "orientationtop" or "orientationleft"))
  else
    float_ws[id] = true
    for _, w in ipairs(wins) do
      hl.dispatch(hl.dsp.window.float({ action = "enable", window = sel(w) }))
      local s = saved[id] and saved[id][w.address]
      if s then
        hl.dispatch(hl.dsp.window.resize({ x = s[3], y = s[4], window = sel(w) }))
        hl.dispatch(hl.dsp.window.move({ x = s[1], y = s[2], window = sel(w) }))
      end
    end
  end
end

hl.on("window.open", function(w)
  local id = w.workspace and w.workspace.id
  if not (id and float_ws[id]) then return end
  if w.class == "ueberzugpp" or w.class == "ueberzug" or w.class == "claude-code" then return end
  local mon = w.workspace.monitor
  local scale = mon.scale or 1
  local mw, mh = mon.width / scale, mon.height / scale
  hl.dispatch(hl.dsp.window.float({ action = "enable", window = sel(w) }))
  hl.dispatch(hl.dsp.window.resize({ x = math.floor(mw / 2), y = math.floor(mh / 2), window = sel(w) }))
  hl.dispatch(hl.dsp.window.center({ window = sel(w) }))
end)

_G.float_mode_toggle = toggle
o.bind("SUPER + grave", "Toggle workspace float mode", toggle)
