local folke = require("core.pack").package
local conf = require("modules.folke.config")

folke({
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<Leader>E",
            function()
                require("edgy").toggle()
            end,
            "General: [F]orce Close Edgy",
        },
    },
    opts = conf.edgy,
})

folke({
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = lambda.config.folke.noice.enable,
    dependencies = {
        "nui.nvim",
        "nvim-notify",
    },
    opts = require("modules.folke.noice").noice,
    config = require("modules.folke.noice").noice_setup,
})

folke({
    "folke/which-key.nvim",
    cond = lambda.config.tools.use_which_key_or_use_mini_clue == "which",
    event = "CursorMoved",
    lazy = true,
    config = conf.which_key,
})

folke({
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    lazy = true,
    config = true,
})

folke({
    "folke/todo-comments.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("todo-comments").setup()
        lambda.command("TodoDots", ("TodoQuickFix cwd=%s keywords=TODO,FIXME"):format(vim.g.vim_dir))
    end,
    cmd = {
        "TodoComments",
        "TodoQuickFix",
        "TodoDots",
    },
})
folke({
    "folke/neodev.nvim",
    lazy = true,
    ft = "lua",
    opts = {
        library = {
            plugins = { "nvim-dap-ui" },
        },
    },
})
folke({
    "folke/paint.nvim",
    ft = "lua",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.paint,
})

folke({
    "folke/twilight.nvim",
    lazy = true,
    cmd = {
        "Twilight",
    },
    config = true,
})

folke({
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
        -- add any custom options here
    },
})

folke({
    "folke/zen-mode.nvim",
    cond = false,
    lazy = true,
    opts = {
        -- - listen_on unix:/tmp/kitty
        kitty = {
            enabled = true,
            font = "+4", -- font size increment
        },
    },
    keys = {
        {
            "<Leader>z",
            function()
                vim.cmd("ZenMode")
            end,
            desc = "General: [Z]en Mode",
        },
    },
})
folke({
    "shortcuts/no-neck-pain.nvim",
    cmd = {
        "NoNeckPain",
        "NoNeckPainResize",
        "NoNeckPainToggleLeftSide",
        "NoNeckPainToggleRightSide",
        "NoNeckPainWidthUp",
        "NoNeckPainWidthDown",
    },
    keys = {
        {
            "<Leader>z",
            function()
                vim.cmd("NoNeckPain")
            end,
            desc = "General: [Z]en Mode",
        },
    },

    opts = {

        -- Prints useful logs about triggered events, and reasons actions are executed.
        --- @type boolean
        debug = false,
        -- The width of the focused window that will be centered. When the terminal width is less than the `width` option, the side buffers won't be created.
        --- @type integer|"textwidth"|"colorcolumn"
        width = 130,
        -- Represents the lowest width value a side buffer should be.
        -- This option can be useful when switching window size frequently, example:
        -- in full screen screen, width is 210, you define an NNP `width` of 100, which creates each side buffer with a width of 50. If you resize your terminal to the half of the screen, each side buffer would be of width 5 and thereforce might not be useful and/or add "noise" to your workflow.
        --- @type integer
        minSideBufferWidth = 10,
        -- Disables the plugin if the last valid buffer in the list have been closed.
        --- @type boolean
        disableOnLastBuffer = false,
        -- When `true`, disabling the plugin closes every other windows except the initially focused one.
        --- @type boolean
        killAllBuffersOnDisable = false,
        -- Adds autocmd (@see `:h autocmd`) which aims at automatically enabling the plugin.
        --- @type table
        autocmds = {
            -- When `true`, enables the plugin when you start Neovim.
            -- If the main window is  a side tree (e.g. NvimTree) or a dashboard, the command is delayed until it finds a valid window.
            -- The command is cleaned once it has successfuly ran once.
            --- @type boolean
            enableOnVimEnter = false,
            -- When `true`, enables the plugin when you enter a new Tab.
            -- note: it does not trigger if you come back to an existing tab, to prevent unwanted interfer with user's decisions.
            --- @type boolean
            enableOnTabEnter = false,
            -- When `true`, reloads the plugin configuration after a colorscheme change.
            --- @type boolean
            reloadOnColorSchemeChange = false,
            -- When `true`, entering one of no-neck-pain side buffer will automatically skip it and go to the next available buffer.
            --- @type boolean
            skipEnteringNoNeckPainBuffer = false,
        },
        -- Creates mappings for you to easily interact with the exposed commands.
        --- @type table
        mappings = {
            -- When `true`, creates all the mappings that are not set to `false`.
            --- @type boolean
            enabled = true,
            -- Sets a global mapping to Neovim, which allows you to toggle the plugin.
            -- When `false`, the mapping is not created.
            --- @type string
            toggle = ";zp",
            -- Sets a global mapping to Neovim, which allows you to toggle the left side buffer.
            -- When `false`, the mapping is not created.
            --- @type string
            toggleLeftSide = ";zl",
            -- Sets a global mapping to Neovim, which allows you to toggle the right side buffer.
            -- When `false`, the mapping is not created.
            --- @type string
            toggleRightSide = ";zr",
            -- Sets a global mapping to Neovim, which allows you to increase the width (+5) of the main window.
            -- When `false`, the mapping is not created.
            --- @type string | { mapping: string, value: number }
            widthUp = ";z=",
            -- Sets a global mapping to Neovim, which allows you to decrease the width (-5) of the main window.
            -- When `false`, the mapping is not created.
            --- @type string | { mapping: string, value: number }
            widthDown = ";z-",
            -- Sets a global mapping to Neovim, which allows you to toggle the scratchPad feature.
            -- When `false`, the mapping is not created.
            --- @type string
            scratchPad = ";zs",
        },
        -- Supported integrations that might clash with `no-neck-pain.nvim`'s behavior.
        --- @type table
        integrations = {
            -- By default, if NvimTree is open, we will close it and reopen it when enabling the plugin,
            -- this prevents having the side buffers wrongly positioned.
            -- @link https://github.com/nvim-tree/nvim-tree.lua
            --- @type table
            NvimTree = {
                -- The position of the tree.
                --- @type "left"|"right"
                position = "left",
                -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
                --- @type boolean
                reopen = true,
            },
            -- By default, if NeoTree is open, we will close it and reopen it when enabling the plugin,
            -- this prevents having the side buffers wrongly positioned.
            -- @link https://github.com/nvim-neo-tree/neo-tree.nvim
            NeoTree = {
                -- The position of the tree.
                --- @type "left"|"right"
                position = "left",
                -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
                reopen = true,
            },
            -- @link https://github.com/mbbill/undotree
            undotree = {
                -- The position of the tree.
                --- @type "left"|"right"
                position = "left",
            },
            -- @link https://github.com/nvim-neotest/neotest
            neotest = {
                -- The position of the tree.
                --- @type "right"
                position = "right",
                -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
                reopen = true,
            },
            -- @link https://github.com/nvim-treesitter/playground
            TSPlayground = {
                -- The position of the tree.
                --- @type "right"|"left"
                position = "right",
                -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
                reopen = true,
            },
            -- @link https://github.com/rcarriga/nvim-dap-ui
            NvimDAPUI = {
                -- The position of the tree.
                --- @type "none"
                position = "none",
                -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
                reopen = true,
            },
            -- @link https://github.com/hedyhli/outline.nvim
            outline = {
                -- The position of the tree.
                --- @type "left"|"right"
                position = "right",
                -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
                reopen = true,
            },
        },
    },
})
