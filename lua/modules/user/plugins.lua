local conf = require("modules.user.config")
local user = require("core.pack").package

-- TODO(vsedov) (00:11:22 - 13/08/22): Temp plugin

-- TODO: (vsedov) (09:02:43 - 29/08/22): https://github.com/luk400/vim-jukit set this thing up,
-- looks very nice to have .

user({
    "luk400/vim-jukit",
    opt = true,
    config = function()
        vim.g.jukit_terminal = "kitty"
        vim.cmd([[
        let g:jukit_layout = {
            \'split': 'horizontal',
            \'p1': 0.6,
            \'val': [
                \'file_content',
                \{
                    \'split': 'vertical',
                    \'p1': 0.6,
                    \'val': ['output', 'output_history']
                \}
            \]
        \}
        fun! DFColumns()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = visual_selection . '.columns'
            call jukit#send#send_to_split(cmd)
        endfun
        vnoremap C :call DFColumns()<cr>

        fun! PythonHelp()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = 'help(' . visual_selection . ')'
            call jukit#send#send_to_split(cmd)
        endfun
        vnoremap H :call PythonHelp()<cr>
        ]])
    end,
})

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
            events = "FileType",
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

user({
    "ziontee113/query-secretary",
    opt = true,
    cmd = { "QueryTree" },
    config = function()
        require("query-secretary").setup({
            open_win_opts = {
                row = 0,
                col = 9999,
                width = 50,
                height = 15,
            },

            -- other options you can customize
            buf_set_opts = {
                tabstop = 2,
                softtabstop = 2,
                shiftwidth = 2,
            },

            capture_group_names = { "cap", "second", "third" }, -- when press "c"
            predicates = { "eq", "any-of", "contains", "match", "lua-match" }, -- when press "p"
            visual_hl_group = "Visual", -- when moving cursor around

            -- here are the default keymaps
            keymaps = {
                close = { "q", "Esc" },
                next_predicate = { "p" },
                previous_predicate = { "P" },
                remove_predicate = { "d" },
                toggle_field_name = { "f" },
                yank_query = { "y" },
                next_capture_group = { "c" },
                previous_capture_group = { "C" },
            },
        })
        lambda.command("QueryTree", function()
            require("query-secretary").query_window_initiate()
        end, {})
    end,
})

user({
    "nvim-zh/colorful-winsep.nvim",
    setup = function()
        lambda.lazy_load({
            events = "BufWinEnter",
            augroup_name = "winsep",
            condition = true,
            plugin = "colorful-winsep.nvim",
        })
    end,
    config = function()
        require("colorful-winsep").setup({})
    end,
})

user({
    "hrsh7th/vim-gindent",
    ft = { "python", "php", "vim" },
    config = function()
        vim.cmd([[
let g:gindent = {}
let g:gindent.enabled = { -> index(['vim', 'php','python'], &filetype) != -1 }
        ]])
    end,
})
