return {
    {
        "diaglist.nvim",
        keys = { "<leader>qw", "<leader>qf" },
        cmd = { "Qfa", "Qfb" },
        after = function()
            require("diaglist").init({
                debug = false,
                debounce_ms = 150,
            })
            local add_cmd = vim.api.nvim_create_user_command

            vim.api.nvim_create_user_command("Qfa", function()
                require("diaglist").open_all_diagnostics()
            end, { force = true })

            vim.api.nvim_create_user_command("Qfb", function()
                vim.diagnostic.setqflist()
                require("diaglist").open_buffer_diagnostics()
            end, { force = true })

            vim.keymap.set(
                "n",
                "<leader>qw",
                "<cmd>lua require('diaglist').open_all_diagnostics()<cr>",
                { noremap = true, silent = true }
            )
            vim.keymap.set("n", "<leader>qf", function()
                vim.diagnostic.setqflist()

                require("diaglist").open_buffer_diagnostics()
            end, { noremap = true, silent = true })
        end,
    },
    {
        "vim-dirtytalk",
        event = "BufWrite",
        cmd = { "DirtytalkUpdate" },
        after = function()
            vim.defer_fn(function()
                vim.cmd("silent!  DirtytalkUpdate")
                vim.opt.spelllang:append("programming")
            end, 1000)
        end,
    },
    {
        "carbon-now.nvim",
        cmd = "CarbonNow",
        after = function()
            require("carbon-now").setup({
                options = {
                    theme = "dracula pro",
                    window_theme = "none",
                    font_family = "Hack",
                    font_size = "18px",
                    bg = "gray",
                    line_numbers = true,
                    line_height = "133%",
                    drop_shadow = false,
                    drop_shadow_offset_y = "20px",
                    drop_shadow_blur = "68px",
                    width = "680",
                    watermark = false,
                },
            })
        end,
    },
    {
        "neominimap.nvim",
        event = "DeferredUIEnter",
        keys = {
            { "<leader>nt", "<cmd>Neominimap toggle<cr>", desc = "Toggle minimap" },
            { "<leader>no", "<cmd>Neominimap on<cr>", desc = "Enable minimap" },
            { "<leader>nc", "<cmd>Neominimap off<cr>", desc = "Disable minimap" },
            { "<leader>nf", "<cmd>Neominimap focus<cr>", desc = "Focus on minimap" },
            { "<leader>nu", "<cmd>Neominimap unfocus<cr>", desc = "Unfocus minimap" },
            { "<leader>ns", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle focus on minimap" },
            { "<leader>nwt", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
            { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
            { "<leader>nwo", "<cmd>Neominimap winOn<cr>", desc = "Enable minimap for current window" },
            { "<leader>nwc", "<cmd>Neominimap winOff<cr>", desc = "Disable minimap for current window" },
            { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
            { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
            { "<leader>nbo", "<cmd>Neominimap bufOn<cr>", desc = "Enable minimap for current buffer" },
            { "<leader>nbc", "<cmd>Neominimap bufOff<cr>", desc = "Disable minimap for current buffer" },
        },
        beforeAll = function()
            vim.opt.wrap = false -- Recommended
            vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
            ---@type Neominimap.UserConfig
            vim.g.neominimap = {
                auto_enable = true,
            }
        end,
    },
}
