local colors = require("kanagawa.colors")

local fg = require("utils.ui_utils").fg
local fg_bg = require("utils.ui_utils").fg_bg
local bg = require("utils.ui_utils").bg

-- Telescope
fg_bg("TelescopeBorder", colors.bg_dark, colors.bg_dark)
fg_bg("TelescopePromptBorder", colors.bg_dark, colors.bg_dark)

fg_bg("TelescopePromptNormal", colors.bg_light0, colors.bg_dark)
fg_bg("TelescopePromptPrefix", colors.oniViolet, colors.bg_dark)

bg("TelescopeNormal", colors.bg_dark)

fg_bg("TelescopePreviewTitle", colors.bg_dark, colors.oniViolet)
fg_bg("TelescopePromptTitle", colors.bg_dark, colors.oniViolet)
fg_bg("TelescopeResultsTitle", colors.bg_dark, colors.oniViolet)

bg("TelescopeSelection", colors.bg_dark)

 -- telescope
 bg("TelescopeBorder", "NONE")
 bg("TelescopePrompt", "NONE")
 bg("TelescopeResults", "NONE")
 bg("TelescopePromptBorder", "NONE")
 bg("TelescopePromptNormal", "NONE")
 bg("TelescopeNormal", "NONE")
 bg("TelescopePromptPrefix", "NONE")
 fg("TelescopeBorder", colors.bg_dark)
 fg_bg("TelescopeResultsTitle", colors.bg_dark, colors.oniViolet)
