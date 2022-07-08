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
    ["x|@"] = map_cmd(":<C-u>call ExecuteMacroOverVisualRange()<CR>", "Macro Execute"):with_noremap(),
    ["n|<M-w>"] = map_cmd("<cmd>NeoNoName<CR>", "NeoName Buffer"):with_noremap():with_silent():with_nowait(),

    -- check whats actually loaded
    ["n|<localleader>ps"] = map_cmd("<cmd>PackerStatus<cr>", "PackerStatus"):with_noremap():with_silent(),

    ["n|<C-]>"] = map_args("Template", "Template"),
    ["n|<leader>cd"] = map_cmd("<cmd>cd %:p:h<CR>:pwd<CR>", "Cwd"):with_noremap():with_silent(),
    ["n|<Leader>e"] = map_cr("NeoTreeFocusToggle", "NeoTree Focus Toggle"):with_noremap():with_silent(),
    ["n|<Leader>F"] = map_cr("NeoTreeFocus", "NeoTree Focus"):with_noremap():with_silent(),
    ["n|<Leader>cf"] = map_cr("Neotree float reveal_file=<cfile> reveal_force_cwd", "Float reveal file")
        :with_noremap()
        :with_silent(),

    ["n|cc"] = map_cmd("<Cmd>CodeActionMenu<cr>", "Code action Menu"):with_noremap():with_silent(),
    ["v|ga"] = map_cmd("<cmd>CodeActionMenu<Cr>", "Code action Menu"):with_noremap():with_silent(),
    ["n|<Leader>ca"] = map_cu("<cmd>lua vim.lsp.buf.code_action()<CR>", "lsp code actions")
        :with_noremap()
        :with_silent(),

    ---- private peek
    ["n|<localleader>D"] = map_cmd(
        '<cmd>lua require"modules.lsp.lsp.utils.peek".toggle_diagnostics_visibility()<CR>',
        "Toggle diagnostic Temp"
    ):with_noremap():with_silent(),

    ["n|dpj"] = map_cmd(
        '<cmd>lua require"modules.lsp.lsp.utils.peek".PeekTypeDefinition()<CR>',
        "Peek Type definition"
    )
        :with_noremap()
        :with_silent(),

    ["n|dpk"] = map_cmd('<cmd>lua require"modules.lsp.lsp.utils.peek".PeekImplementation()<CR>', "Peek Implementation")
        :with_noremap()
        :with_silent(),
    ---- private peek
    ["n|<Leader>v"] = map_cu("Vista!!", "Vistaaa"):with_noremap():with_silent(),
    ["n|<Leader>gt"] = map_cr(
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        "Git Linker open browser range "
    ):with_silent(),
    ["v|<Leader>gt"] = map_cr(
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        "Git Linker range"
    ),
    ["n|<Leader>gY"] = map_cr('<cmd>lua require"gitlinker".get_repo_url()<cr>', "get repo url"):with_silent(),
    ["n|<Leader>gT"] = map_cr(
        '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        "Open Browser"
    ):with_silent(),
    ["n|<RightMouse>"] = map_cmd("<RightMouse><cmd>lua vim.lsp.buf.definition()<CR>", "rightclick def")
        :with_noremap()
        :with_silent(),

    ["n|<C-ScrollWheelUp>"] = map_cmd("<C-i>", "Buf Move"):with_noremap():with_silent(),
    ["n|<C-ScrollWheelDown>"] = map_cmd("<C-o>", "Buf Move"):with_noremap():with_silent(),
    ["n|<Leader>ta"] = map_cr("ToggleAlternate", "Toggle values"):with_noremap():with_silent(),
    ["n|<Leader><Leader>1"] = map_cu("ZenMode", "Quiet Mode zen"):with_noremap():with_silent(),

    ["n|;e"] = map_cmd("<cmd>lua require('spectre').open()<CR>", "spectre"):with_noremap(),
    ["n|;W"] = map_cmd("<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "current word spectre"):with_noremap(),
    ["n|;w"] = map_cu("Sad", "Sad Search"):with_noremap():with_silent(),

    -- feel like these needs to change
    ["v|'v"] = map_cmd("<cmd>lua require('spectre').open_visual()<CR>", "Spectre visual"):with_noremap(),
    ["v|'c"] = map_cmd("<cmd>lua require('spectre').open_file_search()<CR>", "Spectre file search"):with_noremap(),
}

return plug_map
