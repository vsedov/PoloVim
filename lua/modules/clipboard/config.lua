local config = {}
function config.config_yanky()
    local mapping = require("yanky.telescope.mapping")
    require("yanky").setup({
        ring = {
            history_length = 100,
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
    local Hydra = require("hydra")
    local api = vim.api
    local function t(str)
        return api.nvim_replace_termcodes(str, true, true, true)
    end

    local hint = [[
    ^ ^ _p_: After   ^ ^
    ^ ^ _P_: Before  ^ ^
    ^ ^ _n_: ↓       ^ ^
    ^ ^ _N_: ↑       ^ ^
    ]]

    local yanky_hydra = Hydra({
        name = "Yank ring",
        mode = "n",
        config = {
            color = "amaranth",
            invoke_on_body = false,
            hint = {
                border = lambda.style.border.type_0,
                position = "middle-right",
            },
        },
        hint = hint,
        body = "p",
        heads = {
            { "p", "<Plug>(YankyPutAfter)", { desc = "After" } },
            { "P", "<Plug>(YankyPutBefore)", { desc = "Before" } },
            { "n", "<Plug>(YankyCycleForward)", { noremap = true, private = true, desc = "↓" } },
            { "N", "<Plug>(YankyCycleBackward)", { noremap = true, private = true, desc = "↑" } },
            {
                "<esc>",
                nil,
                { exit = true, desc = "quit" },
            },

            {
                "q",
                nil,
                { exit = true, desc = "quit" },
            },
        },
    })
    -- choose/change the mappings if you want
    for key, putAction in pairs({
        [";p"] = "<Plug>(YankyPutAfter)",
        [";P"] = "<Plug>(YankyPutBefore)",

        ["gp"] = "<Plug>(YankyGPutAfter)",
        ["gP"] = "<Plug>(YankyGPutBefore)",
    }) do
        vim.keymap.set({ "n", "x" }, key, function()
            vim.fn.feedkeys(t(putAction))
            yanky_hydra:activate()
        end)
    end
    for key, putAction in pairs({
        ["p"] = "<Plug>(YankyPutAfter)",
        ["P"] = "<Plug>(YankyPutBefore)",
    }) do
        vim.keymap.set({ "n", "x" }, key, function()
            vim.fn.feedkeys(t(putAction))
        end)
    end

    for key, putAction in pairs({
        ["]p"] = "<Plug>(YankyPutIndentAfterLinewise)",
        ["[p"] = "<Plug>(YankyPutIndentBeforeLinewise)",
        ["]P"] = "<Plug>(YankyPutIndentAfterLinewise)",
        ["[P"] = "<Plug>(YankyPutIndentBeforeLinewise)",

        [">p"] = "<Plug>(YankyPutIndentAfterShiftRight)",
        ["<p"] = "<Plug>(YankyPutIndentAfterShiftLeft)",
        [">P"] = "<Plug>(YankyPutIndentBeforeShiftRight)",
        ["<P"] = "<Plug>(YankyPutIndentBeforeShiftLeft)",

        ["=p"] = "<Plug>(YankyPutAfterFilter)",
        ["=P"] = "<Plug>(YankyPutBeforeFilter)",
    }) do
        vim.keymap.set("n", key, function()
            vim.fn.feedkeys(t(putAction))
            vim.schedule_wrap(yanky_hydra:activate())
        end, { noremap = true, silent = true })
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

function config.clipboardimage()
    local img_func = function()
        vim.fn.inputsave()
        local name = vim.fn.input("Name: ")
        vim.fn.inputrestore()

        if name == nil or name == "" then
            return os.date("%y-%m-%d-%H-%M-%S")
        end
        return name
    end
    require("clipboard-image").setup({
        default = {
            img_name = img_func,
        },
        norg = {
            img_name = img_func,
            img_dir = "img",
            img_dir_txt = "img",
            affix = ".image %s",
        },
        tex = {
            img_dir = "img",
            img_name = img_func,
            img_dir_txt = "img",
            affix = [[\begin{wrapfigure}{\textwidth}
  \begin{center}
  \includegraphics[width=0.7\textwidth]{%s}
  \end{center}
  \caption{Update me}
\end{wrapfigure}]],
        },
    })
    local function paste_url(url)
        -- check if url is in clipboard
        url = url.args or vim.fn.getreg("+")
        -- check if imgure is in clip
        if url:find("imgur") then
        end
        -- https://i.imgur.com/btkPKSa.png
        -- validate if any clipboard contains imgur
        -- if not, then use url.args
        -- Check clipboard

        local utils = require("clipboard-image.utils")
        local conf_utils = require("clipboard-image.config")

        local conf_toload = conf_utils.get_usable_config()
        local conf = conf_utils.load_config(conf_toload)

        utils.insert_txt(conf.affix, url)
    end
    -- Now let's create the command (works on neovim 0.7+)
    lambda.command("PasteImgUrl", paste_url, { nargs = "*" })
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
