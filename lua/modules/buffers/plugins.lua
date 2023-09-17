local buffer = require("core.pack").package
local conf = require("modules.buffers.config")
--  ╭────────────────────────────────────────────────────────────────────╮
--  │ very lazy                                                          │
--  ╰────────────────────────────────────────────────────────────────────╯
buffer({
    "akinsho/bufferline.nvim",
    lazy = true,
    cond = lambda.config.buffer.use_bufferline,
    event = "VeryLazy",
    config = conf.nvim_bufferline,
    dependencies = { { "stevearc/three.nvim", config = conf.three, lazy = true }, { "tabscope.nvim" } },
})

buffer({

    "backdround/tabscope.nvim",
    lazy = true,
    event = "VeryLazy",
    config = true,
})

buffer({
    "toppair/reach.nvim",
    lazy = true,
    cmd = { "ReachOpen" },
    config = conf.reach,
})
buffer({
    "ghillb/cybu.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = true,
    lazy = true,
    cmd = {
        "CybuNext",
        "CybuPrev",
        "CybuLastusedPrev",
        "CybuLastusedNext",
    },
})

buffer({
    "jlanzarotta/bufexplorer",
    lazy = true,
    init = function()
        vim.g.bufExplorerDisableDefaultKeyMapping = 1
    end,
    cmd = { "BufExplorer", "ToggleBufExplorer", "BufExplorerHorizontalSplit", "BufExplorerVerticalSplit" },
})

buffer({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

buffer({ "famiu/bufdelete.nvim", keys = { { "_q", "<Cmd>Bdelete<CR>", desc = "buffer delete" } } })

buffer({
    "stevearc/stickybuf.nvim",
    cond = lambda.config.buffer.use_sticky_buf,
    lazy = true,
    event = "VeryLazy",
    config = conf.sticky_buf,
})

buffer({
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        columns = {
            "icon",
            -- "permissions",
            "mtime",
        },
        buf_options = {
            buflisted = true,
        },
        -- Window-local options to use for oil buffers
        win_options = {
            wrap = true,
            signcolumn = "no",
            cursorcolumn = false,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "n",
        },
        -- Restore window options to previous values when leaving an oil buffer
        restore_win_options = true,
        skip_confirm_for_simple_edits = true,
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-s>"] = "actions.select_vsplit",
            ["<C-h>"] = "actions.select_split",
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["w"] = "actions.open_cwd",
            ["c"] = "actions.cd",
            ["C"] = "actions.tcd",
            ["g."] = "actions.toggle_hidden",
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = false,
        view_options = {
            show_hidden = true,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
            -- Padding around the floating window
            padding = 2,
            max_width = 0,
            max_height = 0,
            border = lambda.style.border.type_0,
            win_options = {
                winblend = 10,
            },
        },
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)
        vim.keymap.set("n", "__", function()
            oil.open(vim.fn.getcwd())
        end, { desc = "Open cwd" })
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>-", require("oil").open_float, { desc = "Open parent directory" })
    end,
})

-- Unlist hidden buffers that are git ignored.
buffer({
    "sQVe/bufignore.nvim",
    cond = lambda.config.buffer.use_bufignore,
    event = "BufRead",
    config = true,
})

buffer({
    "chrisgrieser/nvim-early-retirement",
    cond = lambda.config.buffer.use_early_retirement,
    opts = {
        retirementAgeMins = 10,
    },
    event = "VeryLazy",
})
buffer({
    "axkirillov/hbac.nvim",
    cond = lambda.config.buffer.use_hbac,
    event = "VeryLazy",
    opts = {
        autoclose = true, -- set autoclose to false if you want to close manually
        threshold = 10, -- hbac will start closing unedited buffers once that number is reached
        close_command = function(bufnr)
            vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
        telescope = {
            mappings = {
                n = {
                    close_unpinned = "<c-c>",
                    delete_buffer = "<c-x>",
                    pin_all = "<c-a>",
                    unpin_all = "<c-u>",
                    toggle_selections = "<c-y>",
                },
            },
            pin_icons = {
                pinned = { "󰐃 ", hl = "DiagnosticOk" },
                unpinned = { "󰤱 ", hl = "DiagnosticError" },
            },
        },
    },
})

buffer({
    "mskelton/local-yokel.nvim",
    lazy = true,
    cmd = { "E" },
    config = true,
})

buffer({
    "zakissimo/hook.nvim",
    lazy = true,
    keys = {
        "<c-b>1",
        "<c-b>2",
        "<c-b>3",
        "<c-b>4",
        "<c-b>5",
        "<c-b>6",
        "<c-b>7",
        "<c-b>8",
        "<c-b>9",
    },
    config = function()
        require("hook").setup({
            prefix = "", -- default is ">"
        })
        for i = 1, 9 do
            vim.api.nvim_set_keymap(
                "n",
                "<c-b>" .. i,
                "<cmd>lua require('hook').pull(" .. i .. ")<CR>",
                { noremap = true, silent = true }
            )
        end
    end,
})
