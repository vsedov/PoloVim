local conf = require("modules.colourscheme.config")
local colourscheme = require("core.pack").package

colourscheme({
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = conf.kanagawa,
})

colourscheme({
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    cmd = "CatppuccinCompile",
    init = function()
        vim.g.catppuccin_flavour = lambda.config.colourscheme.catppuccin_flavour -- latte, frappe, macchiato, mocha
    end,
    config = conf.catppuccin,
})

-- temp::
colourscheme({
    "rose-pine/neovim", -- rose-pine/neovim
    lazy = true,
    name = "rose",
    config = conf.rose,
})

colourscheme({
    "lunarvim/horizon.nvim",
    lazy = true,
    config = conf.horizon,
})
colourscheme({
    "wadackel/vim-dogrun",
    lazy = true,
    config = conf.dogrun,
})

colourscheme({
    "folke/tokyonight.nvim",
    lazy = true,
    config = conf.tokyonight,
})
colourscheme({
    "olimorris/onedarkpro.nvim",
    event = "VeryLazy",
    opts = {
        colors = {
            dark = {
                codeblock = "require('onedarkpro.helpers').lighten('bg', 2, 'onedark')",
                statusline_bg = "#2e323b", -- gray
                statuscolumn_border = "#4b5160", -- gray
                ellipsis = "#808080", -- gray
                telescope_prompt = "require('onedarkpro.helpers').darken('bg', 1, 'onedark')",
                telescope_results = "require('onedarkpro.helpers').darken('bg', 4, 'onedark')",
                telescope_preview = "require('onedarkpro.helpers').darken('bg', 6, 'onedark')",
                telescope_selection = "require('onedarkpro.helpers').darken('bg', 8, 'onedark')",
                copilot = "require('onedarkpro.helpers').darken('gray', 8, 'onedark')",
                breadcrumbs = "require('onedarkpro.helpers').darken('gray', 10, 'onedark')",
                local_highlight = "require('onedarkpro.helpers').lighten('bg', 4, 'onedark')",
                light_gray = "require('onedarkpro.helpers').darken('gray', 7, 'onedark')",
            },
        },
        highlights = {
            CodeCompanionTokens = { fg = "${gray}", italic = true },
            CodeCompanionVirtualText = { fg = "${gray}", italic = true },

            ["@markup.raw.block.markdown"] = { bg = "${codeblock}" },
            ["@markup.quote.markdown"] = { italic = true, extend = true },

            EdgyNormal = { bg = "${bg}" },
            EdgyTitle = { fg = "${purple}", bold = true },

            EyelinerPrimary = { fg = "${green}" },
            EyelinerSecondary = { fg = "${blue}" },

            NormalFloat = { bg = "${bg}" }, -- Set the terminal background to be the same as the editor
            FloatBorder = { fg = "${gray}", bg = "${bg}" },

            CursorLineNr = { bg = "${bg}", fg = "${fg}", italic = true },
            DiffChange = { underline = true }, -- diff mode: Changed line |diff.txt|
            LocalHighlight = { bg = "${local_highlight}" },
            MatchParen = { fg = "${cyan}" },
            ModeMsg = { fg = "${gray}" }, -- Make command line text lighter
            Search = { bg = "${selection}", fg = "${yellow}", underline = true },
            VimLogo = { fg = { dark = "#81b766", light = "#029632" } },

            -- Aerial plugin
            AerialClass = { fg = "${purple}", bold = true, italic = true },
            AerialClassIcon = { fg = "${purple}" },
            AerialConstructorIcon = { fg = "${yellow}" },
            AerialEnumIcon = { fg = "${blue}" },
            AerialFunctionIcon = { fg = "${blue}" },
            AerialInterfaceIcon = { fg = "${orange}" },
            AerialMethodIcon = { fg = "${green}" },
            AerialObjectIcon = { fg = "${purple}" },
            AerialPackageIcon = { fg = "${fg}" },
            AerialStructIcon = { fg = "${cyan}" },
            AerialVariableIcon = { fg = "${orange}" },

            -- Alpha
            AlphaHeader = {
                fg = { dark = "${green}", light = "${red}" },
            },
            AlphaButtonText = {
                fg = "${blue}",
                bold = true,
            },
            AlphaButtonShortcut = {
                fg = { dark = "${green}", light = "${yellow}" },
                italic = true,
            },
            AlphaFooter = { fg = "${gray}", italic = true },

            -- Cmp
            CmpItemAbbrMatch = { fg = "${blue}", bold = true },
            CmpItemAbbrMatchFuzzy = { fg = "${blue}", underline = true },

            -- Copilot
            CopilotSuggestion = { fg = "${copilot}", italic = true },

            -- DAP
            DebugBreakpoint = { fg = "${red}", italic = true },
            DebugHighlightLine = { fg = "${purple}", italic = true },
            NvimDapVirtualText = { fg = "${cyan}", italic = true },

            -- DAP UI
            DapUIBreakpointsCurrentLine = { fg = "${yellow}", bold = true },

            -- Diagflow.nvim
            DiagnosticFloatingError = { fg = "${red}", italic = true },
            DiagnosticFloatingWarn = { fg = "${yellow}", italic = true },
            DiagnosticFloatingHint = { fg = "${cyan}", italic = true },
            DiagnosticFloatingInfo = { fg = "${blue}", italic = true },

            -- Heirline
            Heirline = { bg = "${statusline_bg}" },
            HeirlineStatusColumn = { fg = "${statuscolumn_border}" },
            HeirlineBufferline = { fg = { dark = "#939aa3", light = "#6a6a6a" } },
            HeirlineWinbar = { fg = "${breadcrumbs}", italic = true },

            -- Luasnip
            LuaSnipChoiceNode = { fg = "${yellow}" },
            LuaSnipInsertNode = { fg = "${yellow}" },

            ["@markup.list.unchecked.markdown"] = { fg = "${bg}", bg = "${fg}" },

            -- Neotest
            NeotestAdapterName = { fg = "${purple}", bold = true },
            NeotestFocused = { bold = true },
            NeotestNamespace = { fg = "${blue}", bold = true },

            -- Nvim UFO
            UfoFoldedEllipsis = { fg = "${yellow}" },

            -- Telescope
            TelescopeBorder = {
                fg = "${telescope_results}",
                bg = "${telescope_results}",
            },
            TelescopePromptPrefix = {
                fg = "${purple}",
            },
            TelescopePromptBorder = {
                fg = "${telescope_prompt}",
                bg = "${telescope_prompt}",
            },
            TelescopePromptCounter = { fg = "${fg}" },
            TelescopePromptNormal = { fg = "${fg}", bg = "${telescope_prompt}" },
            TelescopePromptTitle = {
                fg = "${telescope_prompt}",
                bg = "${purple}",
            },
            TelescopePreviewTitle = {
                fg = "${telescope_results}",
                bg = "${green}",
            },
            TelescopeResultsTitle = {
                fg = "${telescope_results}",
                bg = "${telescope_results}",
            },
            TelescopeMatching = { fg = "${blue}" },
            TelescopeNormal = { bg = "${telescope_results}" },
            TelescopeSelection = { bg = "${telescope_selection}" },
            TelescopePreviewNormal = { bg = "${telescope_preview}" },
            TelescopePreviewBorder = { fg = "${telescope_preview}", bg = "${telescope_preview}" },

            -- Virt Column
            VirtColumn = { fg = "${indentline}" },
        },

        caching = false,
        cache_path = vim.fn.expand(vim.fn.stdpath("cache") .. "/onedarkpro_dotfiles"),

        plugins = {
            barbar = false,
            lsp_saga = false,
            marks = false,
            polygot = false,
            startify = false,
            telescope = false,
            trouble = false,
            vim_ultest = false,
            which_key = false,
        },
        styles = {
            tags = "italic",
            methods = "bold",
            functions = "bold",
            keywords = "italic",
            comments = "italic",
            parameters = "italic",
            conditionals = "italic",
            virtual_text = "italic",
        },
        options = {
            cursorline = true,
            -- transparency = true,
            -- highlight_inactive_windows = true,
        },
    },
    config = function(_, opts)
        require("onedarkpro").setup(opts)

        if vim.o.background == "light" then
            vim.cmd([[colorscheme onelight]])
        else
            vim.cmd([[colorscheme onedark]])
        end
    end,
})
