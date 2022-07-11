-- https://github.com/akinsho/dotfiles/blob/0fdf27f1499f58eb2118aa65338ffb96fe2e2abb/.config/nvim/lua/as/highlights.lua  akinsho config is honestly just god like wtf
local fmt = string.format
local fn = vim.fn
local api = vim.api
local P = {

    -- Bg Shades
    sumiInk0 = "#16161D",
    sumiInk1b = "#181820",
    sumiInk1 = "#1F1F28",
    sumiInk2 = "#2A2A37",
    sumiInk3 = "#363646",
    sumiInk4 = "#54546D",

    -- Popup and Floats
    waveBlue1 = "#223249",
    waveBlue2 = "#2D4F67",

    -- Diff and Git
    winterGreen = "#2B3328",
    winterYellow = "#49443C",
    winterRed = "#43242B",
    winterBlue = "#252535",
    autumnGreen = "#76946A",
    autumnRed = "#C34043",
    autumnYellow = "#DCA561",

    -- Diag
    samuraiRed = "#E82424",
    roninYellow = "#FF9E3B",
    waveAqua1 = "#6A9589",
    dragonBlue = "#658594",

    -- Fg and Comments
    oldWhite = "#C8C093",
    fujiWhite = "#DCD7BA",
    fujiGray = "#727169",
    springViolet1 = "#938AA9",

    oniViolet = "#957FB8",
    crystalBlue = "#7E9CD8",
    springViolet2 = "#9CABCA",
    springBlue = "#7FB4CA",
    lightBlue = "#A3D4D5", -- unused yet
    waveAqua2 = "#7AA89F", -- improve lightness: desaturated greenish Aqua

    waveAqua4 = "#7AA880",
    waveAqua5 = "#6CAF95",
    waveAqua3 = "#68AD99",

    springGreen = "#98BB6C",
    boatYellow1 = "#938056",
    boatYellow2 = "#C0A36E",
    carpYellow = "#E6C384",

    sakuraPink = "#D27E99",
    waveRed = "#E46876",
    peachRed = "#FF5D62",
    surimiOrange = "#FFA066",
    katanaGray = "#717C7C",

    --- Custom

    light_red = "#c43e1f",
    grey = "#3E4556",
    green = "#98c379",
}

local L = {
    error = P.samuraiRed,
    warn = P.roninYellow,
    hint = P.dragonBlue,
    info = P.waveAqua1,
}
local levels = vim.log.levels

function find(haystack, matcher)
    local found
    for _, needle in ipairs(haystack) do
        if matcher(needle) then
            found = needle
            break
        end
    end
    return found
end
local M = {}

---Convert a hex color to RGB
---@param color string
---@return number
---@return number
---@return number
local function hex_to_rgb(color)
    local hex = color:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent)
    return math.floor(attr * (100 + percent) / 100)
end

---@source https://stackoverflow.com/q/5560248
---@see: https://stackoverflow.com/a/37797380
---Darken a specified hex color
---@param color string
---@param percent number
---@return string
function M.alter_color(color, percent)
    local r, g, b = hex_to_rgb(color)
    if not r or not g or not b then
        return "NONE"
    end
    r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
    r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
    return fmt("#%02x%02x%02x", r, g, b)
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
--- @return boolean, string
function M.winhighlight_exists(win_id, ...)
    local win_hl = vim.wo[win_id].winhighlight
    for _, target in ipairs({ ... }) do
        if win_hl:match(target) ~= nil then
            return true, win_hl
        end
    end
    return false, win_hl
end

