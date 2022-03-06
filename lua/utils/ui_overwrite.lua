local cmd = vim.cmd

local colors = {
    white = "#DCD7BA",
    darker_black = "#2A2A37",
    black = "#363646", --  nvim bg
    black2 = "#16161D",
    one_bg = "#1b1c27",
    one_bg2 = "#223249",
    one_bg3 = "#2D4F67",
    grey = "#727169",
    grey_fg = "#43444f",
    grey_fg2 = "#4d4e59",
    light_grey = "#555661",
    red = "#957FB8",
    baby_pink = "#C34043",
    pink = "#E46876",
    line = "#20212c",
    green = "#98c379",
    vibrant_green = "#95c561",
    nord_blue = "#9CABCA",
    blue = "#7FB4CA",
    yellow = "#C0A36E",
    sun = "#E6C384",
    purple = "#a485dd",
    dark_purple = "#9071c9",
    teal = "#519aba",
    orange = "#f6955b",
    cyan = "#38a89d",
    statusline_bg = "#151621",
    lightbg = "#22232e",
    lightbg2 = "#1c1d28",
    pmenu_bg = "#16161D",
    folder_bg = "#43242B",
}

local black = colors.black
local black2 = colors.black2
local blue = colors.blue
local darker_black = colors.darker_black
local folder_bg = colors.folder_bg
local green = colors.green
local grey = colors.grey
local grey_fg = colors.grey_fg
local line = colors.line
local nord_blue = colors.nord_blue
local one_bg = colors.one_bg
local one_bg2 = colors.one_bg2
local pmenu_bg = colors.pmenu_bg
local purple = colors.purple
local red = colors.red
local white = colors.white
local yellow = colors.yellow

local ui = {
    italic_comments = true,
    -- theme to be used, check available themes with `<leader> + t + h`
}

-- Define bg color
-- @param group Group
-- @param color Color
local function bg(group, color, args)
    local arg = {}
    if args then
        vim.tbl_extend("keep", arg, args)
    end
    arg["bg"] = color
    vim.api.nvim_set_hl(0, group, arg)
end

-- Define fg color
-- @param group Group
-- @param color Color
local function fg(group, color, args)
    local arg = {}
    if args then
        vim.tbl_extend("keep", arg, args)
    end
    arg["fg"] = color
    vim.api.nvim_set_hl(0, group, arg)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
local function fg_bg(group, fgcol, bgcol, args)
    local arg = {}
    if args then
        vim.tbl_extend("keep", arg, args)
    end
    arg["bg"] = bgcol
    arg["fg"] = fgcol
    vim.api.nvim_set_hl(0, group, arg)
end

-- Comments
-- if ui.italic_comments then
--   fg("Comment", grey_fg .. " gui=italic")
-- else
--   fg("Comment", grey_fg)
-- end

-- -- Disable cusror line
-- -- Line number
-- fg("cursorlinenr", white)

-- -- same it bg, so it doesn't appear
-- fg("EndOfBuffer", black)

-- For floating windows
fg_bg("NormalFloat", "NONE", "NONE")

-- Pmenu
bg("Pmenu", "NONE")

-- fg("ModeMsg", "NONE")

-- bg("PmenuSbar", one_bg)
-- bg("PmenuSel", blue)
-- bg("PmenuThumb", nord_blue)

-- [[ Plugin Highlights

-- Dashboard
-- fg("DashboardCenter", grey_fg)
-- fg("DashboardFooter", grey_fg)
-- fg("DashboardHeader", grey_fg)
-- fg("DashboardShortcut", grey_fg)

-- -- Git signs
-- fg_bg("DiffAdd", nord_blue, "none")
-- fg_bg("DiffChange", grey_fg, "none")
-- fg_bg("DiffModified", nord_blue, "none")

-- Indent blankline plugin
fg("IndentBlanklineChar", line)

-- ]]

-- [[ LspDiagnostics

-- -- Errors
-- fg("LspDiagnosticsSignError", red)
-- fg("LspDiagnosticsSignWarning", yellow)
-- fg("LspDiagnosticsVirtualTextError", red)
-- fg("LspDiagnosticsVirtualTextWarning", yellow)

-- -- Info
-- fg("LspDiagnosticsSignInformation", green)
-- fg("LspDiagnosticsVirtualTextInformation", green)

-- -- Hints
-- fg("LspDiagnosticsSignHint", purple)
-- fg("LspDiagnosticsVirtualTextHint", purple)

-- -- ]]

-- -- NvimTree
-- fg("NvimTreeEmptyFolderName", blue)
-- fg("NvimTreeEndOfBuffer", darker_black)
-- fg("NvimTreeFolderIcon", folder_bg)
-- fg("NvimTreeFolderName", folder_bg)
-- fg("NvimTreeGitDirty", red)
-- fg("NvimTreeIndentMarker", one_bg2)
-- bg("NvimTreeNormal", darker_black)
-- fg("NvimTreeOpenedFolderName", blue)
-- fg("NvimTreeRootFolder", red .. " gui=underline") -- enable underline for root folder in nvim tree
-- fg_bg("NvimTreeStatuslineNc", darker_black, darker_black)
-- fg("NvimTreeVertSplit", darker_black)
-- bg("NvimTreeVertSplit", darker_black)
-- fg_bg("NvimTreeWindowPicker", red, black2)

fg_bg("TelescopeBorder", darker_black, darker_black)
fg_bg("TelescopePromptBorder", black2, black2)
fg_bg("TelescopePreviewBorder", darker_black, darker_black)
fg_bg("TelescopeResultsBorder", darker_black, darker_black)

fg_bg("TelescopePromptNormal", white, black2)
fg_bg("TelescopePromptPrefix", red, black2)

bg("TelescopeNormal", darker_black)
bg("TelescopePreviewNormal", darker_black)

fg_bg("TelescopePreviewTitle", black, green)
fg_bg("TelescopePromptTitle", black, red)
fg_bg("TelescopeResultsTitle", black, blue)
fg("TelescopeSelection", blue)

bg("TelescopeSelection", "#353b45")
bg("TelescopePreviewLine", "#353b45")

-- Disable some highlight in nvim tree if transparency enabled
if ui.transparency then
    bg("NvimTreeNormal", "NONE")
    bg("NvimTreeStatusLineNC", "NONE")
    bg("NvimTreeVertSplit", "NONE")
    fg("NvimTreeVertSplit", grey)
    bg("TelescopeNormal", "NONE")
    bg("TelescopePreviewNormal", "NONE")
end

-- bg("Search","#938AA9")
-- bg("IncSearch", "#363646")

-- Telescope
fg("TelescopeBorder", folder_bg)
-- fg("TelescopePreviewBorder", folder_bg)
-- fg("TelescopePromptBorder", folder_bg)
-- fg("TelescopeResultsBorder", folder_bg)
