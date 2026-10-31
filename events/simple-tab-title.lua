local wezterm = require('wezterm')

local M = {}

local function basename(path)
   path = path:gsub('/+$', '')
   return path:match('([^/]+)$') or path
end

local function process_name(path)
   return basename((path or ''):gsub('\\', '/')):gsub('%.exe$', '')
end

function M.setup()
   wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, _hover, max_width)
      local width = math.min(29, max_width)
      local title = tab.tab_title

      if not title or #title == 0 then
         local pane = tab.active_pane
         local pane_title = pane.title or ''
         local process = process_name(pane.foreground_process_name)
         local shells = {
            bash = true,
            fish = true,
            zsh = true,
         }

         if process == '' or shells[process] then
            if pane.current_working_dir then
               title = basename(pane.current_working_dir.file_path)
            else
               title = pane_title ~= '' and pane_title or process
            end
         elseif pane_title ~= '' and pane_title ~= process then
            title = process .. ' ' .. pane_title
         else
            title = process
         end
      end

      local prefix = string.format(' %d ', tab.tab_index + 1)
      local prefix_width = wezterm.column_width(prefix)

      title = wezterm.truncate_right(title, math.max(1, width - prefix_width - 1))
      local padding = width - prefix_width - wezterm.column_width(title)
      local spacer = '\u{00a0}'

      return prefix .. title .. string.rep(spacer, math.max(1, padding))
   end)
end

return M
