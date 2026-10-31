local wezterm = require('wezterm')
local platform = require('utils.platform')

-- local font_family = 'Maple Mono NF'
--local font_family = 'JetBrainsMono Nerd Font'
-- local font_family = 'CartographCF Nerd Font'
local font_family = 'VictorMono Nerd Font'
local font_family = 'Sudo Nerd Font Light'
local font_family = 'ZedMono Nerd Font'

local font_size = platform.is_mac and 12 or 11.5

---@type Config
return {
   font = wezterm.font({ family = font_family, weight = 'Thin', stretch='Condensed' }),
   font_size = font_size,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'

   harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' },

   warn_about_missing_glyphs = false,
}
