local config = {}
function config.config_yanky()
    local mapping = require("yanky.telescope.mapping")
    require("yanky").setup({
        ring = {
            history_length = 100000,
            storage = "sqlite",
            sync_with_numbered_registers = true,
            cancel_event = "update",
        },
        picker = {
            telescope = {
                mappings = {
                    default = mapping.put("p"),
                    i = {
                        ["<c-p>"] = mapping.put("p"),
                        ["<c-k>"] = mapping.put("P"),
                        ["<c-x>"] = mapping.delete(),
                    },
                    n = {
                        p = mapping.put("p"),
                        P = mapping.put("P"),
                        d = mapping.delete(),
                    },
                },
            },
        },
        system_clipboard = {
            sync_with_ring = true,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 200,
        },
        preserve_cursor_position = {
            enabled = true,
        },
    })
    local default_keymaps = {
        { "n", "y", "<Plug>(YankyYank)" },
        { "x", "y", "<Plug>(YankyYank)" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], {})
    end

    require("telescope").load_extension("yank_history")
    --
    vim.keymap.set("n", "<leader>yu", "<cmd>Telescope yank_history<cr>", { desc = "Yank History" })
    vim.keymap.set(
        "n",
        "<leader>yy",
        "<cmd>:lua require'utils.telescope'.neoclip()<CR>",
        { desc = "NeoClip", silent = true }
    )
end

function config.smart_yank()
    require("smartyank").setup({
        highlight = {
            enabled = true, -- highlight yanked text
            higroup = "IncSearch", -- highlight group of yanked text
            timeout = 200, -- timeout for clearing the highlight
        },
        osc52 = {
            enabled = true,
            ssh_only = false, -- false to OSC52 yank also in local sessions
            silent = false, -- true to disable the "n chars copied" echo
            echo_hl = "Directory", -- highlight group of the OSC52 echo message
        },
    })
end

function config.substitute()
    require("substitute").setup({
        on_substitute = require("yanky.integration").substitute(),
        yank_substituted_text = true,
    })
end

function config.cool_sub()
    require("cool-substitute").setup({
        setup_keybindings = true,
        mappings = {
            start = "gm", -- Mark word / region
            start_and_edit = "gM", -- Mark word / region and also edit
            start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
            start_word = "g!m", -- Mark word / region. Edit only full word
            apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
            apply_substitute_and_prev = "\\p", -- same as M but backwards
            apply_substitute_all = "\\\\a", -- Substitute all
            force_terminate_substitute = "g!!",
        },
        -- reg_char = "o", -- letter to save macro (Dont use number or uppercase here)
        -- mark_char = "t", -- mark the position at start of macro
    })
end

function config.text_case()
    vim.cmd([[Lazy load telescope.nvim]])
    require("telescope").load_extension("textcase")
end

function config.neoclip()
    require("neoclip").setup({
        history = 2000,
        enable_persistent_history = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        default_register = "a extra=star,plus,unnamed,b",
        default_register_macros = "q",
        enable_macro_history = true,
        content_spec_column = true,
        on_paste = {
            set_reg = false,
        },
        on_replay = {
            set_reg = false,
        },
        keys = {
            telescope = {
                i = {
                    select = "<cr>",
                    paste = "<c-p>",
                    paste_behind = "<c-k>",
                    replay = "<c-q>",
                    custom = {},
                },
                n = {
                    select = "<cr>",
                    paste = "p",
                    paste_behind = "P",
                    replay = "q",
                    custom = {},
                },
            },
        },
    })
end

return config
