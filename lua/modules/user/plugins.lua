local conf = require("modules.user.config")
local user = require("core.pack").package

-- TODO(vsedov) (00:11:22 - 13/08/22): Temp plugin

-- TODO: (vsedov) (09:02:43 - 29/08/22): https://github.com/luk400/vim-jukit set this thing up,
-- looks very nice to have .

user({
    "p00f/cphelper.nvim",
    cmd = {
        "CphReceive",
        "CphTest",
        "CphReTest",
        "CphEdit",
        "CphDelete",
    },
    config = function()
        vim.g["cph#lang"] = "python"
        vim.g["cph#border"] = lambda.style.border.type_0
    end,
})

user({

    "Saverio976/music.nvim",
    requires = { "voldikss/vim-floaterm" },
    opt = true,
    cmd = {
        "PlayMusic",
        "PlayCustom",
        "MusicPlay",
        "MusicPlayVideo",
        "MusicNext",
        "MusicPrev",
        "MusicShuffle",
        "MusicUnShuffle",
        "MusicQueue",
        "MusicAllPlaylist",
    },
    run = ":MusicInstall",
    config = function()
        local playlist_list_table = {
            Main = { "https://youtube.com/playlist?list=PLefUWboWnSEAWXaxHfHvUXolulEnv1mC3" },
            Background = { "https://youtube.com/playlist?list=PLefUWboWnSEAcmPIC8XdNZM5gWEejXJJN" },
            Yui = { "https://youtube.com/playlist?list=PLefUWboWnSEDGxFVyD6E_elkHmXxHQOu5" },
        }

        local completion = function(_, _, _)
            local list = {}
            for k, _ in pairs(playlist_list_table) do
                table.insert(list, k)
            end
            return list
        end
        lambda.command("PlayCustom", function(music_type)
            local music_type = music_type or {}
            if music_type == {} or playlist_list_table[music_type.args] == nil then
                music_type.args = "Main"
            end
            vim.cmd("PlayMusic " .. playlist_list_table[music_type.args][1])
            vim.cmd("FloatermToggle")
        end, { nargs = "*", complete = completion })
    end,
})

user({
    "samjwill/nvim-unception",
    opt = true,
    setup = function()
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
    "gorbit99/codewindow.nvim",
    opt = true,
    cmd = { "CodeMiniMapOpen", "CodeMiniMapClose", "CodeMiniMapToggle", "CodeMiniMapToggleFocus" },
    setup = function()
        lambda.lazy_load({
            events = "FileType",
            pattern = { "lua", "python" },
            augroup_name = "codewindow",
            condition = lambda.config.use_code_window,
            plugin = "codewindow.nvim",
        })
    end,
    config = function()
        require("utils.ui.highlights").plugin("codewindow", {
            { CodewindowBorder = { link = "WinSeparator" } },
            { CodewindowWarn = { bg = "NONE", fg = { from = "DiagnosticSignWarn", attr = "bg" } } },
            { CodewindowError = { bg = "NONE", fg = { from = "DiagnosticSignError", attr = "bg" } } },
        })
        require("codewindow").setup({
            z_index = 25,
            auto_enable = true,
            minimap_width = 10,
            exclude_filetypes = {
                "qf",
                "git",
                "help",
                "alpha",
                "packer",
                "gitcommit",
                "NeogitStatus",
                "neo-tree",
                "neo-tree-popup",
                "NeogitCommitMessage",
                "harpoon",
                "memento",
            },
        })
        local codewindow = require("codewindow")
        lambda.command("CodeMiniMapOpen", codewindow.open_minimap, {})
        lambda.command("CodeMiniMapClose", codewindow.close_minimap, {})
        lambda.command("CodeMiniMapToggle", codewindow.toggle_minimap, {})
        lambda.command("CodeMiniMapToggleFocus", codewindow.toggle_focus, {})
    end,
})

--  TODO: (vsedov) (12:12:33 - 08/11/22): I do not think i need this
user({
    "nvim-zh/colorful-winsep.nvim",
    setup = function()
        lambda.lazy_load({
            events = "BufWinEnter",
            augroup_name = "winsep",
            condition = false,

            plugin = "colorful-winsep.nvim",
        })
    end,
    config = function()
        require("colorful-winsep").setup({})
    end,
})

user({
    "glepnir/hlsearch.nvim",
    setup = function()
        lambda.lazy_load({
            events = "BufRead",
            augroup_name = "hlsearch",
            condition = false,

            plugin = "hlsearch.nvim",
        })
    end,
    config = function()
        require("hlsearch").setup()
    end,
})

-- user({
--     "samodostal/copilot-client.lua",
--     requires = {
--         "zbirenbaum/copilot.lua", -- requires copilot.lua and plenary.nvim
--         "nvim-lua/plenary.nvim",
--     },
--     config = function()
--         require("copilot").setup({
--             cmp = {
--                 enabled = false, -- no need for cmp
--             },
--         })

--         require("copilot-client").setup({
--             mapping = {
--                 accept = "<CR>",
--             },
--         })
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
    opt = true,
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

-- about time .
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
