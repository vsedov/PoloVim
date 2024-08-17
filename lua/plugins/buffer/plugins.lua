local buffer = require("core.pack").package
local conf = require("modules.buffers.config")
-- --  ╭────────────────────────────────────────────────────────────────────╮
-- --  │ very lazy                                                          │
-- --  ╰────────────────────────────────────────────────────────────────────╯
-- buffer({
--     "akinsho/bufferline.nvim",
--     lazy = true,
--     cond = lambda.config.buffer.use_bufferline,
--     event = "BufEnter",
--     config = conf.nvim_bufferline,
--     dependencies = { { "tabscope.nvim" } },
-- })
buffer({
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function()
        vim.g.barbar_auto_setup = true
    end,
    opts = {
        animation = false,
    },
})
buffer({
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    cond = not lambda.config.buffer.use_tabscope,
    config = function()
    end,
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
--
buffer({
    "jlanzarotta/bufexplorer",
    lazy = true,
    init = function()
        vim.g.bufExplorerDisableDefaultKeyMapping = 1
    end,
    cmd = { "BufExplorer", "ToggleBufExplorer", "BufExplorerHorizontalSplit", "BufExplorerVerticalSplit" },
})
--
buffer({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

buffer({
    "famiu/bufdelete.nvim",
    keys = { { "_q", "<Cmd>Bdelete<CR>", desc = "buffer delete" } },
})
--
buffer({
    "stevearc/stickybuf.nvim",
    cond = lambda.config.buffer.use_sticky_buf,
    event = "VeryLazy",
    config = function()
        require("stickybuf").setup()
    end,
})
--
buffer({
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        if vim.fn.argc() == 1 then
            local arg = vim.fn.argv(0)
            local stat = vim.loop.fs_stat(arg)
            if stat and stat.type == "directory" then
                require("lazy").load({ plugins = { "oil.nvim" } })
            end
        end
        if not require("lazy.core.config").plugins["oil.nvim"]._.loaded then
            vim.api.nvim_create_autocmd("BufNew", {
                callback = function(args)
                    if vim.fn.isdirectory(args.file) == 1 then
                        require("lazy").load({ plugins = { "oil.nvim" } })
                        -- Once oil is loaded, we can delete this autocmd
                        return true
                    end
                end,
            })
        end
    end,
    opts = {
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        keymaps = {
            ["w"] = "actions.tcd",
            ["~"] = "<cmd>edit $HOME<CR>",
            ["<leader>t"] = "actions.open_terminal",
            ["gd"] = {
                desc = "Toggle detail view",
                callback = function()
                    local oil = require("oil")
                    local config = require("oil.config")
                    if #config.columns == 1 then
                        oil.set_columns({ "icon", "permissions", "size", "mtime" })
                    else
                        oil.set_columns({ "icon" })
                    end
                end,
            },
        },
        is_always_hidden = function(name, bufnr)
            return name == ".."
        end,
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)
        vim.keymap.set("n", "<leader>-", require("oil").open, { desc = "Open parent directory" })
        vim.keymap.set("n", "-", require("oil").open_float, { desc = "Open parent directory" })
    end,
    keys = {
        "-",
        "<leader>-",
    },
    cmd = "Oil",
})
--
buffer({
    "mskelton/local-yokel.nvim",
    lazy = true,
    cmd = { "E" },
    config = true,
})
