local config = {}
packer_plugins = packer_plugins or {} -- supress warning

function config.catppuccin()
    local catppuccin = require("catppuccin")
    catppuccin.setup({
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        transparent_background = false,
        term_colors = true,
        compile = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/catppuccin",
            suffix = "_compiled",
        },
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = { "italic" },
            strings = {},
            variables = {},
            numbers = {},
            booleans = { "italic" },
            properties = {},
            types = {},
            operators = {},
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
            },
            coc_nvim = false,
            lsp_trouble = true,
            cmp = true,
            lsp_saga = true,
            gitgutter = true,
            gitsigns = true,
            telescope = true,
            nvimtree = {
                enabled = false,
                show_root = false,
                transparent_panel = false,
            },
            neotree = {
                enabled = true,
                show_root = true,
                transparent_panel = true,
            },
            which_key = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = true,
            },
            dashboard = true,
            neogit = true,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = true,
            markdown = true,
            lightspeed = true,
            ts_rainbow = false,
            hop = true,
            notify = true,
            telekasten = true,
            symbols_outline = true,
            mini = false,
        },
    })
    vim.cmd([[colorscheme catppuccin]])
end

function config.kanagawa()
    require("kanagawa").setup({
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        globalStatus = true,
        typeStyle = {},
        variablebuiltinStyle = { italic = true },
        specialReturn = true, -- special highlight for the return keyword
        specialException = true, -- special highlight for exception handling keywords
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC` -- Kinda messes with things
        colors = {},
        overrides = {
            Pmenu = { fg = "NONE", bg = "NONE" },
            normalfloat = { bg = "NONE" },
        },
    })
    vim.cmd([[colorscheme kanagawa]])
    -- vim.cmd.colorscheme("kanagawa")
end

function config.horizon()
    vim.cmd([[colorscheme  horizon]])
end

function config.dogrun()
    vim.cmd([[colorscheme dogrun]])
end

function config.rose()
    require("rose-pine").setup({
        --- @usage 'main' | 'moon'
        dark_variant = lambda.config.colourscheme.rose,
        bold_vert_split = true,
        dim_nc_background = true,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,

        --- @usage string hex value or named color from rosepinetheme.com/palette
        groups = {
            background = "base",
            panel = "surface",
            border = "highlight_med",
            comment = "muted",
            link = "iris",
            punctuation = "subtle",

            error = "love",
            hint = "iris",
            info = "foam",
            warn = "gold",

            headings = {
                h1 = "iris",
                h2 = "foam",
                h3 = "rose",
                h4 = "gold",
                h5 = "pine",
                h6 = "foam",
            },
            -- or set all headings at once
            -- headings = 'subtle'
        },

        -- Change specific vim highlight groups
        highlight_groups = {
            ColorColumn = { bg = "rose" },
        },
    })
    -- vim.cmd.colorscheme("rose-pine")

    vim.cmd([[colorscheme rose-pine]])
end

function config.doom()
    -- Add color to cursor
    vim.g.doom_one_cursor_coloring = true
    -- Set :terminal colors
    vim.g.doom_one_terminal_colors = true
    -- Enable italic comments
    vim.g.doom_one_italic_comments = true
    -- Enable TS support
    vim.g.doom_one_enable_treesitter = true
    -- Color whole diagnostic text or only underline
    vim.g.doom_one_diagnostics_text_color = true
    -- Enable transparent background
    vim.g.doom_one_transparent_background = false

    -- Pumblend transparency
    vim.g.doom_one_pumblend_enable = true
    vim.g.doom_one_pumblend_transparency = 20

    -- Plugins integration
    vim.g.doom_one_plugin_neorg = true
    vim.g.doom_one_plugin_barbar = true
    vim.g.doom_one_plugin_telescope = true
    vim.g.doom_one_plugin_neogit = true
    vim.g.doom_one_plugin_nvim_tree = false
    vim.g.doom_one_plugin_dashboard = true
    vim.g.doom_one_plugin_startify = false
    vim.g.doom_one_plugin_whichkey = true
    vim.g.doom_one_plugin_indent_blankline = true
    vim.g.doom_one_plugin_vim_illuminate = true
    vim.g.doom_one_plugin_lspsaga = true

    vim.cmd([[colorscheme doom-one]])
end
function config.poimandres()
    require("poimandres").setup({

        bold_vert_split = true, -- use bold vertical separators
        dim_nc_background = true, -- dim 'non-current' window backgrounds
        disable_background = false, -- disable background
        disable_float_background = false, -- disable background for floats
        disable_italics = false, -- disable italics
    })
    vim.cmd("colorscheme poimandres")
end
return config
