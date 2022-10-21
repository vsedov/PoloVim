local conf = require("modules.movement.config")
local movement = require("core.pack").package

movement({
    "ziontee113/syntax-tree-surfer",
    keys = {
        { "n", "vU" },
        { "n", "vD" },
        { "n", "vd" },
        { "n", "vu" },
        { "n", "vx" },
        { "n", "vn" },
        { "n", "gv" },
        { "n", "gfu" },
        { "n", "gif" },
        { "n", "gfo" },
        { "n", "J" },
    },
    config = conf.syntax_surfer,
})

movement({
    "ggandor/lightspeed.nvim",
    opt = true,
    config = conf.lightspeed,
})

movement({
    "ggandor/leap.nvim",
    opt = true,
    config = conf.leap,
})

movement({
    "ggandor/flit.nvim",
    opt = true,
    after = "leap.nvim",
    config = function()
        require("flit").setup()
    end,
})

movement({
    "phaazon/hop.nvim",
    tag = "v2.*",
    config = conf.hop,
    opt = true,
    keys = {
        "<leader><leader>s",
        "<leader><leader>j",
        "<leader><leader>k",
        "<leader><leader>w",
        "<leader><leader>l",
        "g/",
        "g,",
    },
})

movement({
    "booperlv/nvim-gomove",
    keys = { "<M>" },
    opt = true,
    config = conf.gomove,
})

movement({ "mizlan/iswap.nvim", cmd = { "ISwap", "ISwapWith" }, config = conf.iswap })

--  JK  AA II
movement({
    "TheBlob42/houdini.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = conf.houdini,
})

--[[ jump to the first match by pressing the <Enter> key or <C-j> ; ]]
--[[ jump to any matches by typing :, then the label assigned to the match ; ]]
--[[ delete previous characters by pressing <Backspace> or <Control-h> ; ]]
--[[ delete the pattern by pressing <Control-u> ; ]]
--[[ cancel everything by pressing the <Escape> key. ]]
movement({
    "woosaaahh/sj.nvim",
    keys = { "c/" },
    config = conf.sj,
})

movement({
    "max397574/nvim-treehopper",
    keys = {
        { "o", "u" },
        { "v", "u" },
    },
    config = function()
        lambda.augroup("TreehopperMaps", {
            {
                event = "FileType",
                command = function(args)
                    -- FIXME: this issue should be handled inside the plugin rather than manually
                    local langs = require("nvim-treesitter.parsers").available_parsers()
                    if vim.tbl_contains(langs, vim.bo[args.buf].filetype) then
                        vim.keymap.set("o", "u", ":<c-u>lua require('tsht').nodes()<cr>", { buffer = args.buf })
                        vim.keymap.set("v", "u", ":lua require('tsht').nodes()<cr>", { buffer = args.buf })
                    end
                end,
            },
        })
    end,
})

movement({ "ThePrimeagen/harpoon", module = "harpoon", opt = true, config = conf.harpoon })
movement({ "gaborvecsei/memento.nvim", opt = true, module = "memento" })
