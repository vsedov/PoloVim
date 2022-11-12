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

--  TODO: (vsedov) (12:12:33 - 08/11/22): I do not think i need this
-- user({
-- "nvim-zh/colorful-winsep.nvim",
-- setup = function()
--     lambda.lazy_load({
--         events = "BufWinEnter",
--         augroup_name = "winsep",
--         plugin = "colorful-winsep.nvim",
--     })
-- end,
-- config = function()
--     require("colorful-winsep").setup({})
-- end,
-- })

user({
    "rgroli/other.nvim",
    config = function()
        require("other-nvim").setup({
            mappings = {
                -- builtin mappings
                "livewire",
                "angular",
                "laravel",
                "rails",
                -- custom mapping
                {
                    pattern = "/path/to/file/src/app/(.*)/.*.ext$",
                    target = "/path/to/file/src/view/%1/",
                    transformer = "lowercase",
                },
            },
            transformers = {
                -- defining a custom transformer
                lowercase = function(inputString)
                    return inputString:lower()
                end,
            },
            style = {
                -- How the plugin paints its window borders
                -- Allowed values are none, single, double, rounded, solid and shadow
                border = "solid",

                -- Column seperator for the window
                seperator = "|",

                -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
                width = 0.7,

                -- min height in rows.
                -- when more columns are needed this value is extended automatically
                minHeight = 2,
            },
        })

        vim.api.nvim_set_keymap("n", "_ll", "<cmd>:Other<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "_lp", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "_lv", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "_lc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

        -- Context specific bindings
        vim.api.nvim_set_keymap("n", "_lt", "<cmd>:Other test<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "_ls", "<cmd>:Other scss<CR>", { noremap = true, silent = true })
    end,
})
user({
    "samodostal/copilot-client.lua",
    opt = true,
    keys = {
        { "i", "<c-]" },
    },
    requires = {
        "zbirenbaum/copilot.lua", -- requires copilot.lua and plenary.nvim
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("copilot").setup({
            cmp = {
                enabled = false, -- no need for cmp
            },
        })

        require("copilot-client").setup({
            mapping = {
                accept = "<CR>",
                -- Next and previos suggestions to be added
                -- suggest_next = '<C-n>',
                -- suggest_prev = '<C-p>',
            },
        })

        -- Create a keymap that triggers the suggestion. To accept suggestion press <CR> as set in the setup.
        vim.api.nvim_set_keymap(
            "i",
            "<C-]>",
            '<cmd>lua require("copilot-client").suggest()<CR>',
            { noremap = true, silent = true }
        )
    end,
})
