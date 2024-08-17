local conf = require("lazy_specs.ui.config")
local highlight, foo, falsy, augroup = lambda.highlight, lambda.style, lambda.falsy, lambda.augroup
local border, rect = foo.border.type_0, foo.border.type_0
local icons = lambda.style.icons
-- nvim-ufo = "1.4.0"
-- "dropbar.nvim" = "8.6.0"
-- "heirline.nvim" = "1.0.6"
-- "fidget.nvim" = "1.4.1"
-- promise-async = "scm"
-- "hlchunk.nvim" = {rev ="1.1.0", opt = true}
-- "indent-blankline.nvim" = "3.7.2"
-- nvim-window-picker = "2.0.3"
-- "neo-tree.nvim" = "3.26"
-- nvim-web-devicons= "0.100"
-- "nui.nvim" = "0.3.0"
-- "dressing.nvim" = "2.2.2"
return {
    {

        "nvim-ufo",
        event = "DeferredUIEnter",
        cmd = {
            "UfoAttach",
            "UfoDetach",
            "UfoEnable",
            "UfoDisable",
            "UfoInspect",
            "UfoEnableFold",
            "UfoDisableFold",
        },
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "ufo: open all folds",
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
            },
            {
                "zr",
                function()
                    require("ufo").openFoldsExceptKinds()
                end,
                desc = "ufo: open folds except kinds",
            },
            {
                "zm",
                function()
                    require("ufo").closeFoldsWith()
                end,
                desc = "ufo: close folds with",
            },
        },
        after = conf.ufo,
    },
    {
        "foldcus.nvim",
        cmd = { "Foldcus", "Unfoldcus" },
        keys = { "z;", "z\\" },
        load = function(name)
            rocks.safe_packadd({ name, "nvim-treesitter" })
        end,
        after = conf.fold_focus,
    },
    {
        "vim-illuminate",
        event = "DeferredUIEnter",
        after = conf.illuminate,
    },
    {
        "fold-cycle.nvim",
        event = "DeferredUIEnter",
        keys = {
            {
                "<BS>",
                function()
                    require("fold-cycle").open()
                end,
                desc = "fold-cycle: toggle",
                silent = true,
            },
            {
                "<C-<BS>>",
                function()
                    require("fold-cycle").close()
                end,
                desc = "fold-cycle: toggle",
                silent = true,
            },
            {
                "zC",
                function()
                    require("fold-cycle").close_all()
                end,
                desc = "fold-cycle: Close all ",
                remap = true,
            },
        },
        after = function()
            require("fold-cycle").setup()
        end,
    },
    {
        "hlchunk.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("hlchunk").setup({
                indent = {
                    chars = { "│", "¦", "┆", "┊" }, -- more code can be found in https://unicodeplus.com/
                },
                chunk = {
                    enable = true,
                    use_treesitter = true,
                    notify = true, -- notify if some situation(like disable chunk mod double time)
                    exclude_filetypes = {
                        glowpreview = true,
                        harpoon = true,
                        aerial = true,
                        dropbar_menu = true,
                        dashboard = true,
                        sagaoutline = true,
                        oil_preview = true,
                        oil = true,
                        ["neo-tree"] = true,
                    },
                },
                blank = {
                    enable = false,
                },
            })
        end,
    },
}
