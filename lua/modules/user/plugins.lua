local user = require("core.pack").package

user({
    "p00f/cphelper.nvim",
    cmd = {
        "CphReceive",
        "CphTest",
        "CphReTest",
        "CphEdit",
        "CphDelete",
    },
    lazy = true,
    config = function()
        vim.g["cph#lang"] = "python"
        vim.g["cph#border"] = lambda.style.border.type_0
    end,
})

user({
    "samjwill/nvim-unception",
    lazy = true,
    init = function()
        lambda.lazy_load({
            events = "CmdlineEnter",
            pattern = "toggleterm",
            augroup_name = "unception",
            condition = lambda.config.use_unception,
            plugin = "nvim-unception",
        })
    end,
    config = function()
        vim.g.unception_delete_replaced_buffer = true
        vim.g.unception_enable_flavor_text = false
    end,
})

user({
    "LunarVim/bigfile.nvim",
    event = "VeryLazy",
    config = function()
        local default_config = {
            filesize = 2,
            pattern = { "*" },
            features = {
                "indent_blankline",
                "illuminate",
                "syntax",
                "matchparen",
                "vimopts",
                "filetype",
            },
        }
        require("bigfile").config(default_config)
    end,
})

user({
    "elihunter173/dirbuf.nvim",
    cmd = "DirBuf",
    config = function()
        require("dirbuf").setup({
            hash_padding = 2,
            show_hidden = true,
            sort_order = "default",
            write_cmd = "DirbufSync",
        })
    end,
})

user({
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    config = true,
})

user({
    "meatballs/notebook.nvim",
    ft = "ipynb",
    dependencies = { "dccsillag/magma-nvim" },
})

user({
    "Apeiros-46B/qalc.nvim",
    config = true,
    cmd = { "Qalc", "QalcAttach" },
})