---@param group_name string A highlight group name
local function get_hl(group_name)
    local ok, hl = pcall(api.nvim_get_hl_by_name, group_name, true)
    if ok then
        hl.foreground = hl.foreground and "#" .. bit.tohex(hl.foreground, 6)
        hl.background = hl.background and "#" .. bit.tohex(hl.background, 6)
        hl[true] = nil -- BUG: API returns a true key which errors during the merge
        return hl
    end
    return {}
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id number
---@param target string
---@param name string
---@param fallback string
function M.adopt_winhighlight(win_id, target, name, fallback)
    local win_hl_name = name .. win_id
    local _, win_hl = M.winhighlight_exists(win_id, target)
    local hl_exists = fn.hlexists(win_hl_name) > 0
    if hl_exists then
        return win_hl_name
    end
    local parts = vim.split(win_hl, ",")
    local found = find(parts, function(part)
        return part:match(target)
    end)
    if not found then
        return fallback
    end
    local hl_group = vim.split(found, ":")[2]
    local bg = M.get_hl(hl_group, "bg")
    M.set_hl(win_hl_name, { background = bg, inherit = fallback })
    return win_hl_name
end

---This helper takes a table of highlights and converts any highlights
---specified as `highlight_prop = { from = 'group'}` into the underlying colour
---by querying the highlight property of the from group so it can be used when specifying highlights
---as a shorthand to derive the right color.
---For example:
---```lua
---  M.set_hl({ MatchParen = {foreground = {from = 'ErrorMsg'}}})
---```
---This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
---@param opts table<string, string|boolean|table<string,string>>
local function convert_hl_to_val(opts)
    for name, value in pairs(opts) do
        if type(value) == "table" and value.from then
            opts[name] = M.get_hl(value.from, vim.F.if_nil(value.attr, name))
        end
    end
end

---@param name string
---@param opts table
function M.set_hl(name, opts)
    assert(name and opts, "Both 'name' and 'opts' must be specified")
    local hl = get_hl(opts.inherit or name)
    convert_hl_to_val(opts)
    opts.inherit = nil
    local ok, msg = pcall(api.nvim_set_hl, 0, name, vim.tbl_deep_extend("force", hl, opts))
    if not ok then
        vim.notify(fmt("Failed to set %s because: %s", name, msg))
    end
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---in the right format
---@param group string
---@param attribute string
---@param fallback string?
---@return string
function M.get_hl(group, attribute, fallback)
    if not group then
        vim.notify("Cannot get a highlight without specifying a group", levels.ERROR)
        return "NONE"
    end
    local hl = get_hl(group)
    attribute = ({ fg = "foreground", bg = "background" })[attribute] or attribute
    local color = hl[attribute] or fallback
    if not color then
        vim.schedule(function()
            vim.notify(fmt("%s %s does not exist", group, attribute), levels.INFO)
        end)
        return "NONE"
    end
    -- convert the decimal RGBA value from the hl by name to a 6 character hex + padding if needed
    return color
end

function M.clear_hl(name)
    assert(name, "name is required to clear a highlight")
    api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, table<string, boolean|string>>
function M.all(hls)
    for name, hl in pairs(hls) do
        M.set_hl(name, hl)
    end
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@vararg table<string, table> map of highlights
function M.plugin(name, hls)
    name = name:gsub("^%l", string.upper) -- capitalise the name for autocommand convention sake
    M.all(hls)
    lambda.augroup(fmt("%sHighlightOverrides", name), {
        {
            event = "ColorScheme",
            command = function()
                M.all(hls)
            end,
        },
    })
end

