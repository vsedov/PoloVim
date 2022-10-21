local config = {}
function config.setup_yanky()
    local default_keymaps = {
        { "n", "y", "<Plug>(YankyYank)" },
        { "x", "y", "<Plug>(YankyYank)" },

        { "n", "p", "<Plug>(YankyPutAfter)" },
        { "n", "P", "<Plug>(YankyPutBefore)" },

        { "x", "p", "<Plug>(YankyPutAfter)" },
        { "x", "P", "<Plug>(YankyPutBefore)" },

        { "n", "gp", "<Plug>(YankyGPutAfter)" },
        { "n", "gP", "<Plug>(YankyGPutBefore)" },

        { "x", "gp", "<Plug>(YankyGPutAfter)" },
        { "x", "gP", "<Plug>(YankyGPutBefore)" },

        { "n", "<Leader>n", "<Plug>(YankyCycleForward)" },
        { "n", "<Leader>N", "<Plug>(YankyCycleBackward)" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], {})
    end
end

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
            timer = 500,
        },
        preserve_cursor_position = {
            enabled = true,
        },
    })
    require("telescope").load_extension("yank_history")
    vim.keymap.set("n", "<leader>yu", "<cmd>Telescope yank_history<cr>", {})
end

function config.substitute()
    vim.cmd([[packadd yanky.nvim]])
    require("substitute").setup({
        yank_substituted_text = true,
        on_substitute = function(event)
            require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
        end,
        motion1 = true,
        motion2 = true,
    })
    vim.keymap.set("n", "LL", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
    vim.keymap.set("n", "Ll", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
    vim.keymap.set("n", "<leader>L", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
    vim.keymap.set("x", "L", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

    vim.keymap.set("n", "<leader>l", "<cmd>lua require('substitute.range').operator()<cr>", { noremap = true })
    vim.keymap.set("x", "<leader>l", "<cmd>lua require('substitute.range').visual()<cr>", { noremap = true })
    vim.keymap.set("n", "<leader>lr", "<cmd>lua require('substitute.range').word()<cr>", { noremap = true })

    vim.keymap.set("n", "Lx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
    vim.keymap.set("n", "Lxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
    vim.keymap.set("x", "Lx", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
    vim.keymap.set("n", "Lxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
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
    vim.cmd([[packadd telescope.nvim]])
    require("telescope").load_extension("textcase")
end

return config
