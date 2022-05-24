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
    config = function()
        require("iswap").setup({
            keys = "qwertyuiop",
            autoswap = true,
        })
    end,
}

misc["Mephistophiles/surround.nvim"] = {
    keys = { "<F3>" },
    config = function()
        require("surround").setup({
            mappings_style = "sandwich",
            pairs = {
                nestable = {
                    { "(", ")" },
                    { "[", "]" },
                    { "{", "}" },
                    { "/", "/" },
                    {
                        "*",
                        "*",
                    },
                },
                linear = { { "'", "'" }, { "`", "`" }, { '"', '"' } },
            },
            prefix = "<F3>",
        })
    end,
}
misc["Krafi2/jeskape.nvim"] = {
    event = "InsertEnter",
    config = function()
        require("jeskape").setup({
            mappings = {
                -- avoid tex values getting in teh way
                ["\\l"] = {
                    i = "<cmd>Clap | startinsert<cr>",
                    f = "<cmd>Clap grep ++query=<cword> |  startinsert<cr>",
                },
                j = {
                    h = "<esc>O",
                    k = "<esc>",
                    j = "<esc>o",
                },
            },
        })
    end,
}

misc["fladson/vim-kitty"] = {
    ft = { "*.conf" },
}

return misc
