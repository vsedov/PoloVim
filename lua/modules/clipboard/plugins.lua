local conf = require("modules.clipboard.config")
local clipsub = require("core.pack").package

clipsub({
    "gbprod/yanky.nvim",
    event = { "CursorMoved", "CmdlineEnter" },
    setup = conf.setup_yanky,
    config = conf.config_yanky,
    requires = { "telescope.nvim", "kkharji/sqlite.lua" },
})
--  REVISIT: (vsedov) (17:56:23 - 23/10/22): Is this even required ?
clipsub({
    "ibhagwan/smartyank.nvim",
    after = "yanky.nvim",
    config = function()
        require("smartyank").setup({
            osc52 = {
                enabled = true,
                ssh_only = false, -- false to OSC52 yank also in local sessions
                silent = false, -- true to disable the "n chars copied" echo
                echo_hl = "Directory", -- highlight group of the OSC52 echo message
            },
        })
    end,
})

clipsub({
    "gbprod/substitute.nvim",
    require = "gbprod/yanky.nvim",
    event = { "CursorMoved", "CmdlineEnter" },
    config = conf.substitute,
})

-- start = "gm", -- Mark word / region
-- start_and_edit = "gM", -- Mark word / region and also edit
-- start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
-- start_word = "g!m", -- Mark word / region. Edit only full word
-- apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
-- apply_substitute_and_prev = "\p", -- same as M but backwards
-- apply_substitute_all = "\l", -- Substitute all
clipsub({
    "otavioschwanck/cool-substitute.nvim",
    keys = {
        "gm",
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
    "ojroques/nvim-osc52",
    keys = { { "x", "\\y" }, { "n", "\\y" } },
    config = function()
        require("osc52").setup({
            max_length = 0, -- Maximum length of selection (0 for no limit)
            silent = false, -- Disable message on successful copy
            trim = false, -- Trim text before copy
        })
        vim.keymap.set("n", "\\y", require("osc52").copy_operator, { expr = true })
        vim.keymap.set("x", "\\y", require("osc52").copy_visual)
    end,
})

clipsub({
    "mg979/vim-visual-multi",
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
})

clipsub({
    "johmsalas/text-case.nvim",
    modules = "textcase",
    config = conf.text_case,
})

clipsub({
    "nicwest/vim-camelsnek",
    opt = true,
    cmd = { "Snek", "Camel", "CamelB", "Kebab" },
})

clipsub({ "mbbill/undotree", opt = true, cmd = { "UndotreeToggle" } })

clipsub({
    "ekickx/clipboard-image.nvim",
    cmd = { "PasteImg" },
    opt = true,
    config = conf.clipboardimage,
})
