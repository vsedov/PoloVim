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
    whitesmoke = "#9E9E9E",
}

local L = {
    error = P.samuraiRed,
    warn = P.roninYellow,
    hint = P.dragonBlue,
    info = P.waveAqua1,
}
local levels = vim.log.levels

local M = {}
M.L = {
    error = P.samuraiRed,
    warn = P.roninYellow,
    hint = P.dragonBlue,
    info = P.waveAqua1,
}

---@class HighlightAttributes
---@field from string
---@field attr 'foreground' | 'fg' | 'background' | 'bg'
---@field alter integer

---@class HighlightKeys
---@field blend integer
---@field foreground string | HighlightAttributes
---@field background string | HighlightAttributes
---@field fg string | HighlightAttributes
---@field bg string | HighlightAttributes
---@field sp string | HighlightAttributes
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdot boolean

---@class NvimHighlightData
---@field foreground string
---@field background string
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdot boolean

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
---@param color string A hex color
---@param percent integer a negative number darkens and a positive one brightens
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

---@param group_name string A highlight group name
local function get_highlight(group_name)
    local ok, hl = pcall(api.nvim_get_hl_by_name, group_name, true)
    if not ok then
        return {}
    end
    hl.foreground = hl.foreground and "#" .. bit.tohex(hl.foreground, 6)
    hl.background = hl.background and "#" .. bit.tohex(hl.background, 6)
    hl[true] = nil -- BUG: API returns a true key which errors during the merge
    return hl
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param group string
---@param attribute string?
---@param fallback string?
---@return string
---@overload fun(group: string): NvimHighlightData
function M.get(group, attribute, fallback)
    assert(group, "cannot get a highlight without specifying a group name")
    local data = get_highlight(group)
    if not attribute then
        return data
    end
    local attr = ({ fg = "foreground", bg = "background" })[attribute] or attribute
    local color = data[attr] or fallback
    if color then
        return color
    end
    local msg = fmt("%s's %s does not exist", group, attr)
    vim.schedule(function()
        vim.notify(msg, "error")
    end)
    return "NONE"
end

--- Sets a neovim highlight with some syntactic sugar. It takes a highlight table and converts
--- any highlights specified as `GroupName = { from = 'group'}` into the underlying colour
--- by querying the highlight property of the from group so it can be used when specifying highlights
--- as a shorthand to derive the right color.
--- For example:
--- ```lua
---   M.set({ MatchParen = {foreground = {from = 'ErrorMsg'}}})
--- ```
--- This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
---@param name string
---@param opts HighlightKeys
---@overload fun(namespace: integer, name: string, opts: HighlightKeys)
function M.set(namespace, name, opts)
    if type(namespace) == "string" and type(name) == "table" then
        opts, name, namespace = name, namespace, 0
    end

    assert(name and opts, "Both 'name' and 'opts' must be specified")
    assert(type(name) == "string", fmt("Name must be a string but got '%s'", name))
    assert(type(opts) == "table", fmt("Opts must be a table but got '%s'", vim.inspect(opts)))
    assert(namespace, "You must specify a valid namespace, you passed %s", vim.inspect(namespace))

    local hl = get_highlight(opts.inherit or name)
    opts.inherit = nil

    for attr, value in pairs(opts) do
        if type(value) == "table" and value.from then
            opts[attr] = M.get(value.from, value.attr or attr)
            if value.alter then
                opts[attr] = M.alter_color(opts[attr], value.alter)
            end
        end
    end

    local ok, msg = pcall(api.nvim_set_hl, namespace, name, vim.tbl_extend("force", hl, opts))
    if not ok then
        vim.notify(fmt("Failed to set %s because - %s", name, msg))
    end
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
--- @return boolean, string
function M.has_win_highlight(win_id, ...)
    local win_hl = vim.wo[win_id].winhighlight
    for _, target in ipairs({ ... }) do
        if win_hl:match(target) ~= nil then
            return true, win_hl
        end
    end
    return false, win_hl
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id integer
---@param target string
---@param name string
---@param fallback string
function M.adopt_win_highlight(win_id, target, name, fallback)
    local win_hl_name = name .. win_id
    local _, win_hl = M.has_win_highlight(win_id, target)

    if pcall(api.nvim_get_hl_by_name, win_hl_name, true) then
        return win_hl_name
    end

    local hl = lambda.find(function(part)
        return part:match(target)
    end, vim.split(win_hl, ","))
    if not hl then
        return fallback
    end

    local hl_group = vim.split(hl, ":")[2]
    M.set(win_hl_name, { inherit = fallback, background = { from = hl_group, attr = "bg" } })
    return win_hl_name
