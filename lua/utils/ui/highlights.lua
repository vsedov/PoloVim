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

local highlights = lambda.highlight
local function general_overrides()
    local normal_bg = highlights.get("Normal", "bg")
    highlights.all({
        { Dim = { fg = { from = "Normal", attr = "bg", alter = 0.25 } } },
        { VertSplit = { fg = { from = "Comment" } } },
        { WinSeparator = { fg = { from = "Comment" } } },
        { mkdLineBreak = { clear = true } },
        { Directory = { inherit = "Keyword", bold = true } },
        { URL = { inherit = "Keyword", underline = true } },
        { ErrorMsg = { bg = "NONE" } },
        { UnderlinedTitle = { bold = true, underline = true } },
        ---------------------------------------------------------------------------//
        -- Commandline
        -----------------------------------------------------------------------------//
        { MsgArea = { bg = { from = "Normal", alter = -0.1 } } },
        { MsgSeparator = { link = "MsgArea" } },

        -----------------------------------------------------------------------------//
        { CodeBlock = { bg = { from = "Normal", alter = 0.3 } } },
        { markdownCode = { link = "CodeBlock" } },
        { markdownCodeBlock = { link = "CodeBlock" } },
        { CursorLineNr = { bold = true } },
        { iCursor = { bg = P.dark_blue } },
        { PmenuSbar = { bg = P.grey } },
        { PmenuThumb = { bg = { from = "Comment", attr = "fg" } } },
        { Pmenu = { bg = normal_bg } },

        { NormalFloat = { inherit = "Pmenu" } },
        -- todo fix this

        {
            FloatBorder = {
                bg = normal_bg,
                fg = P.grey,
            },
        },

        -- { FloatBorder = { bg = { from = 'Normal', alter = -15 }, fg = { from = 'Comment' } } },
        -- {NormalFloat = { inherit = "Pmenu" }},
        -- {FloatBorder = { inherit = "NormalFloat",fg= { from = "NonText" }}},

        -- {CodeBlock = {bg= code_block }},
        -- {markdownCode = {bg= code_block }},
        -- {markdownCodeBlock = {bg= code_block }},
        -- -----------------------------------------------------------------------------//
        { FoldColumn = { bg = "bg" } },
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
        --[[ { DiffAdd = {bg= "#26332c",fg= "NONE", underline = false } }, ]]
        --[[ { DiffDelete = {bg= "#572E33",fg= "#5c6370", underline = false } }, ]]
        --[[ { DiffChange = {bg= "#273842",fg= "NONE", underline = false } }, ]]
        --[[ { DiffText = {bg= "#314753",fg= "NONE" } }, ]]
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
        { QuickFixLine = { inherit = "PmenuSbar", fg = "NONE", italic = true } },
        -- -- Neither the sign column or end of buffer highlights require an explicit background
        -- -- they should both just use thebgthat is in the window they are in.
        -- -- if either are specified this can lead to issues when a winhighlight is set
        -- { SignColumn = {bg= "NONE" } },
        -- { EndOfBuffer = {bg= "NONE" } },
        -- -----------------------------------------------------------------------------//
        -- -- Treesitter
        -- ---------------------------------------------------------------------------//
        -- { TSVariable = {fg= { from = "Normal" } } },
        -- { TSNamespace = {fg= P.blue } },
        ------------------------------------------------------------------------------//
        --  Semantic tokens
        ------------------------------------------------------------------------------//

        ------------------------------------------------------------------------------//
        --  Semantic tokens
        ------------------------------------------------------------------------------//
        { ["@lsp.type.variable"] = { clear = true } },
        { ["@lsp.type.parameter"] = { italic = true, fg = { from = "Normal" } } },
        { ["@lsp.typemod.method"] = { link = "@method" } },
        { ["@lsp.typemod.variable.global"] = { bold = true, inherit = "@constant.builtin" } },
        { ["@lsp.typemod.variable.defaultLibrary"] = { italic = true } },
        { ["@lsp.typemod.variable.readonly.typescript"] = { clear = true } },
        { ["@lsp.type.type.lua"] = { clear = true } },
        { ["@lsp.typemod.number.injected"] = { link = "@number" } },
        { ["@lsp.typemod.operator.injected"] = { link = "@operator" } },
        { ["@lsp.typemod.keyword.injected"] = { link = "@keyword" } },
        { ["@lsp.typemod.string.injected"] = { link = "@string" } },
        { ["@lsp.typemod.variable.injected"] = { link = "@variable" } },
        -----------------------------------------------------------------------------//
        -- Treesitter
        -----------------------------------------------------------------------------//
        { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
        { ["@type.qualifier"] = { inherit = "@keyword", italic = true } },
        { ["@variable"] = { clear = true } },
        { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
        { ["@error"] = { fg = "fg", bg = "NONE" } },
        { ["@text.diff.add"] = { link = "DiffAdd" } },
        { ["@text.diff.delete"] = { link = "DiffDelete" } },
        { ["@text.title.markdown"] = { underdouble = true } },
        -----------------------------------------------------------------------------//

        { TSNamespace = { bold = true } },
        { TSVariable = { bold = true } },
        { TSStorageClass = { bold = true } },
        { TSNamespace = { bold = true } },

        -- { ["@text.diff.add"] = { link = "DiffAdd" } },
        -- { ["@text.diff.delete"] = { link = "DiffDelete" } },

        -- { Comment = { italic = true } },
        -- { Type = { italic = true, bold = true } },
        -- { Include = { italic = true, bold = false } },
        -- { QuickFixLine = { inherit = "PmenuSbar",fg= "NONE", italic = true } },
        -- -- Neither the sign column or end of buffer highlights require an explicit background
        -- -- they should both just use thebgthat is in the window they are in.
        -- -- if either are specified this can lead to issues when a winhighlight is set
        -- { SignColumn = {bg= "NONE" } },
        -- { EndOfBuffer = {bg= "NONE" } },
        -----------------------------------------------------------------------------//
        -- Treesitter
        -----------------------------------------------------------------------------//
        -- { ["@keyword.return"] = { italic = true,fg= { from = "Keyword" } } },
        -- { ["@parameter"] = { italic = true, bold = true,fg= "NONE" } },
        -- { ["@error"] = {fg= "fg",bg= "NONE" } },
        -- /{ TSError = { undercurl = true, sp = "DarkRed",fg= "NONE" } },
        -- -- FIXME: this should be removed once
        -- -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3213 is resolved
        -- { yamlTSError = { link = "None" } },

        -- -- highlight FIXME comments
        { commentTSWarning = { bg = P.springBlue, fg = "bg", bold = true } },
        { commentTSDanger = { bg = L.hint, fg = "bg", bold = true } },
        { commentTSNote = { bg = P.green, fg = "bg", bold = true } },
        { CommentTasksTodo = { link = "commentTSWarning" } },
        { CommentTasksFixme = { link = "commentTSDanger" } },
        { CommentTasksNote = { link = "commentTSNote" } },

        -- -----------------------------------------------------------------------------//
        -- -- LSP
        -- -----------------------------------------------------------------------------//

        { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
        { LspCodeLensSeparator = { bold = false, italic = false } },
        {
            LspReferenceText = { underdotted = true, bg = "NONE", sp = { from = "Comment", attr = "fg" } },
        },
        {
            LspReferenceRead = { underdotted = true, bg = "NONE", sp = { from = "Comment", attr = "fg" } },
        },
        -- This represents when a reference is assigned which is more interesting than regular
        -- occurrences so should be highlighted more distinctly
        {
            LspReferenceWrite = {
                bold = true,
                italic = true,
                bg = "NONE",
                underline = true,
                sp = { from = "Comment", attr = "fg" },
            },
        },

        -- Base colours
        { DiagnosticHint = { fg = L.hint } },
        { DiagnosticError = { fg = L.error } },
        { DiagnosticWarning = { fg = L.warn } },
        { DiagnosticInfo = { fg = L.info } },
        -- Underline
        { DiagnosticUnderlineError = { undercurl = true, sp = L.error, fg = "none" } },
        { DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, fg = "none" } },
        { DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, fg = "none" } },
        { DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, fg = "none" } },
        -- Virtual Text
        { DiagnosticVirtualTextInfo = { bg = { from = "DiagnosticInfo", attr = "fg", alter = -0.7 } } },
        { DiagnosticVirtualTextHint = { bg = { from = "DiagnosticHint", attr = "fg", alter = -0.7 } } },
        { DiagnosticVirtualTextWarn = { bg = { from = "DiagnosticWarn", attr = "fg", alter = -0.8 } } },
        {
            DiagnosticVirtualTextError = { bg = { from = "DiagnosticError", attr = "fg", alter = -0.8 } },
        },
        -- Sign column line
        { DiagnosticSignInfoLine = { inherit = "DiagnosticVirtualTextInfo", fg = "NONE" } },
        { DiagnosticSignHintLine = { inherit = "DiagnosticVirtualTextHint", fg = "NONE" } },
        { DiagnosticSignErrorLine = { inherit = "DiagnosticVirtualTextError", fg = "NONE" } },
        { DiagnosticSignWarnLine = { inherit = "DiagnosticVirtualTextWarn", fg = "NONE" } },
        -- Sign column signs
        { DiagnosticSignInfo = { fg = { from = "DiagnosticInfo" } } },
        { DiagnosticSignHint = { fg = { from = "DiagnosticHint" } } },
        {
            DiagnosticSignWarn = {
                bg = { from = "DiagnosticVirtualTextWarn" },
                fg = { from = "DiagnosticWarn" },
            },
        },
        {
            DiagnosticSignError = {
                bg = { from = "DiagnosticVirtualTextError" },
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

        { PanelDarkBackground = { bg = { from = "Normal", alter = -0.43 } } },
    })
end

local function set_sidebar_highlight()
    highlights.all({
        { PanelDarkBackground = { bg = { from = "Normal", alter = -0.42 } } },
        { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
        { PanelBackground = { bg = { from = "Normal", alter = -0.8 } } },
        { PanelHeading = { inherit = "PanelBackground", bold = true } },
        { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
        { PanelStNC = { link = "PanelWinSeparator" } },
        { PanelSt = { bg = { from = "Visual", alter = -0.2 } } },
    })
end

local function set_telescope()
    local tele = {}
    if lambda.config.telescope_theme == "custom_bottom_no_borders" then
        tele = {

            { TelescopeBorder = { fg = P.sumiInk2, bg = P.sumiInk2 } },
            { TelescopePromptBorder = { fg = P.sumiInk0, bg = P.sumiInk0 } },
            { TelescopePreviewBorder = { fg = P.sumiInk2, bg = P.sumiInk2 } },
            { TelescopeResultsBorder = { fg = P.sumiInk2, bg = P.sumiInk2 } },

            { TelescopePromptNormal = { fg = P.fujiWhite, bg = P.sumiInk0 } },
            { TelescopeNormal = { fg = P.red, bg = P.sumiInk2 } },
            { TelescopePreviewNormal = { bg = P.sumiInk2 } },

            { TelescopePreviewTitle = { fg = P.sumiInk3, bg = P.green } },
            { TelescopePromptTitle = { fg = P.sumiInk3, bg = P.oniViolet } },
            { TelescopeResultsTitle = { fg = P.sumiInk3, bg = P.springBlue } },
            { TelescopeSelection = { fg = P.springBlue, bg = P.fujiGray } },
            { TelescopeSelectionCaret = { fg = P.springBlue, bg = P.fujiGray } },
            { TelescopePreviewLine = { bg = P.fujiGray } },
        }
    elseif lambda.config.telescope_theme == "float_all_borders" then
        tele = {
            { TelescopePromptTitle = { bg = P.grey, fg = { from = "Directory" }, bold = true } },
            { TelescopeResultsTitle = { bg = P.grey, fg = { from = "Normal" }, bold = true } },
            { TelescopePreviewTitle = { bg = P.grey, fg = { from = "Normal" }, bold = true } },
            { TelescopePreviewBorder = { fg = P.grey, bg = { from = "PanelBackground" } } },
            { TelescopePreviewNormal = { link = "PanelBackground" } },
            { TelescopePromptPrefix = { link = "Statement" } },
            { TelescopeBorder = { fg = P.grey } },
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

            { ["@namespace"] = { fg = P.blue } },
            { ["@variable"] = { fg = { from = "Normal" } } },

            { CursorLineNr = { fg = { from = "Keyword" } } },
            { LineNr = { bg = "NONE" } },
            { NeoTreeIndentMarker = { link = "Comment" } },
            { NeoTreeRootName = { bold = true, italic = true, fg = "LightMagenta" } },
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
            { LineNr = { bg = "NONE" } },
            { TabLineSel = { bg = { from = "SpecialKey", attr = "fg" } } },
            { VisibleTab = { bg = { from = "Normal", alter = 0.4 }, bold = true } },
            { ["@variable"] = { fg = { from = "Normal" } } },
            { ["@constant.comment"] = { inherit = "Constant", bold = true } },
            { ["@constructor.lua"] = { inherit = "Type", italic = false, bold = false } },
            { ["@lsp.type.parameter"] = { fg = { from = "Normal" } } },
            { PanelBackground = { link = "Normal" } },
            { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
            { PanelHeading = { bg = "bg", bold = true, fg = { from = "Normal", alter = -0.3 } } },
            { PanelDarkBackground = { bg = { from = "Normal", alter = -0.25 } } },
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
