-- Mac-style Cmd shortcuts. With Super/Alt swapped, the physical Cmd key is ALT
-- to Hyprland, so Cmd + C / V / ... are bound here as ALT + C / V / ...
-- Terminals keep their own ALT chords (readline etc.), except copy/paste.

local function send_once(mods, key)
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end

local function active_is_terminal()
  local window = hl.get_active_window()
  if not window then return false end
  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then return true end
  end
  return false
end

-- keys: Hyprland bind chord; send: { mods, key }; term: { mods, key } to send in a
-- terminal instead (omit to pass the original chord through unchanged).
local function cmd(chord, key, mods, send_mods, send_key, term)
  o.bind(chord, nil, function()
    if active_is_terminal() then
      if term then send_once(term[1], term[2]) else send_once(mods, key) end
    else
      send_once(send_mods, send_key)
    end
  end)
end

cmd("ALT + C", "C", "ALT", "CTRL", "C", { "CTRL", "Insert" })   -- copy
cmd("ALT + V", "V", "ALT", "CTRL", "V", { "SHIFT", "Insert" })  -- paste
cmd("ALT + X", "X", "ALT", "CTRL", "X")                         -- cut
cmd("ALT + A", "A", "ALT", "CTRL", "A")                         -- select all
cmd("ALT + Z", "Z", "ALT", "CTRL", "Z")                         -- undo
cmd("ALT + SHIFT + Z", "Z", "ALT SHIFT", "CTRL SHIFT", "Z")     -- redo
cmd("ALT + S", "S", "ALT", "CTRL", "S")                         -- save
cmd("ALT + F", "F", "ALT", "CTRL", "F")                         -- find
cmd("ALT + T", "T", "ALT", "CTRL", "T")                         -- new tab
cmd("ALT + SHIFT + T", "T", "ALT SHIFT", "CTRL SHIFT", "T")     -- reopen tab
cmd("ALT + W", "W", "ALT", "CTRL", "W")                         -- close tab
cmd("ALT + R", "R", "ALT", "CTRL", "R")                         -- reload
cmd("ALT + L", "L", "ALT", "CTRL", "L")                         -- address bar
cmd("ALT + N", "N", "ALT", "CTRL", "N")                         -- new window
cmd("ALT + P", "P", "ALT", "CTRL", "P")                         -- print
cmd("ALT + Q", "Q", "ALT", "CTRL", "Q")                         -- quit app
cmd("ALT + LEFT", "Left", "ALT", "", "Home")                    -- line start
cmd("ALT + RIGHT", "Right", "ALT", "", "End")                   -- line end
