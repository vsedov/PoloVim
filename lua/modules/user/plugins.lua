local conf = require("modules.user.config")
local user = require("core.pack").package

-- True emotional Support
user({ "rtakasuke/vim-neko", cmd = "Neko", opt = true })

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

--  REVISIT: (vsedov) (21:41:00 - 10/10/22): I have this plugin
--  But i have no clue what this does, or what the point of this is .
user({
    "m-gail/escape.nvim",
    opt = true,
    keys = {
        { "v", "<leader>e" },
    },
    config = function()
        local sc = require("escape")
        vim.keymap.set("v", "<leader>e", sc.escape, { noremap = true, silent = true })
    end,
})
