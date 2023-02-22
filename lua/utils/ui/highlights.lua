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

local M = {
    win_hl = {},
}
M.L = {
    error = P.samuraiRed,
    warn = P.roninYellow,
    hint = P.dragonBlue,
    info = P.waveAqua1,
}

local highlights = require("utils.ui.utils")
local function general_overrides()
    local normal_bg = highlights.get("Normal", "bg")
    local code_block = highlights.alter_color(normal_bg, 30)
    highlights.all({
        { Dim = { foreground = { from = "Normal", attr = "bg", alter = 25 } } },
        { VertSplit = { background = "NONE", foreground = { from = "NonText" } } },
        { WinSeparator = { background = "NONE", foreground = { from = "NonText" } } },
        { mkdLineBreak = { link = "NONE" } },
        { Directory = { inherit = "Keyword", bold = true } },
        ---------------------------------------------------------------------------//
        -- Commandline
        -----------------------------------------------------------------------------//
        { MsgArea = { background = { from = "Normal", alter = -10 } } },
        { MsgSeparator = { link = "MsgArea" } },

        -----------------------------------------------------------------------------//
        { CodeBlock = { background = { from = "Normal", alter = 30 } } },
        { markdownCode = { link = "CodeBlock" } },
        { markdownCodeBlock = { link = "CodeBlock" } },
        { CursorLineNr = { bold = true } },
        { PmenuSbar = { background = P.grey } },
        { PmenuThumb = { background = { from = "Comment", attr = "fg" } } },
        { Pmenu = { background = normal_bg } },

        { NormalFloat = { inherit = "Pmenu" } },
        -- todo fix this

        {
            FloatBorder = {
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
        {
            Folded = {
                inherit = "Comment",
                italic = true,
                bold = true,
                fg = P.springViolet1,
                bg = P.sumiInk2,
            },
        },

        -- -----------------------------------------------------------------------------//
        -- -- Diff
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
        -- -- Neither the sign column or end of buffer highlights require an explicit background
        -- -- they should both just use the background that is in the window they are in.
        -- -- if either are specified this can lead to issues when a winhighlight is set
        -- { SignColumn = { background = "NONE" } },
        -- { EndOfBuffer = { background = "NONE" } },
        -- -----------------------------------------------------------------------------//
        -- -- Treesitter
        -- ---------------------------------------------------------------------------//
        -- { TSVariable = { foreground = { from = "Normal" } } },
        -- { TSNamespace = { foreground = P.blue } },

        { TSNamespace = { bold = true } },
        { TSVariable = { bold = true } },
        { TSStorageClass = { bold = true } },
        { TSNamespace = { bold = true } },

        -- { ["@text.diff.add"] = { link = "DiffAdd" } },
        -- { ["@text.diff.delete"] = { link = "DiffDelete" } },

        -- { Comment = { italic = true } },
        -- { Type = { italic = true, bold = true } },
        -- { Include = { italic = true, bold = false } },
        -- { QuickFixLine = { inherit = "PmenuSbar", foreground = "NONE", italic = true } },
        -- -- Neither the sign column or end of buffer highlights require an explicit background
        -- -- they should both just use the background that is in the window they are in.
        -- -- if either are specified this can lead to issues when a winhighlight is set
        -- { SignColumn = { background = "NONE" } },
        -- { EndOfBuffer = { background = "NONE" } },
        -----------------------------------------------------------------------------//
        -- Treesitter
        -----------------------------------------------------------------------------//
        -- { ["@keyword.return"] = { italic = true, foreground = { from = "Keyword" } } },
        -- { ["@parameter"] = { italic = true, bold = true, foreground = "NONE" } },
        -- { ["@error"] = { foreground = "fg", background = "NONE" } },
        -- /{ TSError = { undercurl = true, sp = "DarkRed", foreground = "NONE" } },
        -- -- FIXME: this should be removed once
        -- -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3213 is resolved
        -- { yamlTSError = { link = "None" } },

        -- -- highlight FIXME comments
        { commentTSWarning = { background = P.springBlue, foreground = "bg", bold = true } },
        { commentTSDanger = { background = L.hint, foreground = "bg", bold = true } },
        { commentTSNote = { background = P.green, foreground = "bg", bold = true } },
        { CommentTasksTodo = { link = "commentTSWarning" } },
        { CommentTasksFixme = { link = "commentTSDanger" } },
        { CommentTasksNote = { link = "commentTSNote" } },

        -- -----------------------------------------------------------------------------//
        -- -- LSP
        -- -----------------------------------------------------------------------------//
        -- { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
        -- { LspCodeLensSeparator = { bold = false, italic = false } },
        -- {
        --     LspReferenceText = {
        --         underline = true,
        --         background = "NONE",
        --         special = { from = "Comment", attr = "fg" },
        --     },
        -- },
        -- {
        --     LspReferenceRead = {
        --         underline = true,
        --         background = "NONE",
        --         special = { from = "Comment", attr = "fg" },
        --     },
        -- },
        -- -- This represents when a reference is assigned which is more interesting than regular
        -- -- occurrences so should be highlighted more distinctly
        -- {
        --     LspReferenceWrite = {
        --         bold = true,
        --         italic = true,
        --         background = "NONE",
        --         underline = true,
        --         special = { from = "Comment", attr = "fg" },
        --     },
        -- },
        -- Base colours
        { DiagnosticHint = { foreground = L.hint } },
        { DiagnosticError = { foreground = L.error } },
        { DiagnosticWarning = { foreground = L.warn } },
        { DiagnosticInfo = { foreground = L.info } },
        -- Underline
        { DiagnosticUnderlineError = { undercurl = true, sp = L.error, foreground = "none" } },
        { DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, foreground = "none" } },
        { DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, foreground = "none" } },
        { DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, foreground = "none" } },
        -- Virtual Text
        { DiagnosticVirtualTextInfo = { bg = { from = "DiagnosticInfo", attr = "fg", alter = -70 } } },
        { DiagnosticVirtualTextHint = { bg = { from = "DiagnosticHint", attr = "fg", alter = -70 } } },
        { DiagnosticVirtualTextWarn = { bg = { from = "DiagnosticWarn", attr = "fg", alter = -80 } } },
        {
            DiagnosticVirtualTextError = { bg = { from = "DiagnosticError", attr = "fg", alter = -80 } },
        },
        -- Sign column line
        { DiagnosticSignInfoLine = { inherit = "DiagnosticVirtualTextInfo", fg = "NONE" } },
        { DiagnosticSignHintLine = { inherit = "DiagnosticVirtualTextHint", fg = "NONE" } },
        { DiagnosticSignErrorLine = { inherit = "DiagnosticVirtualTextError", fg = "NONE" } },
        { DiagnosticSignWarnLine = { inherit = "DiagnosticVirtualTextWarn", fg = "NONE" } },
        -- Sign column signs
        {
            DiagnosticSignWarn = {
                bg = { from = "DiagnosticVirtualTextWarn" },
                fg = { from = "DiagnosticWarn" },
            },
        },
        {
            DiagnosticSignInfo = {
                bg = { from = "DiagnosticVirtualTextInfo" },
                fg = { from = "DiagnosticInfo" },
            },
        },
        {
            DiagnosticSignHint = {
                bg = { from = "DiagnosticVirtualTextHint" },
                fg = { from = "DiagnosticHint" },
            },
        },
        {
            DiagnosticSignError = {
                bg = { from = "DiagnosticVirtualTextError" },
                fg = { from = "DiagnosticError" },
            },
        },
        -- Temp Highlight change
        {
            Cursor = {
                bg = { from = "black" },
                fg = { from = "DiagnosticError" },
            },
        },

        -- Sign column line number
        { DiagnosticSignWarnNr = { link = "DiagnosticSignWarn" } },
        { DiagnosticSignInfoNr = { link = "DiagnosticSignInfo" } },
        { DiagnosticSignHintNr = { link = "DiagnosticSignHint" } },
        { DiagnosticSignErrorNr = { link = "DiagnosticSignError" } },
        -- Sign column cursor line number
        { DiagnosticSignWarnCursorNr = { inherit = "DiagnosticSignWarn", bold = true } },
        { DiagnosticSignInfoCursorNr = { inherit = "DiagnosticSignInfo", bold = true } },
        { DiagnosticSignHintCursorNr = { inherit = "DiagnosticSignHint", bold = true } },
        { DiagnosticSignErrorCursorNr = { inherit = "DiagnosticSignError", bold = true } },
        -- Floating windows
        { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
        { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
        { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
        { DiagnosticFloatingError = { link = "DiagnosticError" } },

        { PanelDarkBackground = { bg = { from = "Normal", alter = -43 } } },
    })
end

local function set_sidebar_highlight()
    highlights.all({
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

local function set_telescope()
    local tele = {}
    if lambda.config.telescope_theme == "custom_bottom_no_borders" then
        tele = {

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
        }
    elseif lambda.config.telescope_theme == "float_all_borders" then
        tele = {
            { TelescopePromptTitle = { bg = P.grey, fg = { from = "Directory" }, bold = true } },
            { TelescopeResultsTitle = { bg = P.grey, fg = { from = "Normal" }, bold = true } },
            { TelescopePreviewTitle = { bg = P.grey, fg = { from = "Normal" }, bold = true } },
            { TelescopePreviewBorder = { fg = P.grey, bg = { from = "PanelBackground" } } },
            { TelescopePreviewNormal = { link = "PanelBackground" } },
            { TelescopePromptPrefix = { link = "Statement" } },
            { TelescopeBorder = { foreground = P.grey } },
            { TelescopeTitle = { inherit = "Normal", bold = true } },
        }
    end
    highlights.all(tele)
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
    vim.opt_local.winhighlight:append({
        Normal = "PanelBackground",
        EndOfBuffer = "PanelBackground",
        StatusLine = "PanelSt",
        StatusLineNC = "PanelStNC",
        SignColumn = "PanelBackground",
        VertSplit = "PanelVertSplit",
        WinSeparator = "PanelWinSeparator",
    })
end

local function colorscheme_overrides()
    local overrides = {
        ["doom-one"] = {

            { ["@namespace"] = { foreground = P.blue } },
            { ["@variable"] = { foreground = { from = "Normal" } } },

            { CursorLineNr = { foreground = { from = "Keyword" } } },
            { LineNr = { background = "NONE" } },
            { NeoTreeIndentMarker = { link = "Comment" } },
            { NeoTreeRootName = { bold = true, italic = true, foreground = "LightMagenta" } },
        },
        ["horizon"] = {
            -----------------------------------------------------------------------------------------------
            --- TODO: upstream these highlights to horizon.nvim
            -----------------------------------------------------------------------------------------------
            { Normal = { fg = "#C1C1C1" } },
            -----------------------------------------------------------------------------------------------
            { NormalNC = { inherit = "Normal" } },
            { WinSeparator = { fg = "#353647" } },
            { Constant = { bold = true } },
            { NonText = { fg = { from = "Comment" } } },
            { LineNr = { background = "NONE" } },
            { TabLineSel = { background = { from = "SpecialKey", attr = "fg" } } },
            { VisibleTab = { background = { from = "Normal", alter = 40 }, bold = true } },

            { ["@constant.comment"] = { inherit = "Constant", bold = true } },
            { ["@constructor.lua"] = { inherit = "Type", italic = false, bold = false } },

            { PanelBackground = { link = "Normal" } },
            { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
            { PanelHeading = { bg = "bg", bold = true, fg = { from = "Normal", alter = -30 } } },
            { PanelDarkBackground = { background = { from = "Normal", alter = -25 } } },
            { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
        },
    }
    local hls = overrides[vim.g.colors_name]
    if not hls then
        return
    end

    highlights.all(hls)
end

function user_highlights()
    general_overrides()
    set_sidebar_highlight()
    colorscheme_overrides()
    set_telescope()
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
