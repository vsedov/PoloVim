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
}
