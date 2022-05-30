local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
-- local map_key = bind.map_key
-- local global = require("core.global")
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])

local plug_map = {
    ["x|@"] = map_cmd(":<C-u>call ExecuteMacroOverVisualRange()<CR>"):with_noremap(),
    ["n|<M-w>"] = map_cmd("<cmd>NeoNoNameBufferline<CR>"):with_noremap():with_silent():with_nowait(),

    ["n|<C-]>"] = map_args("Template"),
    ["n|<leader>cd"] = map_cmd("<cmd>cd %:p:h<CR>:pwd<CR>"):with_noremap():with_silent(),
    ["n|<Leader>e"] = map_cr("NeoTreeFocusToggle"):with_noremap():with_silent(),
    ["n|<Leader>F"] = map_cr("NeoTreeFocus"):with_noremap():with_silent(),
    ["n|<Leader>cf"] = map_cr("Neotree float reveal_file=<cfile> reveal_force_cwd"):with_noremap():with_silent(),
    ["n|<Leader>cw"] = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),
    ["n|ga"] = map_cmd("<Cmd>CodeActionMenu<cr>"):with_noremap():with_silent(),
    ["v|ga"] = map_cmd("<cmd>CodeActionMenu<Cr>"):with_noremap():with_silent(),
    ["n|<Leader>ca"] = map_cu("<cmd>lua vim.lsp.buf.code_action()<CR>"):with_noremap():with_silent(),
    ["n|gA"] = map_cmd("<cmd>Lspsaga code_action<CR>"):with_noremap():with_silent(),
    ["n|<localleader>D"] = map_cmd('<cmd>lua require"modules.lsp.lsp.utils.peek".toggle_diagnostics_visibility()<CR>')
        :with_noremap()
        :with_silent(),
    ["n|gd"] = map_cmd([[<cmd>lua require"modules.lsp.lsp.utils.peek".Peek('definition')<CR>]])
        :with_noremap()
        :with_silent(),

    ["n|dpj"] = map_cmd('<cmd>lua require"modules.lsp.lsp.utils.peek".PeekTypeDefinition()<CR>')
        :with_noremap()
        :with_silent(),

    ["n|dpk"] = map_cmd('<cmd>lua require"modules.lsp.lsp.utils.peek".PeekImplementation()<CR>')
        :with_noremap()
        :with_silent(),

    ["n|<Leader>gr"] = map_cmd("<cmd>Lspsaga rename<CR>"):with_noremap():with_silent(),
    ["n|<Leader>v"] = map_cu("Vista!!"):with_noremap():with_silent(),
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
    ["n|<RightMouse>"] = map_cmd("<RightMouse><cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

    ["n|<C-ScrollWheelUp>"] = map_cmd("<C-i>"):with_noremap():with_silent(),
    ["n|<C-ScrollWheelDown>"] = map_cmd("<C-o>"):with_noremap():with_silent(),
    ["n|<Leader>ta"] = map_cr("ToggleAlternate"):with_noremap():with_silent(),
    ["n|<Leader><Leader>1"] = map_cu("ZenMode"):with_noremap():with_silent(),
    ["n|<F9>"] = map_cr('<cmd> lua require("nabla").action()<CR>'):with_noremap(),
    ["n|<localleader>b"] = map_cr('<cmd> lua require("nabla").popup()<CR>'):with_noremap(),

    ["n|;e"] = map_cmd("<cmd>lua require('spectre').open()<CR>"):with_noremap(),
    ["n|;W"] = map_cmd("<cmd>lua require('spectre').open_visual({select_word=true})<CR>"):with_noremap(),
    ["n|;w"] = map_cu("Sad"):with_noremap():with_silent(),
    ["v|'v"] = map_cmd("<cmd>lua require('spectre').open_visual()<CR>"):with_noremap(),
    ["v|'c"] = map_cmd("<cmd>lua require('spectre').open_file_search()<CR>"):with_noremap(),
}

return plug_map
