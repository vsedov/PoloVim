local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
-- local map_key = bind.map_key
-- local global = require("core.global")

local plug_map = {
    -- Show syntax highlighting groups for word under cursor
    ["n|<localleader>c["] = map_cmd(function()
        local c = vim.api.nvim_win_get_cursor(0)
        local stack = vim.fn.synstack(c[1], c[2] + 1)
        for i, l in ipairs(stack) do
            stack[i] = vim.fn.synIDattr(l, "name")
        end
        Log:info(vim.inspect(stack))
    end):with_silent(),

    ["n|<localleader>c]"] = map_cmd(function()
        if vim.fn["copilot#Enabled"]() == 1 then
            print("Copilot is now being disabled")
            vim.cmd([[ Copilot disable ]])
        else
            print("Copilot is now being enabled")
            vim.cmd([[ Copilot enable ]])
        end
        vim.cmd([[ Copilot status ]])
    end):with_silent(),

    -- Venv
    ["n|<localleader>V"] = map_cmd(function()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
            print("Venn active")
            vim.b.venn_enabled = true
            vim.cmd([[setlocal ve=all]])
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
            print("Venn inactive")

            vim.cmd([[setlocal ve=]])
            vim.cmd([[mapclear <buffer>]])
            vim.b.venn_enabled = nil
        end
    end):with_silent(),

    --------------- Commands -----------
    ["n|<CR>"] = map_cmd("<cmd>NeoZoomToggle<CR>"):with_noremap():with_silent():with_nowait(),
    ["n|<C-]>"] = map_args("Template"),

    -- -- ["n|mf"]             = map_cr("<cmd>lua require('internal.fsevent').file_event()<CR>"):with_silent():with_nowait():with_noremap();
    -- have this for the time, i might use some root , not usre .
    ["n|<leader>cd"] = map_cmd("<cmd>cd %:p:h<CR>:pwd<CR>"):with_noremap():with_silent(),

    -- -- Plugin nvim-tree
    ["n|<Leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
    ["n|<Leader>F"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent(),

    -- -- Code actions ?
    ["n|<Leader>cw"] = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),
    -- no longer work .
    ["n|ga"] = map_cmd("<Cmd>CodeActionMenu<cr>"):with_noremap():with_silent(),
    ["v|ga"] = map_cmd("<cmd>CodeActionMenu<Cr>"):with_noremap():with_silent(),

    -- Back up .
    ["n|<Leader>ca"] = map_cu("<cmd>lua vim.lsp.buf.code_action()<CR>"):with_noremap():with_silent(),
    ["n|gA"] = map_cmd("<cmd>Lspsaga code_action<CR>"):with_noremap():with_silent(),
    ["n|<localleader>D"] = map_cmd(
        '<cmd>lua require"modules.completion.lsp.utils.peek".toggle_diagnostics_visibility()<CR>'
    )
        :with_noremap()
        :with_silent(),
    ["n|gd"] = map_cmd([[<cmd>lua require"modules.completion.lsp.utils.peek".Peek('definition')<CR>]])
        :with_noremap()
        :with_silent(),

    -- no longer works
    ["n|dpj"] = map_cmd('<cmd>lua require"modules.completion.lsp.utils.peek".PeekTypeDefinition()<CR>')
        :with_noremap()
        :with_silent(),

    ["n|dpk"] = map_cmd('<cmd>lua require"modules.completion.lsp.utils.peek".PeekImplementation()<CR>')
        :with_noremap()
        :with_silent(),

    ["n|<Leader>gr"] = map_cmd("<cmd>Lspsaga rename<CR>"):with_noremap():with_silent(),

    ["n|gpd"] = map_cu("GotoPrev"):with_noremap(),
    ["n|gpi"] = map_cu("GotoImp"):with_noremap(),
    ["n|gpt"] = map_cu("GotoTel"):with_noremap(),

    -- -- Goto prev mapping
    --- WARNING THERE COULD BE AN ISSUE WITH THIS>
    -- --

    -- -- never go wrong with clap
    -- Figure out the error with clap, giving very annoying error j
    ["n|<F1>"] = map_cr("Clap"):with_noremap():with_silent(),

    ["n|<F2>"] = map_cu("MundoToggle"):with_noremap():with_silent(),
    ["n|<Leader><F2>"] = map_cu("UndotreeToggle"):with_noremap():with_silent(),

    -- -- Plugin MarkdownPreview
    ["n|<Leader>om"] = map_cu("MarkdownPreview"):with_noremap():with_silent(),
    -- Plugin DadbodUI
    ["n|<Leader>od"] = map_cr("DBUIToggle"):with_noremap():with_silent(),

    -- -- Plugin Telescope
    ["v|<Leader>ga"] = map_cmd("<cmd>lua require('utils.telescope').code_actions()<CR>"):with_noremap():with_silent(),

    ["n|<Leader>qf"] = map_cu("Telescope lsp_workspace_diagnostics"):with_noremap():with_silent(),

    ["n|<Leader>bb"] = map_cu("Telescope buffers"):with_noremap():with_silent(),
    ["n|<Leader><C-r>"] = map_cu("Telescope registers"):with_noremap():with_silent(),
    ["n|<Leader>fr"] = map_cmd("<cmd>Telescope registers<cr>"):with_noremap():with_silent(),
    ["n|<Leader>fZ"] = map_cr('<cmd>lua require("telescope").extensions.zoxide.list()'):with_silent(),
    -- ["n|<Leader>fp"] = map_cr('<cmd>lua require("telescope").extensions.projects.projects()'):with_silent(),
    ["n|<Leader>fl"] = map_cu("Telescope loclist"):with_noremap():with_silent(),
    ["n|<Leader>fc"] = map_cu("Telescope git_commits"):with_noremap():with_silent(),
    ["n|<Leader>vv"] = map_cu("Telescope treesitter"):with_noremap():with_silent(),

    -- pretty neat

    -- Swap
    ["n|<leader>sw"] = map_cu("ISwapWith"):with_noremap():with_silent(),

    -- Extra telescope commands from utils.telescope
    ["n|<Leader>cl"] = map_cmd('<cmd>lua require"utils.telescope".neoclip()<CR>'):with_noremap():with_silent(),

    -- Focus
    ["n|<leader><leader>h"] = map_cmd("<cmd> lua require'focus'.split_command('h')<CR>"):with_silent(),
    ["n|<leader><leader>j"] = map_cmd("<cmd> lua require'focus'.split_command('j')<CR>"):with_silent(),
    ["n|<leader><leader>k"] = map_cmd("<cmd> lua require'focus'.split_command('k')<CR>"):with_silent(),
    ["n|<leader><leader>l"] = map_cmd("<cmd> lua require'focus'.split_command('l')<CR>"):with_silent(),

    ["n|<C-W><C-M>"] = map_cmd("<cmd>WinShift<CR>"):with_noremap(),
    ["n|<C-W>m"] = map_cmd("<cmd>WinShift<CR>"):with_noremap(),

    ["n|<C-W>X"] = map_cmd("<cmd>WinShift left<CR>"):with_noremap(),
    ["n|<C-M>H"] = map_cmd("<cmd>WinShift swap<CR>"):with_noremap(),
    ["n|<C-M>J"] = map_cmd("<cmd>WinShift down<CR>"):with_noremap(),
    ["n|<C-M>K"] = map_cmd("<cmd>WinShift up<CR>"):with_noremap(),
    ["n|<C-M>L"] = map_cmd("<cmd>WinShift right<CR>"):with_noremap(),

    -------------------------- Find

    ["n|<Leader>up"] = map_cmd('<cmd>lua require"utils.telescope".find_updir()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>ff"] = map_cmd('<cmd>lua require"utils.telescope".find_files()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fF"] = map_cmd('<cmd>lua require"utils.telescope".files()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fn"] = map_cmd('<cmd>lua require"utils.telescope".find_notes()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>fs"] = map_cmd('<cmd>lua require"utils.telescope".find_string()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>ft"] = map_cmd('<cmd>lua require"utils.telescope".search_only_certain_files()<CR>')
        :with_noremap()
        :with_silent(),

    ["n|hW"] = map_cmd('<cmd>lua require"utils.telescope".help_tags()<CR>'):with_noremap():with_silent(),
    ["n|hw"] = map_cmd(function()
        if require("dynamic_help.extras.statusline").available() ~= "" then
            require("dynamic_help").float_help(vim.fn.expand("<cword>"))
        else
            local help = vim.fn.input("Help Tag> ")
            require("dynamic_help").float_help(help)
        end
    end):with_noremap():with_silent(),

    -- grep
    ["n|<Leader>fW"] = map_cmd([['<cmd>lua require"telescope.builtin".live_grep()<cr>' . expand('<cword>')]])
        :with_expr()
        :with_silent(),

    ["n|<Leader>fw"] = map_cu("Telescope grep_string"):with_noremap():with_silent(),
    ["n|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_last_search()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>cb"] = map_cmd('<cmd>lua require"utils.telescope".curbuf()<CR>'):with_noremap():with_silent(),
    ["n|<Leader>gv"] = map_cmd('<cmd>lua require"utils.telescope".grep_string_visual()<CR>')
        :with_noremap()
        :with_silent(),

    -- git
    ["n|<Leader>fg"] = map_cu("Telescope git_files"):with_noremap():with_silent(),
    ["n|<Leader>fu"] = map_cmd('<cmd>lua require"utils.telescope".git_diff()<CR>'):with_noremap():with_silent(),

    ["n|<Leader>fb"] = map_cmd('<cmd>lua require("utils.telescope").file_browser()<cr>'):with_noremap():with_silent(),

    ["n|<Leader>ip"] = map_cmd('<cmd>lua require"utils.telescope".installed_plugins()<CR>')
        :with_noremap()
        :with_silent(),
    ["n|<Leader>ch"] = map_cmd('<cmd>lua require"utils.telescope".command_history()<CR>'):with_noremap():with_silent(),

    -- Dot files
    ["n|<Leader>fd"] = map_cmd('<cmd>lua require"utils.telescope".load_dotfiles()<CR>'):with_noremap():with_silent(),

    -- Jump
    ["n|<Leader>fj"] = map_cmd('<cmd>lua require"utils.telescope".jump()<CR>'):with_noremap():with_silent(),

    -- lsp implmentation with telescope
    ["n|<Leader>ir"] = map_cmd('<cmd>lua require"utils.telescope".lsp_references()<CR>'):with_noremap():with_silent(),

    -- Plugin Vista or SymbolsOutline -- Symbol Breaks for the time .
    ["n|<Leader>v"] = map_cu("Vista!!"):with_noremap():with_silent(),

    -- Plugin vim_niceblock
    ["x|I"] = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
    ["x|gI"] = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
    ["x|A"] = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),
    ["n|k"] = map_cmd([[v:count == 0 ? 'gk' : 'k']]):with_expr(),
    ["n|j"] = map_cmd([[v:count == 0 ? 'gj' : 'j']]):with_expr(),

    ["n||"] = map_cmd([[!v:count ? "<C-W>v<C-W><Right>" : '|']]):with_silent():with_expr(),
    ["n|_"] = map_cmd([[!v:count ? "<C-W>s<C-W><Down>"  : '_']]):with_silent():with_expr(),

    -- Plugin for debugigng

    -- git stuff
    ["n|<Leader>gt"] = map_cr(
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>'
    ):with_silent(),
    ["v|<Leader>gt"] = map_cr(
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>'
    ),
    ["n|<Leader>gY"] = map_cr('<cmd>lua require"gitlinker".get_repo_url()<cr>'):with_silent(),
    ["n|<Leader>gT"] = map_cr(
        '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>'
    ):with_silent(),

    -- -- Nice command to list all breakpoints. .
    -- ["n|<Leader>lb"] = map_cr("Telescope dap list_breakpoints"):with_noremap():with_silent(),

    ["n|<RightMouse>"] = map_cmd("<RightMouse><cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

    ["n|<C-ScrollWheelUp>"] = map_cmd("<C-i>"):with_noremap():with_silent(),
    ["n|<C-ScrollWheelDown>"] = map_cmd("<C-o>"):with_noremap():with_silent(),

    -- Alternate togller
    ["n|<Leader>ta"] = map_cr("ToggleAlternate"):with_noremap():with_silent(),

    -- TZAtaraxis
    ["n|<Leader><Leader>1"] = map_cu("ZenMode"):with_noremap():with_silent(),
    --- new
    ["n|<Leader>vf"] = map_cmd("<Plug>(ultest-run-file)"):with_silent(),
    ["n|<Leader>vn"] = map_cmd("<Plug>(ultest-run-nearest)"):with_silent(),
    ["n|<Leader>vg"] = map_cmd("<Plug>(ultest-output-jump)"):with_silent(),
    ["n|<Leader>vo"] = map_cmd("<Plug>(ultest-output-show)"):with_silent(),
    ["n|<Leader>vs"] = map_cmd("<Plug>(ultest-summary-toggle)"):with_silent(),
    ["n|<Leader>va"] = map_cmd("<Plug>(ultest-attach)"):with_silent(),
    ["n|<Leader>vx"] = map_cmd("<Plug>(ultest-stop-file)"):with_silent(),

    -- Quick Fix infomation and binds
    -- ["n|<Leader>xx"] = map_cr("<cmd>Trouble<CR>"):with_noremap():with_silent(),

    -- Change map for certain file types: remove this for local . .
    ["n|<F9>"] = map_cr('<cmd> lua require("nabla").action()<CR>'):with_noremap(),
    ["n|<localleader>b"] = map_cr('<cmd> lua require("nabla").popup()<CR>'):with_noremap(),
    -- Neogen
    ["n|<Leader>d"] = map_cr("lua require('neogen').generate()"):with_noremap():with_silent(),
    ["n|<Leader>dc"] = map_cr("lua require('neogen').generate({type = 'class'})"):with_noremap():with_silent(),
    ["n|<Leader>ds"] = map_cr("lua require('neogen').generate({type = 'type'})"):with_noremap():with_silent(),

    -- Spectre
    ["n|;e"] = map_cmd("<cmd>lua require('spectre').open()<CR>"):with_noremap(),
    ["n|;W"] = map_cmd("<cmd>lua require('spectre').open_visual({select_word=true})<CR>"):with_noremap(),
    ["n|;w"] = map_cu("Sad"):with_noremap():with_silent(),

    ["v|'v"] = map_cmd("<cmd>lua require('spectre').open_visual()<CR>"):with_noremap(),
    ["v|'c"] = map_cmd("<cmd>lua require('spectre').open_file_search()<CR>"):with_noremap(),

    -- visual search
    ["v|//"] = map_cmd([[y/<C-R>"<CR>]]):with_noremap(),
    -- repeat macro
    ["n|<leader><cr>"] = map_cmd([[empty(&buftype) ? '@@' : '<CR>']]):with_noremap():with_expr(),
    -- new files
    ["n|<localleader>ns"] = map_cmd([[:e <C-R>=expand("%:p:h") . "/" <CR>]]):with_silent(),
    ["n|<localleader>nf"] = map_cmd([[:vsp <C-R>=expand("%:p:h") . "/" <CR>]]):with_silent(),

    -- Refocus folds
    ["n|z<leader>"] = map_cmd([[zMzvzz]]):with_noremap(),
    ["n|z0"] = map_cmd([[zCzO]]):with_noremap(),
    ["n|zz"] = map_cmd([[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']])
        :with_noremap()
        :with_expr(),

    -- new lines
    ["n|[["] = map_cmd([[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]]):with_noremap(),
    ["n|]]"] = map_cmd([[<cmd>put =repeat(nr2char(10), v:count1)<cr>]]):with_noremap(),

    -- Replace word under cursor in Buffer (case-sensitive)
    -- nmap <leader>sr :%s/<C-R><C-W>//gI<left><left><left>
    ["n|<Leader>sr"] = map_cmd(":%s/<C-R><C-W>//gI<left><left><left>"),
    -- Replace word under cursor on Line (case-sensitive)
    -- nmap <leader>sl :s/<C-R><C-W>//gI<left><left><left>
    ["n|<Leader>sl"] = map_cmd(":s/<C-R><C-W>//gI<left><left><left>"),

    ["n|<leader>["] = map_cmd([[:%s/\<<C-r>=expand("<cword>")<CR>\>/]]):with_noremap(),
    ["v|<leader>]"] = map_cmd([["zy:%s/<C-r><C-o>"/]]):with_noremap(),

    -- Credit: JGunn Choi ?il | inner line
    ["x|al"] = map_cmd([[$o0]]):with_noremap(),
    ["o|al"] = map_cmd([[<cmd>normal val<CR>]]):with_noremap(),

    ["x|il"] = map_cmd([[<Esc>^vg_]]):with_noremap(),
    ["o|il"] = map_cmd([[<cmd>normal! ^vg_<CR>]]):with_noremap(),

    ["x|ie"] = map_cmd([[gg0oG$]]):with_noremap(),
    ["o|ie"] = map_cmd([[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]]):with_noremap(),
}

return { map = plug_map }
