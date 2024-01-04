-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.enable_wayland = true

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- config.freetype_load_target = "Light"
config.hide_mouse_cursor_when_typing = false

config.keys = {
  -- Override default pane behavior
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

config.font_size = 11.0

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = '0cell',
  right = '0cell',
  top = '0cell',
  bottom = '0cell',
}

config.audible_bell = "Disabled"

config.color_scheme = 'Tokyo Night'

config.warn_about_missing_glyphs = false

return config

