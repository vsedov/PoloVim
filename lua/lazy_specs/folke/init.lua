return {
    -- {
    --     "noice.nvim",
    --     event = "DeferredUIEnter",
    --     after = function()
    --         require("lazy_specs.folke.noice").noice_setup()
    --     end,
    -- },
    {
        "which-key.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("lazy_specs.folke.config").which_key()
        end,
    },
    {
        "edgy.nvim",
        event = "BufWinEnter",
        keys = {
            {
                "<Leader>E",
                function()
                    require("edgy").toggle()
                end,
                "General: [F]orce Close Edgy",
            },
        },
        after = function()
            require("edgy").setup({
                bottom = {

                    -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
                    { ft = "toggleterm", size = { height = 0.4 } },
                    {
                        ft = "lazyterm",
                        title = "LazyTerm",
                        size = { height = 0.4 },
                        filter = function(buf)
                            return not vim.b[buf].lazyterm_cmd
                        end,
                    },
                    { ft = "qf", title = "QuickFix" },
                    { ft = "help", size = { height = 20 } },
                    { ft = "spectre_panel", size = { height = 0.4 } },
                    {
                        ft = "terminal",
                        title = "Terminal",
                        size = { height = vim.o.columns > 150 and vim.o.lines >= 40 and 20 or 0.2 },
                        filter = function(buf)
                            return not vim.b[buf].lazyterm_cmd
                        end,
                    },
                    { ft = "dap-repl", title = "Debug REPL" },
                    { ft = "dapui_console", title = "Debug Console" },
                    {
                        ft = "Trouble",
                        title = " Trouble",
                        open = function()
                            require("trouble").toggle({ mode = "quickfix" })
                        end,
                    },
                    -- {
                    --     ft = "OverseerPanelTask",
                    --     title = " Task",
                    --     open = "OverseerQuickAction open",
                    -- },
                    {
                        ft = "NoiceHistory",
                        title = " Log",
                        open = function()
                            toggle_noice()
                        end,
                    },
                    {
                        ft = "neotest-output-panel",
                        title = " Test Output",
                        open = function()
                            vim.cmd.vsplit()
                            require("neotest").output_panel.toggle()
                        end,
                    },
                    {
                        ft = "DiffviewFileHistory",
                        title = " Diffs",
                    },
                },
                left = {
                    {
                        ft = "neo-tree",
                        title = "NeoTree",
                    },
                    { ft = "undotree", title = "Undo Tree" },
                    { ft = "dapui_scopes", title = "Scopes" },
                    { ft = "dapui_breakpoints", title = "Breakpoints" },
                    { ft = "dapui_stacks", title = "Stacks" },
                    { ft = "dapui_watches", title = "Watches" },

                    {
                        ft = "diff",
                        title = " Diffs",
                    },

                    {
                        ft = "DiffviewFileHistory",
                        title = " Diffs",
                    },
                    {
                        ft = "DiffviewFiles",
                        title = " Diffs",
                    },

                    {
                        ft = "OverseerList",
                        title = "  Tasks",
                        open = "OverseerOpen",
                        size = {
                            width = 0.2,
                        },
                    },
                    {
                        ft = "nvim-docs-view",
                        title = "Live Docs",
                    },

                    {
                        ft = "neotest-summary",
                        title = "  Tests",
                        open = function()
                            require("neotest").summary.toggle()
                        end,
                    },
                },
                right = {
                    { ft = "codecompanion", title = "Code Companion Chat", size = { width = 0.45 } },
                    {
                        title = "CopilotChat.nvim", -- Title of the window
                        ft = "copilot-chat", -- This is custom file type from CopilotChat.nvim
                        size = { width = 0.4 }, -- Width of the window
                    },
                    "sagaoutline",
                    "neotest-output-panel",
                    "neotest-summary",

                    {
                        ft = "vista_kind",
                        title = "Vista",
                        open = "Vista",
                        size = { height = 0.5 },
                    },
                },

                options = {
                    left = { size = 40 },
                    bottom = { size = 20 },
                    right = { size = 30 },
                    top = { size = 10 },
                },
                -- edgebar animations
                -- edgebar animations
                animate = {
                    enabled = lambda.config.folke.edge.use_animate,

                    fps = 240, -- frames per second
                    cps = 200, -- cells per second
                    on_begin = function()
                        vim.g.minianimate_disable = true
                    end,
                    on_end = function()
                        vim.g.minianimate_disable = false
                    end,
                    -- Spinner for pinned views that are loading.
                    -- if you have noice.nvim installed, you can use any spinner from it, like:
                    spinner = function()
                        if package.loaded["noice"] then
                            return require("noice.util.spinners").spinners.circleFull()
                        end
                    end,
                },
                keys = {
                    -- close window
                    ["W"] = function(win)
                        local Hydra = require("hydra")

                        local hint = [[
^^ _l_: increase width ^^
^^ _h_: decrease width ^^

^^ _L_: next open window ^^
^^ _H_: prev open window ^^

^^ _j_: next loaded window ^^
^^ _k_: prev loaded window ^^

^^ _J_: increase height ^^
^^ _K_: decrease height ^^
^^ _=_: reset all custom sizing ^^

^^ _<c-q>_: hide  ^^
^^ _q_: quit  ^^
^^ _Q_: close ^^

^^ _<esc>_: quit Hydra ^^
]]
                        local edgey_hydra = Hydra({
                            name = "Edgy",
                            mode = "n",
                            hint = hint,
                            config = {
                                color = "amaranth",
                                invoke_on_body = true,
                                hint = {
                                    position = "bottom-right",
                                },
                            },
                            heads = {
                                {
                                    "<c-q>",
                                    function()
                                        win:hide()
                                    end,
                                    { exit = true },
                                },

                                {
                                    "Q",
                                    function()
                                        win.view.edgebar:close()
                                    end,
                                    { exit = true },
                                },
                                {
                                    "<esc>",
                                    nil,
                                    { exit = true, desc = "quit" },
                                },
                                {
                                    "q",
                                    function()
                                        win:close()
                                    end,
                                    { exit = true },
                                },

                                -- next open window
                                {
                                    "L",
                                    function()
                                        win:next({ visible = true, focus = true })
                                    end,
                                },
                                -- previous open window
                                {
                                    "H",
                                    function()
                                        win:prev({ visible = true, focus = true })
                                    end,
                                },
                                -- next loaded window
                                {
                                    "j",
                                    function()
                                        win:next({ pinned = false, focus = true })
                                    end,
                                },
                                -- prev loaded window
                                {
                                    "k",
                                    function()
                                        win:prev({ pinned = false, focus = true })
                                    end,
                                },
                                -- increase width
                                {
                                    "l",
                                    function()
                                        win:resize("width", 2)
                                    end,
                                },
                                -- decrease width
                                {
                                    "h",
                                    function()
                                        win:resize("width", -2)
                                    end,
                                },
                                -- increase height
                                {
                                    "J",
                                    function()
                                        win:resize("height", 2)
                                    end,
                                },
                                -- decrease height
                                {
                                    "K",
                                    function()
                                        win:resize("height", -2)
                                    end,
                                },
                                -- reset all custom sizing
                                {
                                    "=",
                                    function()
                                        win.view.edgebar:equalize()
                                    end,
                                    { exit = true, desc = "equalize" },
                                },
                            },
                        })
                        edgey_hydra:activate()
                    end,

                    -- -- hide window
                },
                icons = {
                    closed = " ",
                    open = " ",
                },
                -- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
                -- Not needed on a nightly build >= June 5, 2023.
                fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
            })
        end,
    },
}
