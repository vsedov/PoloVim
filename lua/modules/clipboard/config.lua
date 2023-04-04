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
        range = {
            prefix = "s",
            prompt_current_text = false,
            confirm = false,
            complete_word = false,
            motion1 = false,
            motion2 = false,
            suffix = "",
        },
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

function config.vmulti()
    vim.g.VM_mouse_mappings = 1
    -- mission control takes <C-up/down> so remap <M-up/down> to <C-Up/Down>
    -- vim.api.nvim_set_keymap("n", "<M-n>", "<C-n>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Down>", "<C-Down>", {silent = true})
    -- vim.api.nvim_set_keymap("n", "<M-Up>", "<C-Up>", {silent = true})
    -- for mac C-L/R was mapped to mission control
    -- print('vmulti')
    vim.g.VM_silent_exit = 1
    vim.g.VM_show_warnings = 0
    vim.g.VM_default_mappings = 1
    vim.cmd([[
      let g:VM_maps = {}
      let g:VM_maps['Find Under'] = '<C-n>'
      let g:VM_maps['Find Subword Under'] = '<C-n>'
      let g:VM_maps['Select All'] = '<C-n>a'
      let g:VM_maps['Seek Next'] = 'n'
      let g:VM_maps['Seek Prev'] = 'N'
      let g:VM_maps["Undo"] = 'u'
      let g:VM_maps["Redo"] = '<C-r>'
      let g:VM_maps["Remove Region"] = '<cr>'
      let g:VM_maps["Add Cursor Down"] = '<M-Down>'
      let g:VM_maps["Add Cursor Up"] = "<M-Up>"
      let g:VM_maps["Mouse Cursor"] = "<M-LeftMouse>"
      let g:VM_maps["Mouse Word"] = "<M-RightMouse>"
      let g:VM_maps["Add Cursor At Pos"] = '<M-i>'
  ]])
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
            affix = "!{%s}[image]",
        },
        tex = {
            img_dir = "img",
            img_name = img_func,
            img_dir_txt = "img",
            affix = [[\includegraphics{%s}]],
        },
    })
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