local function general_overrides()
    local comment_fg = M.get_hl("Comment", "fg")
    local keyword_fg = M.get_hl("Keyword", "fg")
    local normal_bg = M.get_hl("Normal", "bg")
    local code_block = M.alter_color(normal_bg, 30)
    local msg_area_bg = M.alter_color(normal_bg, -10)
    local hint_line = M.alter_color(L.hint, -70)
    local error_line = M.alter_color(L.error, -80)
    local warn_line = M.alter_color(L.warn, -80)
    M.all({
        VertSplit = { background = "NONE", foreground = { from = "NonText" } },
        WinSeparator = { background = "NONE", foreground = { from = "NonText" } },
        mkdLineBreak = { link = "NONE" },
        Directory = { inherit = "Keyword", bold = true },
        URL = { inherit = "Keyword", underline = true },
        -----------------------------------------------------------------------------//
        -- Commandline
        -----------------------------------------------------------------------------//
        MsgArea = { background = msg_area_bg },
        MsgSeparator = { foreground = comment_fg, background = msg_area_bg },
        -----------------------------------------------------------------------------//
        -- Floats
        ---------------------------------------------------------------------------//
        NormalFloat = { inherit = "Pmenu" },
        FloatBorder = { inherit = "NormalFloat", foreground = { from = "NonText" } },
        CodeBlock = { background = code_block },
        markdownCode = { background = code_block },
        markdownCodeBlock = { background = code_block },
        -----------------------------------------------------------------------------//
        CursorLineNr = { bold = true },
        FoldColumn = { background = "background" },
        Folded = { inherit = "Comment", italic = true, bold = true },
        -- Add undercurl to existing spellbad highlight
        -- TODO(vsedov) (20:35:02 - 10/07/22): revert when this is stable
        -- SpellBad = { undercurl = true, background = "NONE", foreground = "NONE", sp = "green" },
        -- SpellRare = { undercurl = true }, -- a bit annoying
        PmenuSbar = { background = P.grey },

        -----------------------------------------------------------------------------//
        -- colorscheme overrides
        -----------------------------------------------------------------------------//
        Comment = { italic = true },
        Type = { italic = true, bold = true },
        Include = { italic = true, bold = false },
        QuickFixLine = { inherit = "PmenuSbar", foreground = "NONE", italic = true },
        -- Neither the sign column or end of buffer highlights require an explicit background
        -- they should both just use the background that is in the window they are in.
        -- if either are specified this can lead to issues when a winhighlight is set
        SignColumn = { background = "NONE" },
        EndOfBuffer = { background = "NONE" },
        MatchParen = {
            background = "NONE",
            foreground = "NONE",
            bold = false,
            -- underlineline = true,
            sp = "white",
        },
        -----------------------------------------------------------------------------//
        -- Treesitter
        -----------------------------------------------------------------------------//

        TSNamespace = { link = "TypeBuiltin" },
        TSKeywordReturn = { italic = true, foreground = keyword_fg },
        TSParameter = { italic = true, bold = true },
        -- this happens way to often so , gonna disable for the time
        -- -- TODO(vsedov) (20:34:49 - 10/07/22): revet
        -- TSError = { undercurl = true, sp = "DarkRed" },

        -- highlight FIXME comments

        commentTSWarning = { background = P.springBlue, foreground = "bg", bold = true },
        commentTSDanger = { background = L.hint, foreground = "bg", bold = true },
        commentTSNote = { background = P.green, foreground = "bg", bold = true },
        CommentTasksTodo = { link = "commentTSWarning" },
        CommentTasksFixme = { link = "commentTSDanger" },
        CommentTasksNote = { link = "commentTSNote" },

        -----------------------------------------------------------------------------//
        -- LSP
        -----------------------------------------------------------------------------//
        LspCodeLens = { link = "NonText" },
        LspReferenceText = { underline = false, background = "NONE" },
        LspReferenceRead = { underline = false, background = "NONE" },
        -- This represents when a reference is assigned which is more interesting than regular
        -- occurrences so should be highlighted more distinctly
        LspReferenceWrite = { underline = false, bold = true, italic = true, background = "NONE" },

        DiagnosticHeader = { link = "Special", fg = "#56b6c2", bold = true },
        DiagnosticHint = { foreground = L.hint },
        DiagnosticError = { foreground = L.error },
        DiagnosticWarning = { foreground = L.warn },
        DiagnosticInfo = { foreground = L.info },
        DiagnosticUnderlineError = {
            underline = false,
            undercurl = true,
            sp = L.error,
            foreground = "none",
        },
        DiagnosticUnderlineHint = {
            underline = false,
            undercurl = true,
            sp = L.hint,
            foreground = "none",
        },
        DiagnosticUnderlineWarn = {
            underline = false,
            undercurl = true,
            sp = L.warn,
            foreground = "none",
        },
        DiagnosticUnderlineInfo = {
            underline = false,
            undercurl = true,
            sp = L.info,
            foreground = "none",
        },
        DiagnosticSignHintLine = { background = hint_line },
        DiagnosticSignErrorLine = { background = error_line },
        DiagnosticSignWarnLine = { background = warn_line },
        DiagnosticSignHintNr = {
            inherit = "DiagnosticSignHintLine",
            foreground = { from = "Normal" },
            bold = true,
        },
        DiagnosticSignErrorNr = {
            inherit = "DiagnosticSignErrorLine",
            foreground = { from = "Normal" },
            bold = true,
        },
        DiagnosticSignWarnNr = {
            inherit = "DiagnosticSignWarnLine",
            foreground = { from = "Normal" },
            bold = true,
        },
        DiagnosticSignWarn = { link = "DiagnosticWarn" },
        DiagnosticSignInfo = { link = "DiagnosticInfo" },
        DiagnosticSignHint = { link = "DiagnosticHint" },
        DiagnosticSignError = { link = "DiagnosticError" },
        DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
        DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
        DiagnosticFloatingHint = { link = "DiagnosticHint" },
        DiagnosticFloatingError = { link = "DiagnosticError" },

        -- - telescope

        TelescopeBorder = { foreground = P.sumiInk2, background = P.sumiInk2 },
        TelescopePromptBorder = { foreground = P.sumiInk0, background = P.sumiInk0 },
        TelescopePreviewBorder = { foreground = P.sumiInk2, background = P.sumiInk2 },
        TelescopeResultsBorder = { foreground = P.sumiInk2, background = P.sumiInk2 },

        TelescopePromptNormal = { foreground = P.fujiWhite, background = P.sumiInk0 },
        TelescopeNormal = { foreground = P.red, background = P.sumiInk2 },
        TelescopePreviewNormal = { background = P.sumiInk2 },

        TelescopePreviewTitle = { foreground = P.sumiInk3, background = P.green },
        TelescopePromptTitle = { foreground = P.sumiInk3, background = P.oniViolet },
        TelescopeResultsTitle = { foreground = P.sumiInk3, background = P.springBlue },
        TelescopeSelection = { foreground = P.springBlue, background = P.fujiGray },
        TelescopeSelectionCaret = { foreground = P.springBlue, background = P.fujiGray },
        TelescopePreviewLine = { background = P.fujiGray },
    })
