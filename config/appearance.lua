local gpu_adapters = require('utils.gpu-adapter')
local backdrops = require('utils.backdrops')

---@type Config
return {
   -- predictable geometry for newly created scratch-layer windows
   initial_cols = 174,
   initial_rows = 56,

   max_fps = 60,
   front_end = 'WebGpu', ---@type 'WebGpu' | 'OpenGL' | 'Software'
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
   -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
   underline_thickness = '1.5pt',

   -- cursor
   animation_fps = 60,
   cursor_blink_ease_in = 'EaseOut',
   cursor_blink_ease_out = 'EaseOut',
   default_cursor_style = 'BlinkingBlock',
   cursor_blink_rate = 650,

   line_height =  1.15,

   -- color scheme
--   colors = colors,
   color_scheme = 'Selenized Black (Gogh)', 
   color_scheme = 'Seti UI (base16)', 
   color_scheme = 'Cupertino (base16)', 
   color_scheme = 'darkmoss (base16)', 
   color_scheme = 'Classic Dark (base16)', 
   color_scheme = 'Orangish (terminal.sexy)', 
   color_scheme = 'Parker Brothers (terminal.sexy)', 
   color_scheme = 'MaterialOcean', 
   color_scheme = 'GruvboxDarkHard',
   color_scheme = 'Atom',
   color_scheme = 'Ayu Dark (Gogh)', 

   -- background: pass in `true` if you want wezterm to start with focus mode on (no bg images)
--   background = backdrops:initial_options({ no_img = false }),

   -- scrollbar
   enable_scroll_bar = true,

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = false,
   tab_bar_at_bottom = true,
   tab_max_width = 40,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,
   colors = {
      tab_bar = {
         background = '#111418',
         active_tab = {
            bg_color = '#30363d',
            fg_color = '#e6edf3',
            intensity = 'Normal',
         },
         inactive_tab = {
            bg_color = '#1c2128',
            fg_color = '#8b949e',
         },
         inactive_tab_hover = {
            bg_color = '#252b32',
            fg_color = '#c9d1d9',
         },
         new_tab = {
            bg_color = '#111418',
            fg_color = '#8b949e',
         },
         new_tab_hover = {
            bg_color = '#252b32',
            fg_color = '#c9d1d9',
         },
      },
   },

   -- command palette
   command_palette_fg_color = '#b4befe',
   command_palette_bg_color = '#11111b',
   command_palette_font_size = 12,
   command_palette_rows = 25,

   -- window
   window_padding = {
      left = 20,
      right = 20,
      top = 20,
      bottom = 4.0,
   },
   adjust_window_size_when_changing_font_size = false,
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
      -- font = fonts.font,
      -- font_size = fonts.font_size,
   },
   -- inactive_pane_hsb = {
   --    saturation = 0.9,
   --    brightness = 0.65,
   -- },
   -- Keep focus visible regardless of which side owns the split/scrollbar gutter.
   inactive_pane_hsb = {
      saturation = 0.8,
      brightness = 0.7,
   },

   visual_bell = {
      fade_in_function = 'EaseIn',
      fade_in_duration_ms = 250,
      fade_out_function = 'EaseOut',
      fade_out_duration_ms = 250,
      target = 'CursorColor',
   },
}
