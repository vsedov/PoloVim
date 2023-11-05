local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    -- "nvim-neorg/neorg",
    "nolbap/neorg",

    ft = { "norg" },
    cmd = { "Neorg" },
    init = function()
        require("modules.notes.norg.commands").setup({})
        require("modules.notes.norg.autocmd").setup({})
    end,
    dependencies = {
        -- "3rd/image.nvim",
        {
            "jarvismkennedy/neorg-roam.nvim",
            branch = "dev",
            dependencies = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim",
            },
        },
        "nvim-neorg/neorg-telescope",
    },
    build = ":Neorg sync-parsers",
    opts = require("modules.notes.neorg").opts,
    config = require("modules.notes.neorg").config,
})

notes({
    "jubnzv/mdeval.nvim",
    lazy = true,
    ft = { "norg" },
    config = conf.mdeval,
})

notes({
    "dhruvasagar/vim-table-mode",
    lazy = true,
    cmd = "TableModeToggle",
    ft = { "markdown" },
    config = conf.table,
})

notes({
    "3rd/image.nvim",
    init = function()
        package.path = package.path .. ";/home/viv/.luarocks/share/lua/5.1/?/init.lua;"
        package.path = package.path .. ";/home/viv/.luarocks/share/lua/5.1/?.lua;"
    end,
    lazy = true,
    opts = {
        backend = "kitty",
        integrations = {
            markdown = {
                enabled = true,
                sizing_strategy = "auto",
                download_remote_images = true,
                clear_in_insert_mode = false,
            },
            neorg = {
                enabled = true,
                download_remote_images = true,
                clear_in_insert_mode = false,
            },
        },
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        kitty_method = "normal",
        kitty_tmux_write_delay = 10,
    },
    config = function(_, opts)
        require("image").setup(opts)
    end,
})
notes({
    "aaron-p1/virt-notes.nvim",
    keys = { "<leader>va", "<leader>vc", "<leader>ve", "<leader>vp", "<leader>vx", "<leader>vdd", "<leader>vdl" },
    config = true,
})
notes({
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    dependencies = {
        {
            "jmbuhr/otter.nvim",
            dependencies = {
                { "neovim/nvim-lspconfig" },
            },
            opts = {
                lsp = {
                    hover = {
                        -- border = require("misc.style").border,
                    },
                },
            },
        },

        -- optional
        {
            "quarto-dev/quarto-vim",
            ft = "quarto",
            dependencies = { "vim-pandoc/vim-pandoc-syntax" },
            -- note: needs additional syntax highlighting enabled for markdown
            --       in `nvim-treesitter`
            config = function()
                -- conceal can be tricky because both
                -- the treesitter highlighting and the
                -- regex vim syntax files can define conceals

                -- see `:h conceallevel`
                vim.opt.conceallevel = 1

                -- disable conceal in markdown/quarto
                vim.g["pandoc#syntax#conceal#use"] = false

                -- embeds are already handled by treesitter injectons
                vim.g["pandoc#syntax#codeblocks#embeds#use"] = false
                vim.g["pandoc#syntax#conceal#blacklist"] = { "codeblock_delim", "codeblock_start" }

                -- but allow some types of conceal in math regions:
                -- see `:h g:tex_conceal`
                vim.g["tex_conceal"] = "gm"
            end,
        },
    },
    opts = {
        lspFeatures = {
            languages = { "r", "python", "julia", "bash", "lua", "html" },
        },
    },
})
notes({
    "ellisonleao/glow.nvim",
    opts = {
        install_path = "/home/viv/.local/share/zinit/plugins/charmbracelet---glow/",
        style = "dark",
    },

    cmd = "Glow",
})
