local Hydra = require("hydra")

local hint_telescope = [[
  ^^     Git         ^^^^           Surfing             ^^^^
  ^^---------------  ^^^^-------------------------------^^^^  
  _g_: Git Files      _w_: live G    _a_: Silver Surf 
  _u_: Git Diff       _W_: CurBuf    _p_: Workspaces/project
  _S_: Git Status     _z_: zoxide    _M_: Marks 
  _h_: Git Conflict   _l_: Lsp       
  ^^^^-------------------------------------------------^^^^
  ^^ Register and Buffer^^         Commands              
  ^^--------------------^^----------------------------^^^^
  _r_: registers          _/_: Search His _o_: oldfiles
  _R_: reloader           _c_: Com His    _k_: keymaps
  _j_: Jump               _m_: commands   _<Enter>_: Tele
  ^^^^-------------------------------------------------^^^^
  ^^^^                     Files                       ^^^^
  ^^^^-------------------------------------------------^^^^
  _f_: Find Files                   _s_: find string  
  _F_: Files                        _t_: search file     
  _b_: browse files                 _d_: DotFiles    
 
  _q_ exit

]]

local telescope = require("telescope")

Hydra({
    hint = hint_telescope,
    config = {
        color = "teal",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "single",
        },
    },
    mode = { "n", "x" },
    body = "<leader>f",
    heads = {
        -- git
        { "g", ":Telescope git_files<CR>", { exit = true } },
        { "u", require("utils.telescope").git_diff, { exit = true } },
        { "S", require("utils.telescope").git_status, { exit = true } },
        { "h", require("utils.telescope").git_conflicts, { exit = true } },

        -- -- -- register and buffer
        { "r", ":Telescope registers<CR>", { exit = true } },
        { "a", require("utils.telescope").ag, { exit = true } },
        { "j", require("utils.telescope").jump, { exit = true } },

        -- grep -- need to change this
        { "w", ":Telescope grep_string<CR>", { exit = true } }, -- grep string
        { "W", require("utils.telescope").curbuf, { exit = true } }, -- pass
        { "l", require("telescope.builtin").lsp_dynamic_workspace_symbols, { exit = true } }, -- pass
        -- { "e", require("utils.telescope").folder_grep, { exit = true } }, -- pass

        -- misc
        { "p", ":Telescope Workspaces<CR>", { exit = true } }, -- pass
        { "M", ":Telescope marks<CR>", { exit = true } }, -- pass

        -- -- -- commands
        { "/", ":Telescope search_history<CR>", { exit = true } },
        { "c", require("utils.telescope").command_history, { exit = true } },
        { "m", ":Telescope commands<CR>", { exit = true } },
        { "o", ":Telescope oldfiles<CR>", { exit = true } },
        { "k", ":Telescope keymaps<CR>", { exit = true } },
        { "R", ":Telescope reloader<CR>", { exit = true } },
        { "<Enter>", "<cmd>Telescope<CR>", { exit = true } },
        { "q", nil, { exit = true, nowait = true } },

        -- -- files
        { "f", require("utils.telescope").find_files, { exit = true } },
        { "F", require("utils.telescope").files, { exit = true } },
        { "s", require("utils.telescope").find_string, { exit = true } },
        { "t", require("utils.telescope").search_only_certain_files, { exit = true } },
        { "b", require("utils.telescope").file_browser, { exit = true } },
        { "d", require("utils.telescope").load_dotfiles, { exit = true } },
        { "z", telescope.extensions.zoxide.list },
    },
})

-- require("telescope.builtin").current_buffer_fuzzy_find()
