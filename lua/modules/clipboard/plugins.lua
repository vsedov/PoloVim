local clipsub = require("core.pack").package
local conf = require("modules.clipboard.config")
--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

clipsub({
    "gbprod/yanky.nvim",
    lazy = true,
    event = "VeryLazy",
    config = conf.config_yanky,
    dependencies = {

        "nvim-telescope/telescope.nvim",
        "kkharji/sqlite.lua",
        {
            "ibhagwan/smartyank.nvim",
            config = conf.smart_yank,
        },
    },
})

clipsub({
    "gbprod/substitute.nvim",
    lazy = true,
    dependencies = "gbprod/yanky.nvim",
    config = conf.substitute,
})

clipsub({
    "chrisgrieser/nvim-alt-substitute",
    opts = {
        showNotification = true, -- whether to show the "x replacements made" notification
    },
    event = "CmdlineEnter",
})

--  ──────────────────────────────────────────────────────────────────────

-- start = "gm", -- Mark word / region
-- start_and_edit = "gM", -- Mark word / region and also edit
-- start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
-- start_word = "g!m", -- Mark word / region. Edit only full word
-- apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
-- apply_substitute_and_prev = "\p", -- same as M but backwards
-- apply_substitute_all = "\l", -- Substitute all
clipsub({
    "otavioschwanck/cool-substitute.nvim",
    lazy = true,
    keys = {
        { "gm", mode = { "n", "v" } },
        "gM",
        "g!M",
        "g!m",
        "\\m",
        "\\p",
        "\\\\a",
        "g!!",
    },
    config = conf.cool_sub,
})
clipsub({
    "johmsalas/text-case.nvim",
    lazy = true,
    config = conf.text_case,
})

clipsub({
    "nicwest/vim-camelsnek",
    lazy = true,
    cmd = { "Snek", "Camel", "CamelB", "Kebab" },
})

clipsub({ "mbbill/undotree", lazy = true, cmd = { "UndotreeToggle" } })

clipsub({
    "postfen/clipboard-image.nvim",
    cmd = { "PasteImg" },
    lazy = true,
    config = conf.clipboardimage,
})

-- -- manual call
clipsub({
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = { "kkharji/sqlite.lua" },
    config = conf.neoclip,
})
