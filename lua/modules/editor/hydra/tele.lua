local Hydra = require("hydra")

local hint_telescope = [[
  ^^     Git         ^^^^           Grep[G]           ^^^^
  ^^---------------  ^^^^-------------------------------^^^^  
  _g_: Git Files      _w_: G string  _lw_: last G    
  _u_: Git Diff       _W_: live G    _vw_: visual G 
  ^^^^-------------------------------------------------^^^^
  ^^ Register and Buffer^^         Commands              
  ^^--------------------^^----------------------------^^^^
  _r_: registers          _/_: Search His _o_: oldfiles
  _b_: Change             _c_: Com His    _k_: keymaps
  _j_: Jump               _m_: commands   _<Enter>_: Tele
  ^^^^-------------------------------------------------^^^^
  ^^^^                     Files                       ^^^^
  ^^^^-------------------------------------------------^^^^
  _f_: Find Files                   _s_: find string  
  _F_: Files                        _t_: search file     
  _b_: browse files                 _d_: DotFiles    
 
  _z_ zoxide      _q_ exit

]]

local telescope = require("telescope")

Hydra({
    hint = hint_telescope,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "rounded",
        },
    },
    mode = "n",
    body = "<leader>f",
    heads = {
        -- git
        { "g", ":Telescope git_files<CR>", { exit = true } },
        { "u", require("utils.telescope").git_diff, { exit = true } },

        -- -- -- register and buffer
        { "r", ":Telescope registers<CR>", { exit = true } },
        { "b", ":Telescope buffers CHANGE<CR>", { exit = true } },
        { "j", require("utils.telescope").jump, { exit = true } },
        -- grep
        { "w", ":Telescope grep_string<CR>", { exit = true } }, -- grep string
        { "W", [['<cmd>lua require"telescope.builtin".live_grep()<cr>' . expand('<cword>')]], { exit = true } }, -- Live
        { "lw", require("telescope.builtin").grep_last_search, { exit = true } }, -- grep last search
        { "vw", require("telescope.builtin").grep_string_visual, { exit = true } }, -- grep_string_visual

        -- -- -- commands
        { "/", ":Telescope search_history<CR>", { exit = true } },
        { "c", ":Telescope command_history<CR>", { exit = true } },
        { "m", ":Telescope commands<CR>", { exit = true } },
        { "o", ":Telescope oldfiles<CR>", { exit = true } },
        { "k", ":Telescope keymaps<CR>", { exit = true } },
        { "<Enter>", "<cmd>Telescope<CR>", { exit = true } },
        { "q", nil, { exit = true, nowait = true } },

        -- -- files
        { "f", require("utils.telescope").find_files, { exit = true } },
        { "F", require("utils.telescope").file, { exit = true } },
        { "s", require("utils.telescope").find_string, { exit = true } },
        { "t", require("utils.telescope").search_only_certain_files, { exit = true } },
        { "b", require("utils.telescope").file_browser, { exit = true } },
        { "d", require("utils.telescope").load_dotfiles, { exit = true } },
        { "z", telescope.extensions.zoxide.list },
    },
})
