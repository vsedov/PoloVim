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

clipsub({
    "mbbill/undotree",
    lazy = true,
    keys = {
        {
            "<f2>",
            vim.cmd.UndotreeToggle,
            desc = "UndoTree toggle",
        },
    },
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeFocus", "UndotreeShow" },
})

clipsub({
    "postfen/clipboard-image.nvim",
    cmd = { "PasteImg", "PasteImgUrl" },
    lazy = true,
    config = conf.clipboardimage,
})
clipsub({
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = { "kkharji/sqlite.lua" },
    config = conf.neoclip,
})

clipsub({
    "smoka7/multicursors.nvim",
    lazy = true,
    cmd = {
        "MCstart",
        "MCvisual",
        "MCpattern",
        "MCvisualPattern",
        "MCunderCursor",
        "MCclear",
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
        local N = require("multicursors.normal_mode")
        local I = require("multicursors.insert_mode")

        return {
            normal_keys = {
                -- to change default lhs of key mapping change the key
                [","] = {
                    -- assigning nil to method exits from multi cursor mode
                    method = N.clear_others,
                    -- you can pass :map-arguments here
                    opts = { desc = "Clear others" },
                },
            },
            insert_keys = {
                -- to change default lhs of key mapping change the key
                ["<CR>"] = {
                    -- assigning nil to method exits from multi cursor mode
                    method = I.Cr_method,
                    -- you can pass :map-arguments here
                    opts = { desc = "New line" },
                },
            },
            generate_hints = {
                normal = true,
                insert = true,
                extend = true,
            },
        }
    end,
})
clipsub({
    "RomanoZumbe/yanki.nvim",
    keys = {
        {
            "<leader>p",
            vim.cmd.PutNextLine,
            desc = "PutNextLine",
        },
        {
            "<leader>yl",
            vim.cmd.ShowYankHistory,
            desc = "ShowYankHistory",
        },
        {
            "<leader>yc",
            vim.cmd.CleanYankHistory,
            desc = "CleanYankHistory",
        },
        {
            "<leader>yt",
            vim.cmd.ShowTransformers,
            desc = "ShowTransformers",
        },
    },

    config = function()
        require("yanki").setup({
            transformer = {
                {
                    name = "Split by new line",
                    action = function(text)
                        return vim.fn.split(text, "\n")
                    end,
                    active = true,
                },
                {
                    name = "Surround with register a",
                    action = function(text)
                        local closings = {
                            ["("] = ")",
                            ["["] = "]",
                            ["{"] = "}",
                            ["<"] = ">",
                        }
                        local surroundWith = vim.fn.getreg("a", 1)
                        local surroundEnd = closings[surroundWith] or surroundWith

                        text = surroundWith .. text .. surroundEnd
                        return text
                    end,
                    active = false,
                },
                {
                    name = "Add to table in register b",
                    action = function(text)
                        local tableName = vim.fn.getreg("b", 1)
                        return "table.insert(" .. tableName .. "," .. text .. ")"
                    end,
                    active = false,
                },
                {
                    name = "Replace placeholder(reg c) in template (reg d)",
                    action = function(text)
                        local placeholder = vim.fn.getreg("c", 1)
                        local template = vim.fn.getreg("d", 1)
                        return string.gsub(template, placeholder, text)
                    end,
                    active = false,
                },
            },
        })
        -- PutNextLine
    end,
    lazy = false,
})
