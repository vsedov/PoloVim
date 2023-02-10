local conf = require("modules.editor.config")
local editor = require("core.pack").package

editor({ "nvim-lua/plenary.nvim", lazy = true })
editor({ "rainbowhxch/accelerated-jk.nvim", lazy = true, keys = {
    "j",
    "k",
}, config = conf.acc_jk })

editor({
    "folke/which-key.nvim",
    lazy = true,

    event = "VeryLazy",
    config = function()
        require("modules.editor.which_key")
    end,
})
editor({
    "nullchilly/fsread.nvim",
    lazy = true,
    cmd = { "FSRead", "FSClear", "FSToggle" },
    config = function()
        vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
        vim.g.skip_flow_default_hl = true -- If you want to override default highlights
        vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
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
    keys = { "<Leader>cb", "<Leader>cc", "<Leader>cl", "<M-p>" },
    cmd = { "CBlbox", "CBcbox", "CBline", "CBcatalog" },
    config = conf.comment_box,
})

-- -- --[[ This thing causes issues with respect to cmdheight=0 ]]
editor({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "CursorMoved",
})

editor({
    "anuvyklack/vim-smartword",
    lazy = true,
})
-- -- -- -- Currently needs to be calle , not sure if i have to lazy load this or not.
editor({ "andweeb/presence.nvim", lazy = true, config = conf.discord })

editor({
    "monaqa/dial.nvim",
    lazy = true,
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
    config = conf.dial,
})

editor({
    "anuvyklack/hydra.nvim",
    lazy = true,
    event = "BufEnter",
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
    config = true,
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
    lazy = true,
    event = "VeryLazy",
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

editor({
    "linty-org/readline.nvim",
    lazy = true,
    event = "VeryLazy",
    config = conf.readline,
})

editor({
    "sindrets/scratchpad.nvim",
    cmd = { "Float", "FloatMove", "Scratchpad" },
})

editor({
    "gennaro-tedesco/nvim-possession",
    keys = {
        "<leader>sl",
        "<leader>sn",
        "<leader>su",
    },
    event = "VeryLazy",
    dependencies = {
        "ibhagwan/fzf-lua",
    },
    config = true,
    init = function()
        local possession = require("nvim-possession")

        vim.keymap.set("n", "<leader>sl", function()
            possession.list()
        end)
        vim.keymap.set("n", "<leader>sn", function()
            possession.new()
        end)
        vim.keymap.set("n", "<leader>su", function()
            possession.update()
        end)
    end,
})
