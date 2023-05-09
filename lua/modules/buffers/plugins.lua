local buffer = require("core.pack").package
local conf = require("modules.buffers.config")
--  ╭────────────────────────────────────────────────────────────────────╮
--  │ very lazy                                                          │
--  ╰────────────────────────────────────────────────────────────────────╯
buffer({
    "akinsho/bufferline.nvim",
    lazy = true,
    cond = true,
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
    keys = { ";b" },
    config = conf.reach,
    cmd = { "ReachOpen" },
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
    init = function()
        vim.g.bufExplorerDisableDefaultKeyMapping = 1
    end,
    cmd = { "BufExplorer", "ToggleBufExplorer", "BufExplorerHorizontalSplit", "BufExplorerVerticalSplit" },
})

buffer({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

buffer({
    "kazhala/close-buffers.nvim",
    cmd = {
        "BufKillThis",
        "BufKillNameless",
        "BufKillHidden",
        "BufWipe",
    },
    keys = { "_q" },
    config = conf.close_buffers,
})

buffer({
    "stevearc/stickybuf.nvim",
    lazy = true,
    event = "BufEnter",
    config = conf.sticky_buf,
})

buffer({
    "nyngwang/NeoZoom.lua",
    branch = "neo-zoom-original", -- UNCOMMENT THIS, if you prefer the old one
    cmd = { "NeoZoomToggle" },
})

buffer({
    "stevearc/oil.nvim",
    init = function()
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>-", require("oil").open_float, { desc = "Open parent directory" })
    end,
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
            ["_"] = "actions.open_cwd",
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
})

-- Unlist hidden buffers that are git ignored.
buffer({
    "sQVe/bufignore.nvim",
    event = "BufRead",
    config = true,
})

buffer({
    "chrisgrieser/nvim-early-retirement",
    cond = true,
    config = true,
    event = "VeryLazy",
})
buffer({
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    config = true,
})
buffer({
    "mskelton/local-yokel.nvim",
    lazy = true,
    cmd = { "E" },
    config = true,
})
