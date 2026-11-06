local wezterm = require('wezterm')
local act = wezterm.action

-- Collapses the bottom pane to one row so the top row of panes fills the tab.
-- Like TogglePaneZoomState, focusing the collapsed pane undoes it.

local M = {}

-- Kept in wezterm.GLOBAL so it survives config reloads.
local function state_key(tab)
   return 'top_zoom_' .. tostring(tab:tab_id())
end

---@return table|nil top, table|nil bottom, table|nil active
local function rows(tab)
   local top, bottom, active
   for _, p in ipairs(tab:panes_with_info()) do
      if p.top == 0 and not top then
         top = p
      end
      if not bottom or p.top > bottom.top then
         bottom = p
      end
      if p.is_active then
         active = p
      end
   end
   return top, bottom, active
end

function M.toggle(window, pane)
   local tab = pane:tab()
   local key = state_key(tab)
   local top, bottom = rows(tab)
   if not top or not bottom or top.top == bottom.top then
      -- no bottom row (left, or never there): forget a stale collapse
      wezterm.GLOBAL[key] = nil
      return
   end

   local saved = wezterm.GLOBAL[key]

   -- AdjustPaneSize acts on the active pane, so move the divider from a top pane
   top.pane:activate()
   if saved then
      window:perform_action(act.AdjustPaneSize({ 'Up', saved }), top.pane)
      wezterm.GLOBAL[key] = nil
   else
      local delta = bottom.height - 1
      window:perform_action(act.AdjustPaneSize({ 'Down', delta }), top.pane)
      wezterm.GLOBAL[key] = delta
      -- the bottom pane is now hidden, so leave focus on the top pane
      if pane:pane_id() == bottom.pane:pane_id() then
         return
      end
   end
   pane:activate()
end

-- Restores the bottom pane if focus has moved onto it while collapsed.
local function restore_if_focused(window, pane)
   local tab = pane:tab()
   if not tab or not wezterm.GLOBAL[state_key(tab)] then
      return
   end
   local _, _, active = rows(tab)
   if active and active.top > 0 then
      M.toggle(window, active.pane)
   end
end

-- ActivatePaneDirection that restores the collapsed pane right away when it moves onto it.
function M.activate_direction(direction)
   return wezterm.action_callback(function(window, pane)
      window:perform_action(act.ActivatePaneDirection(direction), pane)
      restore_if_focused(window, pane)
   end)
end

-- Catches focus changes the keys above do not see: mouse clicks, PaneSelect.
function M.setup()
   wezterm.on('update-status', function(window, pane)
      restore_if_focused(window, pane)
   end)
end

return M
