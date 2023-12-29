local Hydra = require("hydra")

local hint_telescope = [[
 ^^      Git         ^^^^           Surfing               ^^^^
 ^^^^                                                     ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▕ ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  _g_: Git Files       ▕    _w_: live G    _a_: AG
  _u_: Git Diff        ▕    _W_: CurBuf    _E_: L grep ++
  _S_: Git Status      ▕    _z_: zoxide    _e_: Ast Surf
  _h_: Git Conflict    ▕    _l_: Lsp       _M_: Marks
                     ▕
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▕ ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
 ^^ Register and Buffer^^▕             Commands
 ^^^^                    ▕                                ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▕ ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
  _r_: registers       ▕   _/_: Search His _o_: oldfiles
  _R_: reloader        ▕   _c_: Com His    _k_: keymaps
  _j_: Jump            ▕   _m_: commands   _<Enter>_: Tele
                     ▕
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
 ^^^^                       Files                         ^^^^
 ^^^^                                                     ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
  _>_: TfmVsplit                    _F_: TfmTabedit
  _<_: TfmSplit                     _f_: Tfmload
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
  _1_: Find Files                   _s_: find string
  _2_: Files                        _t_: search file
  _b_: browse files                 _d_: DotFiles

 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
 ^^^^                 Frecency/BookMarks                  ^^^^
 ^^^^                                                     ^^^^
 ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ ^^^^
  _<Space>_: Frec     _\\_: FrecCWD     _B_: BookMarks
                      _]_:  Smart Open

                          _T_: EP
  _q_ exit _<Esc>_ exit

]]

local function rectangular_border(opts)
    return vim.tbl_deep_extend("force", opts or {}, {
        borderchars = {
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
    })
end
local function dropdown(opts)
    return require("telescope.themes").get_dropdown(rectangular_border(opts))
end

Hydra({
    name = "Tele",
    hint = hint_telescope,
    config = {
        color = "teal",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
        },
    },
    mode = { "n" },
    body = "<leader>f",
    heads = {
        -- git
        { "g", ":Telescope git_files<CR>", { exit = true } },
        {
            "u",
            function()
                require("modules.search.telescope.telescope_commands").git_diff()
            end,
            { exit = true },
        },
        {

            "S",
            function()
                require("modules.search.telescope.telescope_commands").git_status()
            end,
            { exit = true },
        },
        {
            "h",
            function()
                require("modules.search.telescope.telescope_commands").git_conflicts()
            end,
            { exit = true },
        },

        -- -- -- register and buffer
        { "r", ":Telescope registers<CR>", { exit = true } },
        {
            "j",
            function()
                require("modules.search.telescope.telescope_commands").jump()
            end,
            { exit = true },
        },

        -- grep -- need to change this

        {
            "a",
            function()
                lambda.clever_tcd()
                vim.defer_fn(function()
                    vim.ui.input({ prompt = "Silver Surfer", default = "" }, function(item)
                        if item == "" then
                            require("modules.search.telescope.telescope_commands").ag()
                        else
                            require("modules.search.telescope.telescope_commands").ag(tostring(item))
                        end
                    end)
                end, 100)
            end,
            { exit = true },
        },
        {
            -- "Tfm",
            -- "TfmSplit",
            -- "TfmVsplit",
            -- "TfmTabedit",
            ">",
            function()
                vim.cmd.TfmVsplit()
            end,
            { desc = "TfmVsplit", exit = true },
        },
        {
            "<",
            function()
                vim.cmd.TfmSplit()
            end,
            { desc = "TfmSplit", exit = true },
        },
        {
            "f",
            function()
                vim.cmd.Tfm()
            end,
            { desc = "Tfm", exit = true },
        },
        {
            "F",
            function()
                vim.cmd.TfmTabedit()
            end,
            { desc = "TfmTabedit", exit = true },
        },

        {
            "w",

            function()
                require("modules.search.telescope.telescope_commands").egrep()
            end,

            { desc = "egrepify", exit = true },
        }, -- grep string
        {
            "W",
            function()
                require("modules.search.telescope.telescope_commands").curbuf()
            end,
            { exit = true },
        }, -- pass
        { "l", require("telescope.builtin").lsp_dynamic_workspace_symbols, { exit = true } }, -- pass
        { "e", ":Telescope ast_grep<cr>", { exit = true } }, -- pass
        { "E", require("telescope").extensions.live_grep_args.live_grep_args, { exit = true } }, -- pass

        -- misc
        { "p", ":Telescope workspaces<CR>", { exit = true } }, -- pass
        { "M", ":Telescope marks<CR>", { exit = true } }, -- pass

        { "B", ":Telescope bookmarks<cr>", { exit = true } }, -- pass

        -- -- -- commands
        { "/", ":Telescope search_history<CR>", { exit = true } },
        {
            "c",
            function()
                require("modules.search.telescope.telescope_commands").command_history()
            end,
            { exit = true },
        },
        { "m", ":Telescope commands<CR>", { exit = true } },
        { "o", ":Telescope oldfiles<CR>", { exit = true } },
        { "k", ":Telescope keymaps<CR>", { exit = true } },
        { "R", ":Telescope reloader<CR>", { exit = true } },
        { "<Enter>", "<cmd>Telescope<CR>", { exit = true } },
        { "T", "<cmd>Easypick command_palette<CR>", { exit = true } },
        {
            "<Space>",
            function()
                require("telescope").extensions.frecency.frecency()
            end,
            { exit = true },
        },
        { "\\", ":Telescope frecency workspace=CWD<CR>", { exit = true } },
        {
            "]",
            require("telescope").extensions.smart_open.smart_open,
            { exit = true },
        },

        { "q", nil, { exit = true, nowait = true } },
        { "<Esc>", nil, { exit = true, nowait = true } },

        -- -- files
        {
            "1",
            function()
                require("modules.search.telescope.telescope_commands").find_files()
            end,
            { exit = true },
        },
        {
            "2",
            function()
                require("modules.search.telescope.telescope_commands").files()
            end,
            { exit = true },
        },
        {
            "s",
            function()
                require("modules.search.telescope.telescope_commands").find_string()
            end,
            { exit = true },
        },
        {
            "t",
            function()
                require("modules.search.telescope.telescope_commands").search_only_certain_files()
            end,
            { exit = true },
        },
        {
            "b",
            function()
                require("modules.search.telescope.telescope_commands").file_browser()
            end,
            { exit = true },
        },
        {
            "d",
            function()
                require("modules.search.telescope.telescope_commands").load_dotfiles()
            end,
            { exit = true },
        },
        {
            "z",
            function()
                require("telescope").extensions.zoxide.list()
            end,
        },
    },
})
