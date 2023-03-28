local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

local def_map = {
    -- Vim map
    ["n|<C-x>k"] = map_cr("bdelete", "Buffer Delete"):with_noremap():with_silent(),
    ["n|Y"] = map_cmd("y$", "Yank on $"),
    ["n|]b"] = map_cu("bprev", "buf prev"):with_noremap(),
    ["n|[b"] = map_cu("bnext", "buf next"):with_noremap(),

    ["n|<Leader>w"] = map_cmd("<cmd>:w<cr>", "save"):with_noremap(),
    -- ["n|<Leader>q"] = map_cmd(":q<CR>", "exit"):with_noremap(),

    ["n|<C-h>"] = map_cmd("<C-w>h", "Jump h"):with_noremap(),
    ["n|<C-l>"] = map_cmd("<C-w>l", "Jump l"):with_noremap(),
    ["n|<C-J>"] = map_cmd("<C-w>j", "Jump j"):with_noremap(),
    ["n|<C-k>"] = map_cmd("<C-w>k", "Jump k"):with_noremap(),

    ["n|<C-q>"] = map_cmd(":wq<CR>", "save exit"),

    -- Insert
    ["i|<C-w>"] = map_cmd("<C-[>diwa"):with_noremap(),
    ["i|<C-h>"] = map_cmd("<BS>"):with_noremap(),
    ["i|<C-d>"] = map_cmd("<Del>"):with_noremap(),
    ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap(),
    ["i|<C-b>"] = map_cmd("<Left>"):with_noremap(),
    ["i|<C-f>"] = map_cmd("<Right>"):with_noremap(),

    -- command line
    ["c|<C-b>"] = map_cmd("<Left>"):with_noremap(),
    ["c|<C-a>"] = map_cmd("<Home>"):with_noremap(),
    ["c|<C-e>"] = map_cmd("<End>"):with_noremap(),
    ["c|<C-d>"] = map_cmd("<Del>"):with_noremap(),
    ["c|<C-h>"] = map_cmd("<BS>"):with_noremap(),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]], "current dir expand"):with_noremap(),
    ["c|::"] = map_cmd([[<C-r>=fnameescape(expand('%:p:h'))<cr>/]], "fnameescape"):with_noremap():with_silent(),
    ["c|/"] = map_cmd([[getcmdtype() == "/" ? "\/" : "/"]]):with_noremap():with_silent():with_expr(),
    ["c|<C-f>"] = map_cmd([[getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"]])
        :with_noremap()
        :with_silent()
        :with_expr(),
    ["c|<C-k>"] = map_cmd([[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]])
        :with_noremap()
        :with_silent(),

    -- when going to the end of the line in visual mode ignore whitespace characters
    ["n|$"] = map_cmd([[g_]]):with_noremap(),

    -- ----------------------------------------------------------------------
    ["n|1"] = map_cmd(vim.cmd.ChatGPT, "ChatGpt"):with_noremap(),
    ["n|2"] = map_cmd(vim.cmd.ChatGPTEditWithInstructions, "GptInstructions"):with_noremap(),
    ["n|3"] = map_cmd(vim.cmd.ChatGPTRunCustomCodeAction, "CodeActions"):with_noremap(),

    ["i|<c-z>k"] = map_cmd(vim.cmd.ChatGPTEditWithInstructions, "GptInstructions"):with_noremap(),
    ["i|<c-z>l"] = map_cmd(vim.cmd.ChatGPTRunCustomCodeAction, "CodeActions"):with_noremap(),
    -- ----------------------------------------------------------------------
}

return def_map
