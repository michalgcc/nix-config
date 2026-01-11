local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Windows-specific configuration
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'nu' }
  -- Resolve flickering issue on Windows
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"
  config.webgpu_preferred_adapter = {
      backend = "Vulkan",
      device_type = "IntegratedGpu",
      name = "Intel(R) Iris(R) Xe Graphics"
  }
else
  config.default_prog = { 'nu' }
  -- Wayland settings for Linux
  config.enable_wayland = true
end


config.window_padding = {
  left = '0cell',
  right = '0cell',
  top = '0cell',
  bottom = '0cell',
}

config.audible_bell = "Disabled"
config.warn_about_missing_glyphs = false

config.font_size = 10.0

return config
