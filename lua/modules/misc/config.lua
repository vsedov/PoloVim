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
        ";qw",
        "<cmd>lua require('diaglist').open_all_diagnostics()<cr>",
        { noremap = true, silent = true }
    )
    vim.keymap.set("n", ";qq", function()
        vim.diagnostic.setqflist()

        require("diaglist").open_buffer_diagnostics()
    end, { noremap = true, silent = true })
end

function config.ns()
    local nstextobject = require("ns-textobject")
    nstextobject.setup()

    vim.keymap.set({ "x", "o" }, "aq", function()
        nstextobject.create_textobj("q", "a")
    end, { desc = "Around the quote" })

    vim.keymap.set({ "x", "o" }, "iq", function()
        nstextobject.create_textobj("q", "i")
    end, { desc = "Inside the quote" })

    nstextobject.map_textobj("q", "quotes")
end

function config.autosave()
    require("save").setup()
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

function config.noneck()
    NoNeckPain = {}
    NoNeckPain.bufferOptions = {
        enabled = true,
        backgroundColor = nil,
        bo = {
            filetype = "no-neck-pain",
            buftype = "nofile",
            bufhidden = "hide",
            modifiable = false,
            buflisted = false,
            swapfile = false,
        },
        -- window-scoped options: any `vim.wo` options is accepted here.
        wo = {
            cursorline = true,
            cursorcolumn = true,
            number = true,
            relativenumber = true,
            foldenable = true,
            list = true,
        },
    }

    require("no-neck-pain").setup({
        width = 130,
        debug = false,
        disableOnLastBuffer = false,
        killAllBuffersOnDisable = true,
        buffers = {
            setNames = true,
            common = NoNeckPain.bufferOptions,
        },

        autocmds = {
            enableOnVimEnter = false,
            enableOnTabEnter = false,
        },
    })

    vim.keymap.set("n", "zz", "<cmd>NoNeckPain<cr>", {})
end

return config
