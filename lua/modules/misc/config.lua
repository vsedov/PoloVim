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

function config.surround()
    require("nvim-surround").setup({
        keymaps = {
            insert_line = "<C-#>", -- I am not sure how i feel about this
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "gs",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        },
    })
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

function config.guess_indent()
    require("guess-indent").setup({
        auto_cmd = true, -- Set to false to disable automatic execution
        filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
            "netrw",
            "neo-tree",
            "tutor",
        },
        buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
            "help",
            "nofile",
            "terminal",
            "prompt",
        },
    })
end



function config.NeoWell()
    require("neo-well").setup({
        height = 10,
    })
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

function config.attempt()
    local attempt = require("attempt")
    attempt.setup()

    require("telescope").load_extension("attempt")

    function map(mode, l, r, opts)
        opts = opts or {}
        opts = vim.tbl_extend("force", { silent = true }, opts)
        vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>an", attempt.new_select) -- new attempt, selecting extension
    map("n", "<leader>ai", attempt.new_input_ext) -- new attempt, inputing extension
    map("n", "<leader>ar", attempt.run) -- run attempt
    map("n", "<leader>ad", attempt.delete_buf) -- delete attempt from current buffer
    map("n", "<leader>ac", attempt.rename_buf) -- rename attempt from current buffer
    map("n", "<leader>aL", "Telescope attempt") -- search through attempts
    map("n", "<leader>al", attempt.open_select) -- use ui.select instead of telescope
end

function config.noneck()
    NoNeckPain = {}
    NoNeckPain.bufferOptions = {
        -- When `false`, the buffer won't be created.
        enabled = true,
        -- Hexadecimal color code to override the current background color of the buffer. (e.g. #24273A)
        -- popular theme are supported by their name:
        -- - catppuccin-frappe
        -- - catppuccin-frappe-dark
        -- - catppuccin-latte
        -- - catppuccin-latte-dark
        -- - catppuccin-macchiato
        -- - catppuccin-macchiato-dark
        -- - catppuccin-mocha
        -- - catppuccin-mocha-dark
        -- - tokyonight-day
        -- - tokyonight-moon
        -- - tokyonight-night
        -- - tokyonight-storm
        -- - rose-pine
        -- - rose-pine-moon
        -- - rose-pine-dawn
        backgroundColor = nil,
        -- buffer-scoped options: any `vim.bo` options is accepted here.
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
            cursorline = false,
            cursorcolumn = false,
            number = false,
            relativenumber = false,
            foldenable = false,
            list = false,
        },
    }

    require("no-neck-pain").setup({
        -- The width of the focused buffer when enabling NNP.
        -- If the available window size is less than `width`, the buffer will take the whole screen.
        width = 100,
        -- Prints useful logs about what event are triggered, and reasons actions are executed.
        debug = false,
        -- Disables NNP if the last valid buffer in the list has been closed.
        disableOnLastBuffer = false,
        -- When `true`, disabling NNP kills every split/vsplit buffers except the main NNP buffer.
        killAllBuffersOnDisable = false,
        --- Options related to the side buffers. See |NoNeckPain.bufferOptions|.
        buffers = {
            -- When `true`, the side buffers will be named `no-neck-pain-left` and `no-neck-pain-right` respectively.
            setNames = false,
            -- Common options are set to both buffers, for option scoped to the `left` and/or `right` buffer, see `buffers.left` and `buffers.right`.
            common = NoNeckPain.bufferOptions,
            --- Options applied to the `left` buffer, the options defined here overrides the `common` ones.
            --- When `nil`, the buffer won't be created.
            left = NoNeckPain.bufferOptions,
            --- Options applied to the `left` buffer, the options defined here overrides the `common` ones.
            --- When `nil`, the buffer won't be created.
            right = NoNeckPain.bufferOptions,
        },
        -- lists supported integrations that might clash with `no-neck-pain.nvim`'s behavior
        integrations = {
            -- https://github.com/nvim-tree/nvim-tree.lua
            nvimTree = {
                -- the position of the tree, can be `left` or `right``
                position = "left",
            },
        },
    })
    vim.keymap.set("n", "zz", "<cmd>NoNeckPain<cr>", {})
end

return config
