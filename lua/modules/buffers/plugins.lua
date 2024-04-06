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

        vim.api.nvim_create_augroup("stickybuf_augroup", { clear = true })
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
            group = "stickybuf_augroup",
            callback = function()
                vim.defer_fn(function()
                    local bufnrs = vim.api.nvim_list_bufs()
                    local totals = 0
                    local targets = 0
                    local target_bufnr = nil

                    local function _got_target()
                        return totals > 0 and targets > 0 and totals > targets and target_bufnr ~= nil
                    end

                    if type(bufnrs) == "table" then
                        for _, bn in ipairs(bufnrs) do
                            local buf_hidden = vim.api.nvim_get_option_value("bufhidden", { buf = bn })
                            buf_hidden = type(buf_hidden) == "string" and string.len(buf_hidden) > 0
                            local buf_listed = vim.api.nvim_get_option_value("buflisted", { buf = bn })
                            local buf_loaded = vim.api.nvim_buf_is_loaded(bn)
                            local bufname = vim.api.nvim_buf_get_name(bn)
                            if not require("stickybuf").should_auto_pin(bn) then
                                totals = totals + 1
                            end
                            if string.len(bufname) == 0 and not buf_hidden and buf_listed and buf_loaded then
                                targets = targets + 1
                                target_bufnr = bn
                            end
                            if _got_target() then
                                break
                            end
                        end
                    end
                    if _got_target() then
                        vim.api.nvim_buf_delete(target_bufnr, {})
                    end
                end, 1000)
            end,
        })
    end,
})
--
buffer({
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
