local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
ts({ "nvim-treesitter/nvim-treesitter", opt = true, run = ":TSUpdate", config = conf.nvim_treesitter })

ts({
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
    config = conf.rainbow,
    opt = true,
})
ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    config = conf.treesitter_obj,
    opt = true,
})
ts({
    "JoosepAlviste/nvim-ts-context-commentstring",
    opt = true,
})

ts({
    "RRethy/nvim-treesitter-textsubjects",
    ft = { "lua", "rust", "go", "python", "javascript" },
    opt = true,
    config = conf.tsubject,
})

ts({
    "RRethy/nvim-treesitter-endwise",
    ft = { "lua", "ruby", "vim" },
    event = "InsertEnter",
    opt = true,
    config = conf.endwise,
})

ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter-textobjects", -- manual loading
    config = conf.treesitter_ref, -- let the last loaded config treesitter
    opt = true,
})

ts({
    "David-Kunz/markid",
    after = "nvim-treesitter",
})

ts({
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

ts({ "nvim-treesitter/nvim-treesitter-context", event = "WinScrolled", config = conf.context })
