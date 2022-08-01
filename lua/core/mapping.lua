local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

local def_map = {
    -- Vim map
    ["n|<C-x>k"] = map_cr("bdelete", "Buffer Delete"):with_noremap():with_silent(),
    ["n|Y"] = map_cmd("y$", "Yank on $"),
    ["n|]w"] = map_cu("WhitespaceNext", "White space next"):with_noremap(),
    ["n|[w"] = map_cu("WhitespacePrev", "White space prev"):with_noremap(),
    ["n|]b"] = map_cu("bp", "buf prev"):with_noremap(),
    ["n|[b"] = map_cu("bn", "buf next"):with_noremap(),

    ["n|<Leader>w"] = map_cmd("<cmd>:w<cr>", "save"):with_noremap(),
    ["n|<Leader>q"] = map_cmd(":wq!<CR>", "exit"):with_noremap(),

    ["n|<Space>cw"] = map_cu([[silent! keeppatterns %substitute/\s\+$//e]], "Subsitute"):with_noremap():with_silent(),

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
    ["c|<C-f>"] = map_cmd("<Right>"):with_noremap(),
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
}
-- local os_map = {
--   ["n|<c-s>"] = map_cu("write"):with_noremap(),
--   ["i|<c-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),
--   ["v|<c-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),
--   ["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"),
-- }

-- local global = require("core.global")
-- if global.is_mac then
--   os_map = {
--     ["n|<d-s>"] = map_cu("w"):with_silent(),
--     ["i|<d-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),
--     ["v|<d-s>"] = map_cu('"normal :w"'):with_noremap():with_silent(),

--     ["n|<d-w>"] = map_cu("wqa!"):with_silent(),
--     ["i|<d-w>"] = map_cu('"normal :wqa!"'):with_noremap():with_silent(),
--     ["v|<d-w>"] = map_cu('"normal :wqa!"'):with_noremap():with_silent(),
--   }
-- end

-- def_map = vim.list_extend(def_map, os_map)
-- def_map = vim.tbl_extend("keep", def_map, os_map)

bind.nvim_load_mapping(def_map)
