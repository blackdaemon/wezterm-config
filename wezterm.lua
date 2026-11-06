local wezterm = require('wezterm')
local Config = require('config')

require('utils.backdrops')
   -- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')
   :scan_images_dir()
   :random()

require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.simple-tab-title').setup()
require('events.new-tab-button').setup()
require('events.window-resized') 
require('events.top-zoom').setup()

c = Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options

local theme_rotator = require('utils.theme-rotator')
theme_rotator.apply_to_config(c, {
  -- Only rotate through schemes with a dark background.
  appearance = 'dark',
  --appearance = 'dark', 
  show_status = false,

  -- Customize "Next Theme" key
  next_theme_key = 'n',
  next_theme_mods = 'SUPER|SHIFT',

  -- Customize "Previous Theme" key
  prev_theme_key = 'p',
  prev_theme_mods = 'SUPER|SHIFT',

  -- Customize "Random Theme" key
  random_theme_key = 't',
  random_theme_mods = 'SUPER|SHIFT',

  -- Customize "Default Theme" key
  default_theme_key = 'd',
  default_theme_mods = 'SUPER|SHIFT'
})

local agent_quota = require('wezterm').plugin.require(
  'https://github.com/M-Marbouh/agent-quota.wezterm'
)
agent_quota.apply_to_config(c, { show_claude = true })

return c
