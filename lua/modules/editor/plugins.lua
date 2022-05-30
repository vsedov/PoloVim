local editor = {}
local conf = require("modules.editor.config")
editor["max397574/dyn_help.nvim"] = {}

editor["nvim-neorg/neorg"] = {
    branch = "main",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        { "max397574/neorg-kanban", ft = "norg" },
    },
    config = conf.norg,
}

editor["folke/zen-mode.nvim"] = {
    opt = true,
    requires = { "folke/twilight.nvim", opt = true, config = conf.twilight },
    cmd = { "ZenMode" },
    config = conf.zen,
}

editor["rainbowhxch/accelerated-jk.nvim"] = {
    keys = {
        "j",
        "k",
    },
    config = conf.acc_jk,
}

editor["gbprod/yanky.nvim"] = {
    keys = {
        "<C-v>",
        "<Plug>(YankyYank)",
        "<Plug>(YankyPutAfter)",
        "<Plug>(YankyPutBefore)",
        "<Plug>(YankyPutAfter)",
        "<Plug>(YankyPutBefore)",

        "<Plug>(YankyGPutAfter)",
        "<Plug>(YankyGPutBefore)",
        "<Plug>(YankyGPutAfter)",
        "<Plug>(YankyGPutBefore)",

        "<Plug>(YankyCycleForward)",
        "<Plug>(YankyCycleBackward)",
    },
    setup = conf.setup_yanky,
    config = conf.config_yanky,
}

editor["ggandor/lightspeed.nvim"] = {
    setup = conf.lightspeed_setup,
    event = "BufReadPost",
    opt = true,
    config = conf.lightspeed,
}

-- -- -- NORMAL mode:
-- -- -- `gcc` - Toggles the current line using linewise comment
-- -- -- `gbc` - Toggles the current line using blockwise comment
-- -- -- `[count]gcc` - Toggles the number of line given as a prefix-count
-- -- -- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- -- -- `gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

-- -- -- VISUAL mode:
-- -- -- `gc` - Toggles the region using linewise comment
-- -- -- `gb` - Toggles the region using blockwise comment

-- -- -- NORMAL mode
-- -- -- `gco` - Insert comment to the next line and enters INSERT mode
-- -- -- `gcO` - Insert comment to the previous line and enters INSERT mode
-- -- -- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- -- -- NORMAL mode
-- -- -- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- -- -- `g>c` - Comments the current line using linewise comment
-- -- -- `g>b` - Comments the current line using blockwise comment
-- -- -- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- -- -- `g<c` - Uncomments the current line using linewise comment
-- -- -- `g<b`- Uncomments the current line using blockwise comment

-- -- -- VISUAL mode
-- -- -- `g>` - Comments the region using single line
-- -- -- `g<` - Unomments the region using single line

-- -- -- `gcw` - Toggle from the current cursor position to the next word
-- -- -- `gc$` - Toggle from the current cursor position to the end of line
-- -- -- `gc}` - Toggle until the next blank line
-- -- -- `gc5l` - Toggle 5 lines after the current cursor position
-- -- -- `gc8k` - Toggle 8 lines before the current cursor position
-- -- -- `gcip` - Toggle inside of paragraph
-- -- -- `gca}` - Toggle around curly brackets

-- -- -- # Blockwise

-- -- -- `gb2}` - Toggle until the 2 next blank line
-- -- -- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- -- -- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

editor["numToStr/Comment.nvim"] = {
    keys = { "g", "<ESC>" },
    config = conf.comment,
}

editor["LudoPinelli/comment-box.nvim"] = {
    keys = { "<Leader>cb", "<Leader>cc", "<Leader>cl", "<M-p>" },
    cmd = { "CBlbox", "CBcbox", "CBline", "CBcatalog" },
    opt = true,
    config = conf.comment_box,
}

-- trying to figure out why this does not work .
editor["nyngwang/NeoZoom.lua"] = {
    opt = true,
}

editor["chaoren/vim-wordmotion"] = {
    opt = true,
    fn = {
        "<Plug>WordMotion_w",
        "<Plug>WordMotion_b",
        "<Plug>WordMotion_gE",
    },
    keys = { "w", "W", "gE", "b", "B" },
}

editor["sindrets/winshift.nvim"] = {
    cmd = "WinShift",
    opt = true,
    config = conf.win_shift,
}

editor["declancm/cinnamon.nvim"] = {
    event = "WinScrolled",
    config = conf.neoscroll,
}

-- -- Currently needs to be calle , not sure if i have to lazy load this or not.
editor["andweeb/presence.nvim"] = {
    opt = true,
    config = conf.discord,
}

editor["monaqa/dial.nvim"] = {
    keys = { "<C-a>", "<C-x>" },
    opt = true,
    config = conf.dial,
}

editor["m-demare/hlargs.nvim"] = {
    ft = { "python", "c", "cpp", "java", "lua", "rust", "go" },
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
}
editor["folke/which-key.nvim"] = {
    opt = true,
    after = "nvim-treesitter",
    config = function()
        require("modules.editor.which_key")
    end,
}
return editor
