local conf = require("modules.editor.config")
local editor = require("core.pack").package

editor({ "nvim-lua/plenary.nvim", lazy = true })
-- editor({ "rainbowhxch/accelerated-jk.nvim", lazy = true, keys = {
--     "j",
--     "k",
-- }, config = conf.acc_jk })
--
editor({
    "folke/which-key.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
        require("modules.editor.which_key")
    end,
})

-- -- -- -- NORMAL mode:
-- -- -- -- `gcc` - Toggles the current line using linewise comment
-- -- -- -- `gbc` - Toggles the current line using blockwise comment
-- -- -- -- `[count]gcc` - Toggles the number of line given as a prefix-count
-- -- -- -- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- -- -- -- `gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

-- -- -- -- VISUAL mode:
-- -- -- -- `gc` - Toggles the region using linewise comment
-- -- -- -- `gb` - Toggles the region using blockwise comment

-- -- -- -- NORMAL mode
-- -- -- -- `gco` - Insert comment to the next line and enters INSERT mode
-- -- -- -- `gcO` - Insert comment to the previous line and enters INSERT mode
-- -- -- -- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- -- -- -- NORMAL mode
-- -- -- -- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- -- -- -- `g>c` - Comments the current line using linewise comment
-- -- -- -- `g>b` - Comments the current line using blockwise comment
-- -- -- -- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- -- -- -- `g<c` - Uncomments the current line using linewise comment
-- -- -- -- `g<b`- Uncomments the current line using blockwise comment

-- -- -- -- VISUAL mode
-- -- -- -- `g>` - Comments the region using single line
-- -- -- -- `g<` - Unomments the region using single line

-- -- -- -- `gcw` - Toggle from the current cursor position to the next word
-- -- -- -- `gc$` - Toggle from the current cursor position to the end of line
-- -- -- -- `gc}` - Toggle until the next blank line
-- -- -- -- `gc5l` - Toggle 5 lines after the current cursor position
-- -- -- -- `gc8k` - Toggle 8 lines before the current cursor position
-- -- -- -- `gcip` - Toggle inside of paragraph
-- -- -- -- `gca}` - Toggle around curly brackets

-- -- -- -- # Blockwise

-- -- -- -- `gb2}` - Toggle until the 2 next blank line
-- -- -- -- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- -- -- -- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

editor({
    "numToStr/Comment.nvim",
    lazy = true,
    keys = { { "g", mode = "n" }, { "g", mode = "v" } },
    config = conf.comment,
})

editor({
    "LudoPinelli/comment-box.nvim",
    lazy = true,
    config = conf.comment_box,
})

-- -- --[[ This thing causes issues with respect to cmdheight=0 ]]
editor({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "VeryLazy",
    config = function()
        vim.g.wordmotion_prefix = ","
    end,
})

editor({
    "anuvyklack/vim-smartword",
    lazy = true,
})

editor({ "andweeb/presence.nvim", lazy = true, config = conf.discord })

editor({
    "monaqa/dial.nvim",
    lazy = true,
    keys = {
        { ";x", mode = "n" },
        { ";a", mode = "n" },

        { ";a", mode = "v" },
        { ";a", mode = "v" },

        { ";ga", mode = "v" },
        { ";gx", mode = "v" },

        { "_a", mode = "n" },
        { "_x", mode = "n" },
    },
    config = conf.dial,
})

editor({
    "anuvyklack/hydra.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "anuvyklack/keymap-layer.nvim" },
    config = conf.hydra,
})

editor({
    "jbyuki/venn.nvim",
    lazy = true,
    cmd = "Venn",
    config = conf.venn,
})

editor({
    "Wansmer/treesj",
    cmd = {
        "TSJToggle",
        "TSJSplit",
        "TSJJoin",
    },
    opts = {
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 500,
    },
})
editor({
    "Wansmer/sibling-swap.nvim",
    keys = { "]w", "[w" },
    dependencies = { "nvim-treesitter" },
    opts = {
        use_default_keymaps = true,
        highlight_node_at_cursor = true,
        keymaps = {
            ["]w"] = "swap_with_left",
            ["[w"] = "swap_with_right",
        },
    },
})

editor({
    "haya14busa/vim-asterisk",
    lazy = true,
    keys = {
        { "<Plug>(asterisk-", mode = "" },
    },
    init = conf.asterisk_setup,
})

editor({
    "marklcrns/vim-smartq",
    cond = lambda.config.editor.use_smart_q,
    lazy = true,
    init = function()
        vim.g.smartq_q_buftypes = {
            "quickfix",
            "nofile",
            "acwrite",
        }
        local smart_close_filetypes = lambda.p_table({
            ["diff"] = true,
            ["git"] = true,
            ["qf"] = true,
            ["log"] = true,
            ["help"] = true,
            ["query"] = true,
            ["dbui"] = true,
            ["lspinfo"] = true,
            ["git.*"] = true,
            ["Neogit.*"] = true,
            ["neotest.*"] = true,
            ["fugitive.*"] = true,
            ["copilot.*"] = true,
            ["tsplayground"] = true,
            ["startuptime"] = true,
        })
        vim.g.smartq_q_filetypes = smart_close_filetypes
    end,
    event = "VeryLazy",
})

editor({
    "AndrewRadev/switch.vim",
    lazy = true,
    init = function()
        vim.g.switch_mapping = "<leader>S"
    end,
    keys = { "<leader>S" },
    cmd = { "Switch", "SwitchCase" },
})

editor({
    "MaximilianLloyd/lazy-reload.nvim",
    keys = {
        -- Opens the command.
        { "<localleader>rl", "<cmd>lua require('lazy-reload').feed()<cr>", desc = "Reload a plugin" },
    },
    config = true,
})

editor({
    "aaron-p1/virt-notes.nvim",
    keys = { "<leader>v" },
    config = true,
})
