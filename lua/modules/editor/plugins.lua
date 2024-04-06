local conf = require("modules.editor.config")
local editor = require("core.pack").package

editor({ "nvim-lua/plenary.nvim", lazy = true })

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
    keys = {
        {
            "g",
            mode = { "v", "n" },
        },
        {
            "gcc",
            mode = "v",
        },
        {
            "gc",
            mode = "v",
        },
    },
    config = conf.comment,
})

editor({
    "LudoPinelli/comment-box.nvim",
    lazy = true,
    config = conf.comment_box,
})

editor({ "andweeb/presence.nvim", lazy = true, config = conf.discord })

editor({
    "monaqa/dial.nvim",
    lazy = true,
    keys = {
        { "<c-a>", mode = "n" },
        { "<c-x>", mode = "n" },
        { "g<c-a>", mode = "n" },
        { "g<c-x>", mode = "n" },
        { "<c-a>", mode = "v" },
        { "<c-x>", mode = "v" },
        { "g<c-a>", mode = "v" },
        { "g<c-x>", mode = "v" },
    },
    config = conf.dial,
})

editor({
    "nvimtools/hydra.nvim",
    cond = lambda.config.editor.hydra.use_hydra,
    lazy = true,
    config = conf.hydra,
    event = "VeryLazy",
})

editor({
    "Wansmer/treesj",
    cmd = {
        "TSJToggle",
        "TSJSplit",
        "TSJJoin",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │ misc                                                               │
    --  ╰────────────────────────────────────────────────────────────────────╯

    -- nnoremap("<Leader>J", ":TSJJoin<Cr>", { desc = "TSJJoin", silent = true })
    -- nnoremap("<Leader>j", ":TSJToggle<cr>", { desc = "TSJToggle", silent = true })
    keys = {
        { "<leader>j", ":TSJToggle<cr>", desc = "TSJToggle", silent = true },
    },

    opts = {
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 9999999,
    },
})
editor({
    "Wansmer/sibling-swap.nvim",
    keys = { "[w", "]w" },
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
    "marklcrns/vim-smartq",
    cond = lambda.config.editor.use_smart_q,
    lazy = true,
    init = function()
        vim.g.smartq_q_buftypes = {
            "quickfix",
            "nofile",
            "acwrite",
        }
        local smart_close_filetypes = {
            "diff",
            "git",
            "qf",
            "log",
            "help",
            "query",
            "dbui",
            "lspinfo",
            "git.*",
            "Neogit.*",
            "neotest.*",
            "fugitive.*",
            "copilot.*",
            "tsplayground",
            "startuptime",
        }
        vim.g.smartq_q_filetypes = smart_close_filetypes
    end,
    keys = { "q", "Q" },
})

editor({
    "MaximilianLloyd/lazy-reload.nvim",
    keys = {
        -- Opens the command.
        { "<leader><leader>r", "<cmd>lua require('lazy-reload').feed()<cr>", desc = "Reload a plugin" },
    },
    config = true,
})
-- NOTE: (vsedov) (13:40:57 - 28/02/24): This is for keymaps u can use hawtkeys instead of map or
-- imap
editor({
    "tris203/hawtkeys.nvim",
    cmd = {
        "Hawtkeys",
        "HawtkeysAll",
        "HawtkeysDupes",
    },
    config = true,
})
