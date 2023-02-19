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
    dependencies = { { "stevearc/three.nvim", config = conf.three, lazy = true }, { "scope.nvim" } },
})
buffer({
    "tiagovla/scope.nvim",
    lazy = true,
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
    cmd = { "PinBuffer", "PinBuftype", "PinBuftype", "UnpinBuffer" },
    config = conf.sticky_buf,
})

buffer({
    "nyngwang/NeoZoom.lua",
    branch = "neo-zoom-original", -- UNCOMMENT THIS, if you prefer the old one
    cmd = { "NeoZoomToggle" },
})
buffer({
    "nyngwang/NeoNoName.lua",
    cmd = { "NeoNoName" },
})

buffer({
    "stevearc/oil.nvim",
    event = "VeryLazy",
    init = function()
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
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
        skip_confirm_for_simple_edits = false,
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
            show_hidden = false,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
            -- Padding around the floating window
            padding = 2,
            max_width = 0,
            max_height = 0,
            border = "rounded",
            win_options = {
                winblend = 10,
            },
        },
    },
})
