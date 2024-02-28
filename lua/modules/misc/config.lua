local config = {}

function config.hexokinase()
    vim.g.Hexokinase_optInPatterns = {
        "full_hex",
        "triple_hex",
        "rgb",
        "rgba",
        "hsl",
        "hsla",
        "colour_names",
    }
    vim.g.Hexokinase_highlighters = {
        "virtual",
        "sign_column", -- 'background',
        "backgroundfull",
        -- 'foreground',
        -- 'foregroundfull'
    }
end

function config.diaglist()
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
end

function config.carbon()
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
end

return config
