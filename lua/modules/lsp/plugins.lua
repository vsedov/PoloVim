local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

lsp({
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    init = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
})

lsp({
    "williamboman/mason.nvim",

    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
    config = conf.mason_setup,
})

lsp({
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "poljar/typos.nvim" },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        -- require("typos").setup()
    end,
})

lsp({
    "jayp0521/mason-null-ls.nvim",
    lazy = true,
    dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
        require("mason-null-ls").setup({
            automatic_installation = false,
        })
    end,
})

lsp({ "ii14/lsp-command", lazy = true, event = "BufEnter" })
lsp({
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    dependencies = "nvim-lspconfig",
    config = conf.clangd,
})

lsp({ "folke/neodev.nvim", ft = "lua", lazy = true, dependencies = "neovim/nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", modules = "hover", config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cmd = { "Lspsaga", "LSoutlineToggle" },
    lazy = true,
    config = conf.saga,
    dependencies = "neovim/nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    ft = { "python" },
    config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    keys = {
        "\\;",
    },
    config = function()
        require("actions-preview").setup({
            -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
            diff = {
                ctxlen = 3,
            },
            backend = { "telescope", "nui" },
            -- options for telescope.nvim: https://github.com/nvim-telescope/telescope.nvim#themes
            telescope = require("telescope.themes").get_dropdown(),
        })

        vim.keymap.set({ "v", "n" }, "\\;", require("actions-preview").code_actions)
    end,
})

lsp({
    "joechrisellis/lsp-format-modifications.nvim",
    lazy = true,
})

lsp({ "smjonas/inc-rename.nvim", event = "BufEnter", config = conf.rename })

-- lsp({ "SmiteshP/nvim-navic", event = "BufEnter", after = "nvim-lspconfig", config = conf.navic })

lsp({ "cseickel/diagnostic-window.nvim", cmd = "DiagWindowShow", dependencies = { "MunifTanjim/nui.nvim" } })
lsp({
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    config = conf.vista,
})

lsp({
    "barreiroleo/ltex-extra.nvim",
    lazy = true,
    ft = { "latex", "tex" },
    module = "ltex_extra",
})

lsp({
    "santigo-zero/right-corner-diagnostics.nvim",
    cmd = { "RCL" },
    lazy = not lambda.config.lsp.use_rcd,
    config = conf.rcd,
})

lsp({
    "rmagatti/goto-preview",
    lazy = true,
    modules = "goto-preview",
    config = conf.goto_preview,
})

lsp({
    "dnlhc/glance.nvim",
    cmd = "Glance",
    config = function()
        -- Lua configuration
        local glance = require("glance")
        local actions = glance.actions

        glance.setup({
            height = 18, -- Height of the window
            border = {
                enable = true, -- Show window borders. Only horizontal borders allowed
                top_char = "-",
                bottom_char = "-",
            },
            list = {
                position = "right", -- Position of the list window 'left'|'right'
                width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
            },
            theme = { -- This feature might not work properly in nvim-0.7.2
                enable = true, -- Will generate colors for the plugin based on your current colorscheme
                mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
            },
            mappings = {
                list = {
                    ["j"] = actions.next, -- Bring the cursor to the next item in the list
                    ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
                    ["<Down>"] = actions.next,
                    ["<Up>"] = actions.previous,
                    ["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
                    ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
                    ["<C-u>"] = actions.preview_scroll_win(5),
                    ["<C-d>"] = actions.preview_scroll_win(-5),
                    ["v"] = actions.jump_vsplit,
                    ["s"] = actions.jump_split,
                    ["t"] = actions.jump_tab,
                    ["<CR>"] = actions.jump,
                    ["o"] = actions.jump,
                    ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
                    ["q"] = actions.close,
                    ["Q"] = actions.close,
                    ["<Esc>"] = actions.close,
                },
                preview = {
                    ["Q"] = actions.close,
                    ["<Tab>"] = actions.next_location,
                    ["<S-Tab>"] = actions.previous_location,
                    ["<leader>l"] = actions.enter_win("list"), -- Focus list window
                },
            },
            folds = {
                fold_closed = "",
                fold_open = "",
                folded = true, -- Automatically fold list on startup
            },
            indent_lines = {
                enable = true,
                icon = "│",
            },
            winbar = {
                enable = true, -- Available strating from nvim-0.8+
            },
        })
    end,
})
