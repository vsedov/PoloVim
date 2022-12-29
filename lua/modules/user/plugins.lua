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
-- -- --
-- user({
--     "glepnir/hlsearch.nvim",
--     init =  function()
--         lambda.lazy_load({
--             events = "BufRead",
--             augroup_name = "hlsearch",
--             condition = false,
--             plugin = "hlsearch.nvim",
--         })
--     end,
--     config = function()
--         require("hlsearch").setup()
--     end,
-- })

user({
    "nullchilly/fsread.nvim",
    cmd = { "FSRead", "FSClear", "FSToggle" },
    config = function()
        vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
        vim.g.skip_flow_default_hl = true -- If you want to override default highlights
        vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
    end,
})

user({
    "chrisgrieser/nvim-genghis",
    requires = "stevearc/dressing.nvim",
    lazy = true,
    cmd = {
        "GenghiscopyFilepath",
        "GenghiscopyFilename",
        "Genghischmodx",
        "GenghisrenameFile",
        "GenghiscreateNewFile",
        "GenghisduplicateFile",
        "Genghistrash",
        "Genghismove",
    },
    config = function()
        local genghis = require("genghis")
        lambda.command("GenghiscopyFilepath", genghis.copyFilepath, {})
        lambda.command("GenghiscopyFilename", genghis.copyFilename, {})
        lambda.command("Genghischmodx", genghis.chmodx, {})
        lambda.command("GenghisrenameFile", genghis.renameFile, {})
        lambda.command("GenghiscreateNewFile", genghis.createNewFile, {})
        lambda.command("GenghisduplicateFile", genghis.duplicateFile, {})
        lambda.command("Genghistrash", function()
            genghis.trashFile({ trashLocation = "/home/viv/.local/share/Trash/" })
        end, {})
        lambda.command("Genghismove", genghis.moveSelectionToNewFile, {})
    end,
})

-- -- about time .
user({
    "LunarVim/bigfile.nvim",
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

-- https://github.com/f/awesome-chatgpt-prompts

-- <C-c> to close chat window.
-- <C-u> scroll up chat window.
-- <C-d> scroll down chat window.
-- <C-y> to copy/yank last answer.
user({
    "jackMort/ChatGPT.nvim",
    cmd = {
        "ChatGPT",
        "ChatGPTActAs",
    },
    config = function()
        require("chatgpt").setup({
            -- optional configuration
        })
    end,
    requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
})

user({
    "xorid/asciitree.nvim",
    cmd = "AsciiTree",

    config = function()
        require("asciitree").setup({
            -- Characters used to represent the tree.
            symbols = {
                child = "├",
                last = "└",
                parent = "│",
                dash = "─",
                blank = " ",
            },

            -- How deep each level should be drawn. This value can be overridden by
            -- calling the AsciiTree command with a number, such as :AsciiTree 4.
            depth = 2,

            -- The delimiter to look for when converting to a tree. By default, this
            -- looks for a tree that looks like:
            -- # Level 1
            -- ## Level 2
            -- ### Level 3
            -- #### Level 4
            --
            -- Changing it to "+" would look for the following:
            -- + Level 1
            -- ++ Level 2
            -- +++ Level 3
            -- ++++ Level 4
            delimiter = "#",
        })
    end,
})

user({
    "shortcuts/no-neck-pain.nvim",
    lazy = true,
    cmd = "NoNeckPain",
    keys = { "zz" },
    config = function()
        NoNeckPain = {}
        NoNeckPain.bufferOptions = {
            -- When `false`, the buffer won't be created.
            enabled = true,
            -- Hexadecimal color code to override the current background color of the buffer. (e.g. #24273A)
            -- popular theme are supported by their name:
            -- - catppuccin-frappe
            -- - catppuccin-frappe-dark
            -- - catppuccin-latte
            -- - catppuccin-latte-dark
            -- - catppuccin-macchiato
            -- - catppuccin-macchiato-dark
            -- - catppuccin-mocha
            -- - catppuccin-mocha-dark
            -- - tokyonight-day
            -- - tokyonight-moon
            -- - tokyonight-night
            -- - tokyonight-storm
            -- - rose-pine
            -- - rose-pine-moon
            -- - rose-pine-dawn
            backgroundColor = nil,
            -- buffer-scoped options: any `vim.bo` options is accepted here.
            bo = {
                filetype = "no-neck-pain",
                buftype = "nofile",
                bufhidden = "hide",
                modifiable = false,
                buflisted = false,
                swapfile = false,
            },
            -- window-scoped options: any `vim.wo` options is accepted here.
            wo = {
                cursorline = false,
                cursorcolumn = false,
                number = false,
                relativenumber = false,
                foldenable = false,
                list = false,
            },
        }

        require("no-neck-pain").setup({
            -- The width of the focused buffer when enabling NNP.
            -- If the available window size is less than `width`, the buffer will take the whole screen.
            width = 100,
            -- Prints useful logs about what event are triggered, and reasons actions are executed.
            debug = false,
            -- Disables NNP if the last valid buffer in the list has been closed.
            disableOnLastBuffer = false,
            -- When `true`, disabling NNP kills every split/vsplit buffers except the main NNP buffer.
            killAllBuffersOnDisable = false,
            --- Options related to the side buffers. See |NoNeckPain.bufferOptions|.
            buffers = {
                -- When `true`, the side buffers will be named `no-neck-pain-left` and `no-neck-pain-right` respectively.
                setNames = false,
                -- Common options are set to both buffers, for option scoped to the `left` and/or `right` buffer, see `buffers.left` and `buffers.right`.
                common = NoNeckPain.bufferOptions,
                --- Options applied to the `left` buffer, the options defined here overrides the `common` ones.
                --- When `nil`, the buffer won't be created.
                left = NoNeckPain.bufferOptions,
                --- Options applied to the `left` buffer, the options defined here overrides the `common` ones.
                --- When `nil`, the buffer won't be created.
                right = NoNeckPain.bufferOptions,
            },
            -- lists supported integrations that might clash with `no-neck-pain.nvim`'s behavior
            integrations = {
                -- https://github.com/nvim-tree/nvim-tree.lua
                nvimTree = {
                    -- the position of the tree, can be `left` or `right``
                    position = "left",
                },
            },
        })
        vim.keymap.set("n", "zz", "<cmd>NoNeckPain<cr>", {})
    end,
})

user({
    "phaazon/mind.nvim",
    cmd = {
        "MindOpenMain",
        "MindOpenProject",
        "MindOpenSmartProject",
        "MindReloadState",
        "MindClose",
    },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
        require("mind").setup()
    end,
})
