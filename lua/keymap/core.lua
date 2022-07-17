local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
lambda.augroup("AddTerminalMappings", {
    {
        event = { "TermOpen" },
        pattern = { "term://*" },
        command = function()
            if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
                local opts = { silent = false, buffer = 0 }
                tnoremap("<esc>", [[<C-\><C-n>]], opts)
                tnoremap("jk", [[<C-\><C-n>]], opts)
                tnoremap("<C-h>", [[<C-\><C-n><C-W>h]], opts)
                tnoremap("<C-j>", [[<C-\><C-n><C-W>j]], opts)
                tnoremap("<C-k>", [[<C-\><C-n><C-W>k]], opts)
                tnoremap("<C-l>", [[<C-\><C-n><C-W>l]], opts)
                tnoremap("]t", [[<C-\><C-n>:tablast<CR>]])
                tnoremap("[t", [[<C-\><C-n>:tabnext<CR>]])
                tnoremap("<S-Tab>", [[<C-\><C-n>:bprev<CR>]])
                tnoremap("<leader><Tab>", [[<C-\><C-n>:close \| :bnext<cr>]])
            end
        end,
    },
})
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])

-- TLDR: Conditionally modify character at end of line
-- Description:
-- This function takes a delimiter character and:
--   * removes that character from the end of the line if the character at the end
--     of the line is that character
--   * removes the character at the end of the line if that character is a
--     delimiter that is not the input character and appends that character to
--     the end of the line
--   * adds that character to the end of the line if the line does not end with
--     a delimiter
-- Delimiters:
-- - ","
-- - ";"
---@param character string
---@return function
local function modify_line_end_delimiter(character)
    local delimiters = { ",", ";" }
    return function()
        local line = api.nvim_get_current_line()
        local last_char = line:sub(-1)
        if last_char == character then
            api.nvim_set_current_line(line:sub(1, #line - 1))
        elseif vim.tbl_contains(delimiters, last_char) then
            api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
        else
            api.nvim_set_current_line(line .. character)
        end
    end
end
local plug_map = {
    -- new files
    ["n|<localleader>ns"] = map_cmd([[:e <C-R>=expand("%:p:h") . "/" <CR>]], "newfiles"):with_silent(),
    ["n|<localleader>nf"] = map_cmd([[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], "newfiles"):with_silent(),

    -- -- Replace word under cursor in Buffer (case-sensitive)
    -- -- nmap <leader>sr :%s/<C-R><C-W>//gI<left><left><left>
    ["n|<Leader>sr"] = map_cmd(":%s/<C-R><C-W>//gI<left><left><left>", "Replace word under cursor")
        :with_noremap()
        :with_silent(),
    -- Replace word under cursor on Line (case-sensitive)
    -- nmap <leader>sl :s/<C-R><C-W>//gI<left><left><left>
    ["n|<Leader>sl"] = map_cmd(":s/<C-R><C-W>//gI<left><left><left>", "Replace word under cursor on Line")
        :with_noremap()
        :with_silent(),

    ["n|<leader>["] = map_cmd([[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], "replace current"):with_noremap(),

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
    ["n|<leader>cp"] = map_cmd([[:let @"=expand("%:p")<CR>]], "expand current dir"):with_silent():with_noremap(),

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
    -- Greatest remap ever
    ["x|<leader>p"] = map_cmd([["\"_dP"]], "Greatest remap ever"):with_noremap():with_silent(),
    ["x|<leader>y"] = map_cmd([["\"+y"]], "Yank"):with_noremap():with_silent(),
    ["n|<leader>dd"] = map_cmd([["_d]], "Greatest remap ever"):with_noremap():with_silent(),

    ["x|@"] = map_cmd(":<C-u>call ExecuteMacroOverVisualRange()<CR>", "Macro Execute"):with_noremap(),

    -- Credit: JGunn Choi ?il | inner line
    ["x|al"] = map_cmd([[$o0]], "inner line"):with_noremap():with_silent(),
    ["o|al"] = map_cmd([[<cmd>normal val<CR>]], "nromal val"):with_noremap():with_silent(),

    ["x|il"] = map_cmd([[<Esc>^vg_]]):with_noremap():with_silent(),
    ["o|il"] = map_cmd([[<cmd>normal! ^vg_<CR>]]):with_noremap():with_silent(),

    -- -- new lines
    ["n|;l"] = map_cmd([[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]], "New Lines top"):with_noremap(),
    ["n|;'"] = map_cmd([[<cmd>put =repeat(nr2char(10), v:count1)<cr>]], "New Lines bottom"):with_noremap(),

    -- visual search
    ["v|//"] = map_cmd([[y/<C-R>"<CR>]], "visual search"):with_noremap(),

    -- test
    ["n|g>"] = map_cmd([[<cmd>set nomore<bar>40messages<bar>set more<CR>]], "set nomore"):with_noremap(),
    -- repeat macro
    ["n|<leader><cr>"] = map_cmd([[empty(&buftype) ? '@@' : '<CR>']], "repeat macros"):with_noremap():with_expr(),

    -- evaluate folds
    ["n|zz<leader>"] = map_cmd([[@=(foldlevel('.')?'za':"\<Space>")<CR>]], "eval fold"):with_noremap(), -- Refocus folds
    -- Refocus folds
    ["n|z<leader>"] = map_cmd([[zMzvzz]], "refocus folds"):with_noremap(), -- Refocus folds
    -- Make zO recursively open whatever top level fold we're in, no matter where the
    -- cursor happens to be.
    ["n|z0"] = map_cmd([[zCzO]]):with_noremap(),

    -- Toggle top/center/bottom
    ["n|zz"] = map_cmd([[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']])
        :with_noremap()
        :with_expr(),

    -- this could fail
    ["n|<localleader>,"] = map_cmd(function()
        modify_line_end_delimiter(",")
    end, "Modify Del"):with_noremap(),
    ["n|<localleader>;"] = map_cmd(function()
        modify_line_end_delimiter(",")
    end, "Modify Del"):with_noremap(),

    ["n|<localleader>wh"] = map_cmd("<C-W>t <C-W>K", "horizontally split windows to vertical splits"):with_noremap(),
    ["n|<localleader>wv"] = map_cmd("<C-W>t <C-W>H", "Change two vertically split windows to horizontal splits"):with_noremap(),
    ["n|<C-w>f"] = map_cmd([[<C-w>vgf]], "horizontal split"):with_noremap():with_silent(),

    ["n|<localleader>l"] = map_cmd([[<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>]], "command line window - :<c-f>")
        :with_noremap()
        :with_silent(),
}

return plug_map
