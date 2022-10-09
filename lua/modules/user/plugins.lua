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
    "samuzora/pet.nvim",
    opt = true,
    setup = function()
        lambda.setup_plugin("BufEnter", "pet.nvim", lambda.config.use_pet)
    end,
    config = function()
        require("pet-nvim")
    end,
})

user({
    -- for packer.nvim
    "delphinus/dwm.nvim",
    -- branch = "feature/refactor",
    opt = true,
    keys = {
        "_j",
        "_k",
        "_<CR>",
        "_@",
        "_<leader>",
        "_l",
        "_h",
        "_n",
        "_q",
        "_s",
        "_c",
    },
    config = function()
        local dwm = require("dwm")
        dwm.setup({
            key_maps = false,
            master_pane_count = 1,
            master_pane_width = "60%",
        })
        vim.keymap.set("n", "_j", "<C-w>w")
        vim.keymap.set("n", "_k", "<C-w>W")
        vim.keymap.set("n", "_<CR>", dwm.focus, { desc = "focus" })
        vim.keymap.set("n", "_@", dwm.focus, { desc = "focus" })
        vim.keymap.set("n", "_<leader>", dwm.focus, { desc = "focus" })
        vim.keymap.set("n", "_l", dwm.grow, { desc = "grow" })
        vim.keymap.set("n", "_h", dwm.shrink, { desc = "shrink" })
        vim.keymap.set("n", "_n", dwm.new, { desc = "new" })
        vim.keymap.set("n", "_q", dwm.rotateLeft, { desc = "rotate left" })
        vim.keymap.set("n", "_s", dwm.rotate, { desc = "rotate" })
        vim.keymap.set("n", "_c", function()
            vim.notify("closing!", vim.log.levels.INFO)
            dwm.close()
        end, { desc = "close dwm" })
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

-- PlayMusic (path of file/folder)|(url link)|(keywords search)
-- open a terminal and run mpv to play only the sound
--     MusicPlay (path of file/folder)|(url link)|(keywords search)
-- open a terminal and run mpv to play only the sound
--     MusicPlayVideo (path of file/folder)|(url link)|(keywords search)
-- open a terminal and run mpv to play the sound + video
--     MusicNext
-- pass to the next music (or stop it if not a playlist)
--     MusicPrev
-- pass to the previous music (if playlist)
--     MusicShuffle
-- shuffle the playlist
--     MusicUnShuffle
-- unshuffle the playlist
--     MusicQueue
-- show queue
--     MusicAllPlaylist
user({ "voldikss/vim-floaterm" })

user({

    "Saverio976/music.nvim",
    requires = "voldikss/vim-floaterm",
    run = ":MusicInstall",
    config = function()
        lambda.command("PlayMain", function()
            vim.cmd("PlayMusic https://youtube.com/playlist?list=PLefUWboWnSEAWXaxHfHvUXolulEnv1mC3")
            vim.cmd("FloatermToggle")
        end, {})
    end,
})

-- :Bufala {subcommand} {arguments...}

-- There are a few subcommands:
--     [{count} cycle] moves through buffer windows with an optional count.
--     [focus swaps] the current buffer window with the first or main buffer window.
--     [split {direction} {target}] opens a new buffer window with an optional direction and target. Valid directions are up, down, left, and right. If no direction is given, Bufala will either abort or split based on the layout configured in the setup function (see below). The target is whatever you would put in a :buffer {target} command.
--     [swap swaps] the current buffer window with last buffer window you were in.

user({
    "https://github.com/nat-418/bufala.nvim",
    setup = function()
        lambda.setup_plugin("BufEnter", "bufala.nvim", true)
    end,
    cmd = { "bufala" },
    config = function()
        require("bufala").setup({
            layout = "stack", -- optional, valid values are 'stack' and 'row'
        })
    end,
})
-- Lua
user({
    "abecodes/tabout.nvim",
    config = function()
        require("tabout").setup({
            tabkey = "<C-k>",
            backwards_tabkey = "<C-j>",
            act_as_tab = true, -- shift content if tab out is not possible
            act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
            default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
            default_shift_tab = "<C-D>", -- reverse shift default action,
            enable_backwards = true, -- well ...
            completion = true, -- if the tabkey is used in a completion pum
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
            },
            ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
            exclude = {}, -- tabout will ignore these filetypes
        })
    end,
    wants = { "nvim-treesitter" }, -- or require if not used so far
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
})
