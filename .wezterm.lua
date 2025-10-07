local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.keys = {
  -- Tabs
  { key = "T", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

  -- Panes
  { key = "W", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "%", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "\"", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "LeftArrow", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Down") },

  -- Misc
  { key = "R", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },
}

return config
