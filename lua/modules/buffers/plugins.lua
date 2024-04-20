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
        require("scope").setup({
            hooks = {
                pre_tab_leave = function()
                    vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
                    -- [other statements]
                end,

                post_tab_enter = function()
                    vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
                    -- [other statements]
                end,

                -- [other hooks]
            },

            -- [other options]
        })
    end,
})
buffer({
    "backdround/tabscope.nvim",
    cond = lambda.config.buffer.use_tabscope,
    lazy = true,
    event = "VeryLazy",
    config = true,
    keys = {
        {
            ";q",
            function()
                require("tabscope").remove_tab_buffer()
            end,
            desc = "close tab",
        },
    },
})
--
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

-- --  ──────────────────────────────────────────────────────────────────────
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
        threshold = 60, -- hbac will start closing unedited buffers once that number is reached
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
