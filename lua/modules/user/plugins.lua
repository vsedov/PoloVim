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
    event = "CmdlineEnter",
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
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    config = true,
})




user({
    "Apeiros-46B/qalc.nvim",
    config = true,
    cmd = { "Qalc", "QalcAttach" },
})




-- The goal of nvim-fundo is to make Neovim's undo file become stable and useful.
user({
    "kevinhwang91/nvim-fundo",
    event = "VeryLazy",
    cmd = { "FundoDisable", "FundoEnable" },
    dependencies = "kevinhwang91/promise-async",
    build = function()
        require("fundo").install()
    end,
    config = true,
})


user({
    "stevearc/oil.nvim",
    lazy = true, 
    init = function()
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end,
    event = "VeryLazy",
    config = true, 
})

user({
    "AntonVanAssche/date-time-inserter.nvim",
    lazy = true, 
    cmd ={
        "InsertDate",
        "InsertTime",
        "InsertDateTime"
    },
    config = true, 

})

user({
    "2kabhishek/co-author.nvim",
    lazy  = true, 
    cmd = {
        "GitCoAuthors",
    }
})