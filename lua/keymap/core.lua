local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args

vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])

local plug_map = {
    -- new files
    ["n|<localleader>ns"] = map_cmd([[:e <C-R>=expand("%:p:h") . "/" <CR>]], "newfiles"):with_silent(),
    ["n|<localleader>nf"] = map_cmd([[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], "newfiles"):with_silent(),

    ["n|<localleader>nh"] = map_cmd("<C-W>t <C-W>K", "horizontally split windows to vertical splits"):with_noremap(),
    ["n|<localleader>nv"] = map_cmd("<C-W>t <C-W>H", "Change two vertically split windows to horizontal splits"):with_noremap(),

    -- -- Replace word under cursor in Buffer (case-sensitive)
    -- -- nmap <leader>sr :%s/<C-R><C-W>//gI<left><left><left>
    -- ["n|<leader><leader>Sr"] = map_cmd(":%s/<C-R><C-W>//gI<left><left><left>", "Replace word under cursor")
    --     :with_noremap()
    --     :with_silent(),
    -- -- Replace word under cursor on Line (case-sensitive)
    -- -- nmap <leader>sl :s/<C-R><C-W>//gI<left><left><left>
    ["n|<leader><leader>Sl"] = map_cmd(":s/<C-R><C-W>//gI<left><left><left>", "Replace word under cursor on Line")
        :with_noremap()
        :with_silent(),
    -- ["n|<leader><leader>Sc"] = map_cmd([[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], "replace current"):with_noremap(),

    -- ?ie | entire object
    ["x|ie"] = map_cmd([[gg0oG$]]):with_noremap():with_silent(),
    ["o|ie"] = map_cmd([[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]]):with_expr():with_noremap(),

    ["o|0"] = map_cmd([[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'"]]):with_expr():with_noremap(),
    ["n|0"] = map_cmd([[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'"]]):with_expr():with_noremap(),
    ["x|0"] = map_cmd([[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'"]]):with_expr():with_noremap(),

    -- This line allows the current file to source the vimrc allowing me use bindings as they're added
    ["n|<Leader>so"] = map_cmd([[<Cmd>source $MYVIMRC<cr> <bar> :lua vim.notify('Sourced init.vim')<cr>]], "Source init.lua")
        :with_silent()
        :with_noremap(),

    ["n|<leader>cD"] = map_cmd([[:let @"=expand("%:p")<CR>]], "expand current dir"):with_silent():with_noremap(),

    ["i|<C-U>"] = map_cmd([[<ESC>b~A]], "end of line"):with_silent():with_noremap(),
    ["n|¢"] = map_cmd([[bl~lhe]], "first two words captal"):with_silent():with_noremap(),
    ["n||_"] = map_cmd([[!v:count ? "<C-W>v<C-W><Right>" : '|']], "New Vertical Buffer"):with_silent():with_expr(),
    ["n|||"] = map_cmd([[!v:count ? "<C-W>s<C-W><Down>"  : '_']], "New Horizontal Buffer"):with_silent():with_expr(),

    ["i|!"] = map_cmd([[!<c-g>u]]):with_silent():with_noremap(),
    ["i|."] = map_cmd([[.<c-g>u]]):with_silent():with_noremap(),
    ["i|?"] = map_cmd([[?<c-g>u]]):with_silent():with_noremap(),

    -- -- Start new line from any cursor position
    ["i|<S-Return>"] = map_cmd([[<C-o>o]], "Start new line from any cursor position"):with_noremap():with_silent(),
    -- -- visually select the block of text I just pasted in Vim
    ["n|gV"] = map_cmd([[`[v`]], "visually select the block of text"):with_noremap():with_silent(),

    ["x|@"] = map_cmd(":<C-u>call ExecuteMacroOverVisualRange()<CR>", "Macro Execute"):with_noremap(),

    -- Credit: JGunn Choi ?il | inner line
    ["x|al"] = map_cmd([[$o0]], "inner line"):with_noremap():with_silent(),
    ["o|al"] = map_cmd([[<cmd>normal val<CR>]], "nromal val"):with_noremap():with_silent(),

    ["x|il"] = map_cmd([[<Esc>^vg_]]):with_noremap():with_silent(),
    ["o|il"] = map_cmd([[<cmd>normal! ^vg_<CR>]]):with_noremap():with_silent(),

    -- -- new lines
    ["n|\\["] = map_cmd([[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]], "New Lines top"):with_noremap(),
    ["n|\\]"] = map_cmd([[<cmd>put =repeat(nr2char(10), v:count1)<cr>]], "New Lines bottom"):with_noremap(),

    -- visual search
    ["v|//"] = map_cmd([[y/<C-R>"<CR>]], "visual search"):with_noremap(),

    -- test
    ["n|g>"] = map_cmd([[<cmd>set nomore<bar>40messages<bar>set more<CR>]], "set nomore"):with_noremap(),
    -- repeat macro
    ["n|<leader><cr>"] = map_cmd([[empty(&buftype) ? '@@' : '<CR>']], "repeat macros"):with_noremap():with_expr(),

    -- evaluate folds
    ["n|<leader>z"] = map_cmd([[@=(foldlevel('.')?'za':"\<Space>")<CR>]], "eval fold"):with_noremap(), -- Refocus folds
    -- Refocus folds
    ["n|z<leader>"] = map_cmd([[zMzvzz]], "refocus folds"):with_noremap(), -- Refocus folds
    -- Make zO recursively open whatever top level fold we're in, no matter where the
    -- cursor happens to be.
    ["n|z0"] = map_cmd([[zCzO]]):with_noremap(),

    -- Toggle top/center/bottom
    ["n|;z"] = map_cmd([[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']])
        :with_noremap()
        :with_expr(),

    ["n|<localleader>l"] = map_cmd([[<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>]], "command line window - :<c-f>")
        :with_noremap()
        :with_silent(),
}

return plug_map
