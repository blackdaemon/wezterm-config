local wezterm = require 'wezterm'
local act = wezterm.action
local base_padding = require('config.appearance').window_padding

-- Kept in wezterm.GLOBAL so it survives config reloads while in fullscreen.
local function windowed_width_key(window)
  return 'windowed_width_' .. tostring(window:window_id())
end

local function windowed_left_key(window)
  return 'windowed_left_' .. tostring(window:window_id())
end

-- Distance in pixels from the monitor's left edge to the most recently used
-- wezterm window, or false if unknown. Wayland hides window positions from
-- clients, so this asks GNOME Shell through the popterm-wayland-bridge extension.
local function query_windowed_left(window_dims)
  local ok, stdout = wezterm.run_child_process({
    'gdbus', 'call', '--session',
    '--dest', 'org.popterm.Toggle',
    '--object-path', '/org/popterm/Toggle',
    '--method', 'org.popterm.Toggle.Geometry',
    'org.wezfurlong.wezterm',
  })
  if not ok then
    return false
  end
  local x, width, work_x = stdout:match('^%(true, (%-?%d+), %-?%d+, (%d+), %d+, (%-?%d+),')
  if not x or tonumber(width) == 0 then
    return false
  end
  -- GNOME reports logical pixels; scale them to the window's physical pixels
  local scale = window_dims.pixel_width / tonumber(width)
  return math.floor((tonumber(x) - tonumber(work_x)) * scale)
end

function recompute_padding(window)
  local window_dims = window:get_dimensions()
  local overrides = window:get_config_overrides() or {}

  if not window_dims.is_full_screen then
    if overrides.window_padding == nil
       and overrides.enable_scroll_bar == nil
    then
      -- not changing anything
      return
    end
    overrides.window_padding = nil
    overrides.enable_scroll_bar = nil
  else
    -- Fill the width gained by going fullscreen with margins, so the terminal
    -- area keeps its windowed width and horizontal position. Height is left to grow.
    local windowed_width = wezterm.GLOBAL[windowed_width_key(window)] or window_dims.pixel_width
    local windowed_left = wezterm.GLOBAL[windowed_left_key(window)]
    local margin = math.max(0, window_dims.pixel_width - windowed_width)
    -- clamped because PaperWM can leave a window partly off screen
    local left_margin = windowed_left and math.min(margin, math.max(0, windowed_left))
      or math.floor(margin / 2)

    local new_padding = {
      left = base_padding.left + left_margin,
      right = base_padding.right + margin - left_margin,
      top = base_padding.top,
      bottom = base_padding.bottom,
    }

    if
      overrides.window_padding
      and new_padding.left == overrides.window_padding.left
      and new_padding.right == overrides.window_padding.right
      and overrides.enable_scroll_bar == false
    then
      -- padding is same, avoid triggering further changes
      return
    end

    overrides.window_padding = new_padding
    overrides.enable_scroll_bar = false
  end
  window:set_config_overrides(overrides)
end

wezterm.on('window-resized', function(window, pane)
  recompute_padding(window)
end)

wezterm.on('window-config-reloaded', function(window)
  recompute_padding(window)
end)

-- Measured on the key press, while the window is still settled in its windowed
-- size; resize events during the transition can report in-between states.
wezterm.on('window.toggle-fullscreen', function(window, pane)
  local window_dims = window:get_dimensions()
  if not window_dims.is_full_screen then
    wezterm.GLOBAL[windowed_width_key(window)] = window_dims.pixel_width
    wezterm.GLOBAL[windowed_left_key(window)] = query_windowed_left(window_dims)
  end
  window:perform_action(act.ToggleFullScreen, pane)
end)