end

function M.clear(name)
    assert(name, "name is required to clear a highlight")
    api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, HighlightKeys>
---@param namespace integer?
function M.all(hls, namespace)
    lambda.foreach(function(hl)
        M.set(namespace or 0, next(hl))
    end, hls)
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@param opts table<string, table> map of highlights
function M.plugin(name, opts)
    -- Options can be specified by theme name so check if they have been or there is a general
    -- definition otherwise use the opts as is
    local theme = opts.theme
    if theme then
        local res, seen = {}, {}
        local list = vim.list_extend(theme[vim.g.colors_name] or {}, theme["*"] or {})
        for _, hl in ipairs(list) do
            local n = next(hl)
            if not seen[n] then
                res[#res + 1] = hl
            end
            seen[n] = true
        end
        opts = res
        if not next(opts) then
            return
        end
    end
    -- capitalise the name for autocommand convention sake
    name = name:gsub("^%l", string.upper)
    M.all(opts)
    lambda.augroup(fmt("%sHighlightOverrides", name), {
        {
            event = "ColorScheme",
            command = function()
                -- Defer resetting these highlights to ensure they apply after other overrides
                vim.defer_fn(function()
                    M.all(opts)
                end, 1)
            end,
        },
    })
end

local function general_overrides()
    local normal_bg = M.get("Normal", "bg")
    local code_block = M.alter_color(normal_bg, 30)
    M.all({
        { Dim = { foreground = { from = "Normal", attr = "bg", alter = 25 } } },
        { VertSplit = { background = "NONE", foreground = { from = "NonText" } } },
        { WinSeparator = { background = "NONE", foreground = { from = "NonText" } } },
        { mkdLineBreak = { link = "NONE" } },
        { Directory = { inherit = "Keyword", bold = true } },
        { URL = { inherit = "Keyword", underline = true } },
        -----------------------------------------------------------------------------//
        -- Commandline
        -----------------------------------------------------------------------------//
        { MsgArea = { background = { from = "Normal", alter = -10 } } },
        { MsgSeparator = { link = "MsgArea" } },

        -----------------------------------------------------------------------------//
        { CodeBlock = { background = { from = "Normal", alter = 30 } } },
        { markdownCode = { link = "CodeBlock" } },
        { markdownCodeBlock = { link = "CodeBlock" } },
        -- {
        --     CurSearch = {
        --         background = { from = "String", attr = "fg" },
        --         foreground = "white",
        --         bold = true,
        --     },
        -- },
        { CursorLineNr = { bold = true } },
        -- { FoldColumn = { background = "background" } },
        -- Add undercurl to existing spellbad highlight
        -- -- { SpellBad = { undercurl = true, background = 'NONE', foreground = 'NONE', sp = 'green' } },
        -- -- { SpellRare = { undercurl = true } },

        { PmenuSbar = { background = P.grey } },
        { PmenuThumb = { background = { from = "Comment", attr = "fg" } } },
        { Pmenu = { background = normal_bg } },

        { NormalFloat = { inherit = "Pmenu" } },
        -- todo fix this

        {
            FloatBorder = {
                -- bg = { from = 'Normal', alter = -15 },
                -- fg = { from = 'Normal', alter = -15}
                background = normal_bg,
                foreground = P.grey,
            },
        },
        -- { FloatBorder = { bg = { from = 'Normal', alter = -15 }, fg = { from = 'Comment' } } },
        -- {NormalFloat = { inherit = "Pmenu" }},
        -- {FloatBorder = { inherit = "NormalFloat", foreground = { from = "NonText" }}},

        -- {CodeBlock = { background = code_block }},
        -- {markdownCode = { background = code_block }},
        -- {markdownCodeBlock = { background = code_block }},
        -- -----------------------------------------------------------------------------//
        { FoldColumn = { background = "bg" } },
        { Folded = { inherit = "Comment", italic = true, bold = true, fg = P.springViolet1, bg = P.sumiInk2 } },

        -----------------------------------------------------------------------------//
        -- Diff
        -----------------------------------------------------------------------------//
        --[[ { DiffAdd = { background = "#26332c", foreground = "NONE", underline = false } }, ]]
        --[[ { DiffDelete = { background = "#572E33", foreground = "#5c6370", underline = false } }, ]]
        --[[ { DiffChange = { background = "#273842", foreground = "NONE", underline = false } }, ]]
        --[[ { DiffText = { background = "#314753", foreground = "NONE" } }, ]]
        { diffAdded = { link = "DiffAdd" } },
        { diffChanged = { link = "DiffChange" } },
        { diffRemoved = { link = "DiffDelete" } },
        { diffBDiffer = { link = "WarningMsg" } },
        { diffCommon = { link = "WarningMsg" } },
        { diffDiffer = { link = "WarningMsg" } },
        { diffFile = { link = "Directory" } },
        { diffIdentical = { link = "WarningMsg" } },
        { diffIndexLine = { link = "Number" } },
        { diffIsA = { link = "WarningMsg" } },
        { diffNoEOL = { link = "WarningMsg" } },
        { diffOnly = { link = "WarningMsg" } },
        -----------------------------------------------------------------------------//
        -- colorscheme overrides
        -----------------------------------------------------------------------------//
        { Comment = { italic = true } },
        { Type = { italic = true, bold = true } },
        { Include = { italic = true, bold = false } },
        { QuickFixLine = { inherit = "PmenuSbar", foreground = "NONE", italic = true } },
        -- Neither the sign column or end of buffer highlights require an explicit background
        -- they should both just use the background that is in the window they are in.
        -- if either are specified this can lead to issues when a winhighlight is set
        { SignColumn = { background = "NONE" } },
        { EndOfBuffer = { background = "NONE" } },
        -----------------------------------------------------------------------------//
        -- Treesitter
        -----------------------------------------------------------------------------//
        { TSVariable = { foreground = { from = "Normal" } } },

        { TSKeywordReturn = { italic = true, foreground = { from = "Keyword" } } },
        { TSParameter = { italic = true, bold = true, foreground = "NONE" } },
        { TSError = { undercurl = true, sp = "DarkRed", foreground = "NONE" } },
        -- { TSError = { undercurl = true, sp = "DarkRed", foreground = "NONE" } },
        -- FIXME: this should be removed once
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3213 is resolved
        { yamlTSError = { link = "None" } },
        -- highlight FIXME comments
        { commentTSWarning = { background = P.springBlue, foreground = "bg", bold = true } },
        { commentTSDanger = { background = L.hint, foreground = "bg", bold = true } },
        { commentTSNote = { background = P.green, foreground = "bg", bold = true } },
        { CommentTasksTodo = { link = "commentTSWarning" } },
        { CommentTasksFixme = { link = "commentTSDanger" } },
        { CommentTasksNote = { link = "commentTSNote" } },
        -----------------------------------------------------------------------------//
        -- LSP
        -----------------------------------------------------------------------------//
        { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
        { LspCodeLensSeparator = { bold = false, italic = false } },
        { LspReferenceText = { underline = true, background = "NONE", sp = P.comment_fg } },
        { LspReferenceRead = { underline = true, background = "NONE", sp = P.comment_fg } },
        -- This represents when a reference is assigned which is more interesting than regular
        -- occurrences so should be highlighted more distinctly
        {
            LspReferenceWrite = {
                underline = true,
                bold = true,
                italic = true,
                background = "NONE",
                sp = P.whitesmoke,
            },
        },
        { DiagnosticHint = { foreground = L.hint } },
        { DiagnosticError = { foreground = L.error } },
        { DiagnosticWarning = { foreground = L.warn } },
        { DiagnosticInfo = { foreground = L.info } },
        { DiagnosticUnderlineError = { undercurl = true, sp = L.error, foreground = "none" } },
        { DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, foreground = "none" } },
        { DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, foreground = "none" } },
        { DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, foreground = "none" } },
        {
            DiagnosticVirtualTextInfo = {
                background = { from = "DiagnosticInfo", attr = "fg", alter = -70 },
            },
        },
        {
            DiagnosticVirtualTextHint = {
                background = { from = "DiagnosticHint", attr = "fg", alter = -70 },
            },
        },
        {
            DiagnosticVirtualTextError = {
                background = { from = "DiagnosticError", attr = "fg", alter = -80 },
            },
        },
        {
            DiagnosticVirtualTextWarn = {
                background = { from = "DiagnosticWarn", attr = "fg", alter = -80 },
            },
        },
        { DiagnosticSignWarn = { link = "DiagnosticWarn" } },
        { DiagnosticSignInfo = { link = "DiagnosticInfo" } },
        { DiagnosticSignHint = { link = "DiagnosticHint" } },
        { DiagnosticSignError = { link = "DiagnosticError" } },
        { DiagnosticSignWarnLine = { inherit = "DiagnosticWarn", bg = { from = "CursorLine" } } },
        { DiagnosticSignInfoLine = { inherit = "DiagnosticInfo", bg = { from = "CursorLine" } } },
        { DiagnosticSignHintLine = { inherit = "DiagnosticHint", bg = { from = "CursorLine" } } },
        { DiagnosticSignErrorLine = { inherit = "DiagnosticError", bg = { from = "CursorLine" } } },
        { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
        { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
        { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
        { DiagnosticFloatingError = { link = "DiagnosticError" } },

        { TelescopeBorder = { foreground = P.sumiInk2, background = P.sumiInk2 } },
        { TelescopePromptBorder = { foreground = P.sumiInk0, background = P.sumiInk0 } },
        { TelescopePreviewBorder = { foreground = P.sumiInk2, background = P.sumiInk2 } },
        { TelescopeResultsBorder = { foreground = P.sumiInk2, background = P.sumiInk2 } },

        { TelescopePromptNormal = { foreground = P.fujiWhite, background = P.sumiInk0 } },
        { TelescopeNormal = { foreground = P.red, background = P.sumiInk2 } },
        { TelescopePreviewNormal = { background = P.sumiInk2 } },

        { TelescopePreviewTitle = { foreground = P.sumiInk3, background = P.green } },
        { TelescopePromptTitle = { foreground = P.sumiInk3, background = P.oniViolet } },
        { TelescopeResultsTitle = { foreground = P.sumiInk3, background = P.springBlue } },
        { TelescopeSelection = { foreground = P.springBlue, background = P.fujiGray } },
        { TelescopeSelectionCaret = { foreground = P.springBlue, background = P.fujiGray } },
        { TelescopePreviewLine = { background = P.fujiGray } },

        { PanelDarkBackground = { bg = { from = "Normal", alter = -43 } } },
    })
end

local function set_sidebar_highlight()
    M.all({
        { PanelDarkBackground = { bg = { from = "Normal", alter = -42 } } },
        { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
        { PanelBackground = { background = { from = "Normal", alter = -8 } } },
        { PanelHeading = { inherit = "PanelBackground", bold = true } },
        {
            PanelWinSeparator = {
                inherit = "PanelBackground",
                foreground = { from = "WinSeparator" },
            },
        },
        { PanelStNC = { link = "PanelWinSeparator" } },
        { PanelSt = { background = { from = "Visual", alter = -20 } } },
    })
end

local sidebar_fts = {
    "packer",
    "flutterToolsOutline",
    "undotree",
    "Outline",
    "dbui",
    "neotest-summary",
    "pr",
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
    local overrides = {
        ["doom-one"] = {
            { TSNamespace = { foreground = P.blue } },
            { TSVariable = { foreground = { from = "Normal" } } },
            { CursorLineNr = { foreground = { from = "Keyword" } } },
            { LineNr = { background = "NONE" } },
            { NeoTreeIndentMarker = { link = "Comment" } },
            { NeoTreeRootName = { bold = true, italic = true, foreground = "LightMagenta" } },
        },
        ["horizon"] = {
            { Normal = { fg = "#C1C1C1" } }, -- TODO: Upstream normal foreground color
            { Constant = { bold = true } },
            { NonText = { fg = { from = "Comment" } } },
            { LineNr = { background = "NONE" } },
            { TabLineSel = { background = { from = "SpecialKey", attr = "fg" } } },
            { VisibleTab = { background = { from = "Normal", alter = 20 }, bold = true } },
            { commentTSConstant = { inherit = "Constant", bold = true } },
            { luaTSConstructor = { inherit = "Type", italic = false, bold = false } },
            { PanelBackground = { link = "Normal" } },
            { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
            { PanelHeading = { bg = "bg", bold = true, fg = { from = "Normal", alter = -30 } } },
            { PanelDarkBackground = { background = { from = "Normal", alter = -25 } } },
            { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
            -- TODO: set ColorColumn instead as this normally links to that
            { Headline = { background = { from = "Normal", alter = 20 } } },
        },
    }
    local hls = overrides[vim.g.colors_name]
    if not hls then
        return
    end

    M.all(hls)
end

local function user_highlights()
    general_overrides()
    set_sidebar_highlight()
    colorscheme_overrides()
end

lambda.augroup("UserHighlights", {
    {
        event = "ColorScheme",
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

-- colorscheme_table : {{name = softmax, name = softmax}, {name = softmax, name = softmax}}

return M
