local cmd = vim.cmd

local colors = require("kanagawa.colors")

local ui = {
  italic_comments = true,
  -- theme to be used, check available themes with `<leader> + t + h`
  -- Enable this only if your terminal has the colorscheme set which nvchad uses
  -- For Ex : if you have onedark set in nvchad, set onedark's bg color on your terminal
  transparency = false,
}

-- Define bg color
-- @param group Group
-- @param color Color
local function bg(group, color)
  cmd("hi " .. group .. " guibg=" .. color)
end

-- Define fg color
-- @param group Group
-- @param color Color
local function fg(group, color)
  cmd("hi " .. group .. " guifg=" .. color)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
local function fg_bg(group, fgcol, bgcol)
  cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

-- -- For floating windows
-- fg("FloatBorder", colors.waveBlue1)
-- bg("NormalFloat", colors.waveBlue2)

-- -- Pmenu
bg("Pmenu", colors.bg)
bg("PmenuSbar", colors.bg_light0)
bg("PmenuSel", colors.bg_menu)
bg("PmenuThumb", colors.bg_menu)

fg_bg("TelescopeBorder", colors.bg, colors.bg)
fg_bg("TelescopePromptBorder", colors.bg, colors.bg)
fg_bg("TelescopePreviewBorder", colors.bg, colors.bg)
fg_bg("TelescopeResultsBorder", colors.bg, colors.bg)

fg_bg("TelescopePromptNormal", colors.bg_menu, colors.fg_border) -- where teh letters are put
fg_bg("TelescopePromptPrefix", colors.bg_menu, colors.fg_border)

bg("TelescopeNormal", colors.winterBlue)
bg("TelescopePreviewNormal", colors.winterBlue) -- colors.bg

fg_bg("TelescopePreviewTitle", colors.sm, colors.bg_visual)
fg_bg("TelescopePromptTitle", colors.sm, colors.bg_visual)
fg_bg("TelescopeResultsTitle", colors.sm, colors.bg_visual)

fg("TelescopeSelection", colors.fg) --colors.fg
bg("TelescopeSelection", "#353b45")
bg("TelescopePreviewLine", "#353b45")

-- Disable some highlight in nvim tree if transparency enabled
if ui.transparency then
  bg("NvimTreeNormal", "NONE")
  bg("NvimTreeStatusLineNC", "NONE")
  bg("NvimTreeVertSplit", "NONE")
  fg("NvimTreeVertSplit", colors.fujiGray)
  bg("TelescopeNormal", "NONE")
  bg("TelescopePreviewNormal", "NONE")
end

bg("Search", colors.bg_search)
bg("IncSearch", colors.bg_menu_sel)

-- Telescope
fg("TelescopeBorder", colors.fg) -- --colors.fg
-- fg("TelescopePreviewBorder", colors.bg)
-- fg("TelescopePromptBorder", colors.bg)
-- fg("TelescopeResultsBorder", colors.bg)
