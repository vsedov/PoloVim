local misc = {}
local conf = require("modules.misc.config")
misc["ziontee113/syntax-tree-surfer"] = {
    keys = {
        { "n", "vd" },
        { "n", "vu" },
        { "n", "vx" },
        { "n", "vn" },

        { "x", "J" },
        { "x", "K" },
        { "x", "H" },
        { "x", "L" },

        { "x", "<A-j>" },
        { "x", "<A-k>" },
    },
    config = conf.syntax_surfer,
}

-- nvim-colorizer replacement
misc["rrethy/vim-hexokinase"] = {
    -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
    config = conf.hexokinase,
    run = "make hexokinase",
    opt = true,
    cmd = { "HexokinaseTurnOn", "HexokinaseToggle" },
}

-- Its hard for this because binds are weird
misc["booperlv/nvim-gomove"] = {
    event = { "CursorMoved", "CursorMovedI" },
    opt = true,
    config = conf.gomove,
}

misc["mg979/vim-visual-multi"] = {
    keys = {
        "<Ctrl>",
        "<M>",
        "<C-n>",
        "<C-n>",
        "<M-n>",
        "<S-Down>",
        "<S-Up>",
        "<M-Left>",
        "<M-i>",
        "<M-Right>",
        "<M-D>",
        "<M-Down>",
        "<C-d>",
        "<C-Down>",
        "<S-Right>",
        "<C-LeftMouse>",
        "<M-LeftMouse>",
        "<M-C-RightMouse>",
    },
    opt = true,
    setup = conf.vmulti,
}
misc["mbbill/undotree"] = { opt = true, cmd = { "UndotreeToggle" } }

misc["mizlan/iswap.nvim"] = {
    cmd = { "ISwap", "ISwapWith" },
    config = conf.iswap,
}

misc["Mephistophiles/surround.nvim"] = {
    keys = { "<F3>" },
    config = conf.surround,
}
misc["Krafi2/jeskape.nvim"] = {
    event = "InsertEnter",
    config = conf.jetscape,
}

misc["fladson/vim-kitty"] = {
    ft = { "*.conf" },
}

-- Need to lazyload
misc["johmsalas/text-case.nvim"] = {
    config = conf.text_case,
}

misc["chentoast/marks.nvim"] = {
    opt = true,
    keys = { "mx", "m", "m,", "m;" },
    config = conf.marks,
}
return misc
