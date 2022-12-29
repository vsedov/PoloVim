local conf = require("modules.editor.config")
local editor = require("core.pack").package

editor({ "nvim-lua/plenary.nvim", module = "plenary" })
editor({ "rainbowhxch/accelerated-jk.nvim", keys = {
    "j",
    "k",
}, config = conf.acc_jk })

editor({
    "folke/which-key.nvim",
    module = "which-key",
    after = "nvim-treesitter",
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

editor({ "numToStr/Comment.nvim", keys = { "g", "<ESC>" }, config = conf.comment })

editor({
    "LudoPinelli/comment-box.nvim",
    keys = { "<Leader>cb", "<Leader>cc", "<Leader>cl", "<M-p>" },
    cmd = { "CBlbox", "CBcbox", "CBline", "CBcatalog" },
    lazy = true,
    config = conf.comment_box,
})

-- -- --[[ This thing causes issues with respect to cmdheight=0 ]]
editor({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "BufWinEnter",
    init = function()
        vim.g.wordmotion_uppercase_spaces = { "-" }
        vim.g.wordmotion_nomap = 1
        for _, key in ipairs({ "e", "b", "w", "E", "B", "W", "ge", "gE" }) do
            vim.keymap.set({ "n", "x", "o" }, key, "<Plug>WordMotion_" .. key)
        end
        vim.keymap.set("c", "<C-R><C-W>", "<Plug>WordMotion_<C-R><C-W>")
        vim.keymap.set("c", "<C-R><C-A>", "<Plug>WordMotion_<C-R><C-A>")
    end,
})

editor({
    "anuvyklack/vim-smartword",
    keys = {
        "<Plug>(smartword-w)",
        "<Plug>(smartword-b)",
        "<Plug>(smartword-e)",
        "<Plug>(smartword-ge)",
    },
})
-- -- -- -- Currently needs to be calle , not sure if i have to lazy load this or not.
editor({ "andweeb/presence.nvim", lazy = true, config = conf.discord })

editor({
    "monaqa/dial.nvim",
    keys = {
        { "<C-x>", mode = "n" },
        { "<C-a>", mode = "n" },

        { "<C-a>", mode = "v" },
        { "<C-x>", mode = "v" },

        { "g<C-a>", mode = "v" },
        { "g<C-x>", mode = "v" },

        { "_a", mode = "n" },
        { "_x", mode = "n" },
    },
    lazy = true,
    config = conf.dial,
})

editor({
    "anuvyklack/hydra.nvim",
    dependencies = "anuvyklack/keymap-layer.nvim",
    config = conf.hydra,
    lazy = true,
    keys = {
        "<leader>b",
        "<localleader>b",
        "<leader>d",
        ";A",
        ";\\",
        "<leader>h",
        "<leader>H",
        "H",
        "L",
        "<cr>",
        ";l",
        "m",
        "<leader>u",
        "\\l",
        ";p",
        "<leader>I",
        ";;",
        "<leader>r",
        "<localleader>r",
        ";r",
        "<leader>L",
        ";s",
        "<leader>f",
        "gaa",
        "gae",
        ";w",
        "\\<leader",
        "<leader>O",
        "<c-w>[",
        "<localleader>w",
        "<leader>yu",
        "p",
        "P",
        "gp",
        "gP",
        "]p",
        "[p",
        "]P",
        "[P",
        ">p",
        "<p",
        ">P",
        "<P",
        "=p",
        "=P",
    },
})

editor({
    "jbyuki/venn.nvim",
    lazy = true,
    cmd = "Venn",
    config = conf.venn,
})

editor({
    "aarondiel/spread.nvim",
    after = "nvim-treesitter",
    module = "spread",
    keys = { "<leader>J", "<leader>j" },
    config = function()
        vim.keymap.set("n", "<leader>J", function()
            require("spread").out()
        end, { desc = "spread: expand" })
        vim.keymap.set("n", "<leader>j", function()
            require("spread").combine()
        end, { desc = "spread: combine" })
    end,
})

editor({
    "haya14busa/vim-asterisk",
    lazy = true,
    keys = {
        { "*" },
        { "#" },
        { "g*" },
        { "g#" },
        { "z*" },
        { "gz*" },
        { "z#" },
        { "gz#" },
    },
    init = conf.asterisk_setup,
})

editor({
    "marklcrns/vim-smartq",
})

editor({
    "AndrewRadev/switch.vim",
    lazy = true,
    init = function()
        vim.g.switch_mapping = ";S"
    end,
    keys = { ";S" },
    cmd = { "Switch", "SwitchCase" },
})