end

local function set_sidebar_highlight()
    local normal_bg = M.get_hl("Normal", "bg")
    local split_color = M.get_hl("VertSplit", "fg")
    local bg_color = M.alter_color(normal_bg, -8)
    local st_color = M.alter_color(M.get_hl("Visual", "bg"), -20)
    M.all({
        PanelBackground = { background = bg_color },
        PanelHeading = { background = bg_color, bold = true },
        PanelVertSplit = { foreground = split_color, background = bg_color },
        PanelWinSeparator = { foreground = split_color, background = bg_color },
        PanelStNC = { background = bg_color, foreground = split_color },
        PanelSt = { background = st_color },
    })
end

local sidebar_fts = {
    "packer",
    "flutterToolsOutline",
    "undotree",
    "neo-tree",
    "Outline",
}

local function on_sidebar_enter()
    vim.wo.winhighlight = table.concat({
        "Normal:PanelBackground",
        "EndOfBuffer:PanelBackground",
        "StatusLine:PanelSt",
        "StatusLineNC:PanelStNC",
        "SignColumn:PanelBackground",
        "VertSplit:PanelVertSplit",
        "WinSeparator:PanelWinSeparator",
    }, ",")
end

local function colorscheme_overrides()
    if vim.g.colors_name == "doom-one" then
        M.all({
            CursorLineNr = { foreground = { from = "Keyword" } },
            LineNr = { background = "NONE" },
        })
    end
end

local function user_highlights()
    general_overrides()
    colorscheme_overrides()
    set_sidebar_highlight()
end

lambda.augroup("UserHighlights", {
    {
        event = "BufEnter",
        command = function()
            user_highlights()
        end,
    },
    {
        event = "FileType",
        pattern = sidebar_fts,
        command = function()
            on_sidebar_enter()
        end,
    },
})

return M
