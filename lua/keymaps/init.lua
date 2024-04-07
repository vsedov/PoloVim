if not lambda then
    return
end
local fn, api, uv, cmd, command, fmt = vim.fn, vim.api, vim.loop, vim.cmd, lambda.command, string.format

local recursive_map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.remap = true
    map(mode, lhs, rhs, opts)
end
local function open(path)
    vim.fn.jobstart({ "waterfox", path }, { detach = true })
    vim.notify(string.format("Opening %s", path))
end

local nmap = function(...)
    recursive_map("n", ...)
end
local imap = function(...)
    recursive_map("i", ...)
end
local nnoremap = function(...)
    map("n", ...)
end
local xnoremap = function(...)
    map("x", ...)
end
local vnoremap = function(...)
    map("v", ...)
end
local inoremap = function(...)
    map("i", ...)
end
local onoremap = function(...)
    map("o", ...)
end
local cnoremap = function(...)
    map("c", ...)
end

local tnoremap = function(...)
    map("t", ...)
end
local function bufgrep(text)
    vim.cmd.cclose()
    vim.cmd("%argd")
    local bufnr = vim.api.nvim_get_current_buf()
    vim.cmd.bufdo({ args = { "argadd", "%" } })
    vim.api.nvim_set_current_buf(bufnr)
    vim.cmd.vimgrep({ args = { string.format("/%s/gj", text), "##" }, mods = { silent = true } })
    vim.cmd("QFOpen!")
end
--  ╭────────────────────────────────────────────────────────────────────╮
--  │                           Core Mappings                            │
--  ╰────────────────────────────────────────────────────────────────────╯
nnoremap("Y", "y$", { desc = "Yank to end of line" })
nnoremap("<leader>w", [[<cmd>:w<cr>]], { desc = "save" })
nnoremap("<c-q>", [[<cmd>:wq<cr>]], { desc = "save and exit" })
imap("<C-w>", "<C-[>diwa", { desc = "delete word" })
cnoremap("<C-b>", "<Left>", { desc = "move cursor left" })
cnoremap("<C-a>", "<Home>", { desc = "move cursor to start of line" })
cnoremap("<C-e>", "<End>", { desc = "move cursor to end of line" })
cnoremap("<C-d>", "<Del>", { desc = "delete character under cursor" })
cnoremap("<C-h>", "<BS>", { desc = "delete character before cursor" })
cnoremap("<C-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]], { desc = "current dir expand" })
cnoremap("::", [[<C-r>=fnameescape(expand('%:p:h'))<cr>/]], { desc = "fnameescape" })
cnoremap("<C-f>", [[getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"]], {
    desc = "move cursor forward",
})
cnoremap("<C-k>", [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]], {
    desc = "delete character before cursor",
})

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Bracket Mapping                                                    │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap([[<leader>"]], [[ciw"<c-r>""<esc>]], { desc = "surround with double quotes" })
nnoremap("<leader>`", [[ciw`<c-r>"`<esc>]], { desc = "surround with backticks" })
nnoremap("<leader>'", [[ciw'<c-r>"'<esc>]], { desc = "surround with single quotes" })
nnoremap("<leader>)", [[ciw(<c-r>")<esc>]], { desc = "surround with parentheses" })
nnoremap("<leader>}", [[ciw{<c-r>"}<esc>]], { desc = "surround with curly braces" })

inoremap("<c-q>", [[<esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>]], { desc = "Jump Brackets" })
inoremap("<c-BS>", [[<esc>cvb]], { desc = "Jump Brackets" })

if lambda.falsy(fn.mapcheck("<ScrollWheelDown>")) then
    nmap("<ScrollWheelDown>", "<c-d>")
end
if lambda.falsy(fn.mapcheck("<ScrollWheelUp>")) then
    nmap("<ScrollWheelUp>", "<c-u>")
end

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Buffers                                                            │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap("<localleader><tab>", [[:b <Tab>]], { silent = false, desc = "open buffer list" })
nnoremap("<leader><leader>L", [[<c-^>]], { desc = "switch to last buffer" })

nnoremap("<esc>", function()
    require("notify").dismiss()
    cmd("nohl")
end, { desc = "Clear highlight from search and close notifications", silent = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Empty Space infront and Behind                                     │
--  ╰────────────────────────────────────────────────────────────────────╯
nnoremap("<leader>iO", [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]], {
    desc = " add space above",
})

nnoremap("<leader>io", [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]], {
    desc = " add space below",
})
nnoremap("<leader>ii", "i <esc>l", { desc = " Insert space before", silent = true })
nnoremap("<leader>ia", "a <esc>h", { desc = " Insert space after", silent = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Search                                                             │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap("<leader><leader>w", ":%s/<C-R><C-W>//gI<left><left><left>", {
    desc = "Replace word under cursor on Line",
    silent = true,
})
-- search visual selection
vnoremap("/", [[y/<C-R>"<CR>]])

-- Credit: Justinmk
nnoremap("g>", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], {
    desc = "show message history",
})

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Custom Objects                                                     │
--  ╰────────────────────────────────────────────────────────────────────╯
-- -- ?ie | entire object
xnoremap("ie", [[gg0oG$]])
onoremap("ie", [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])

nnoremap("0", [[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^"']], { desc = "0", expr = true })
xnoremap("0", [[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^"']], { desc = "0", expr = true })
onoremap("0", [[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^"']], { desc = "0", expr = true })
--
-- -- This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap("<Leader><leader>so", [[<Cmd>source $MYVIMRC<cr> <bar> <cmd>:lua vim.notify('Sourced init.vim')<cr>]], {
    desc = "Source init.lua",
    silent = true,
})

inoremap("!", [[<c-g>u!]], { desc = "!" })
inoremap(".", [[<c-g>u.]], { desc = "." })
inoremap("?", [[<c-g>u?]], { desc = "?" })

-- visually select the block of text I just pasted in Vim
nnoremap("gV", [[`[v`]], { desc = "visually select the block of text", silent = true })

xnoremap("@", "<cmd>:<C-u>call ExecuteMacroOverVisualRange()<CR>", { desc = "Macro Execute" })

-- -- Credit: JGunn Choi ?il | inner line
xnoremap("aL", "$o0", { desc = "inner line", silent = true })
onoremap("aL", [[<cmd>normal val<CR>]], { desc = "nromal val", silent = true })

xnoremap("iL", [[<Esc>^vg_]], { desc = "inner line", silent = true })
onoremap("iL", [[<cmd>normal! ^vg_<CR>]], { desc = "nromal val", silent = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Folds                                                              │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap("<leader>z", [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], { desc = "toggle fold under cursor", silent = true })
--     -- Refocus folds
nnoremap("z<leader>", [[zMzvzz]], { desc = "center viewport" })
--     -- Make zO recursively open whatever top level fold we're in, no matter where the
nnoremap("z0", [[zCzO]], { desc = "recursively open whatever top level fold" })
vnoremap("$", "g_")

if not lambda.config.movement.use_accelerated_jk then
    nnoremap("j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
    nnoremap("k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
end
-- Toggle top/center/bottom
nmap("zz", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Lsp Diagnostics                                                    │
--  ╰────────────────────────────────────────────────────────────────────╯
nnoremap(
    "}",
    "<cmd>:lua vim.diagnostic.goto_next({ float = false })<cr>:DiagWindowShow<cr>",
    { desc = "Diag show next", silent = true }
)
nnoremap(
    "{",
    "<cmd>:lua vim.diagnostic.goto_prev({ float = false })<cr>:DiagWindowShow<cr>",
    { desc = "Diag show Prev", silent = true }
)

vnoremap("D", function()
    local l, c = unpack(vim.api.nvim_win_get_cursor(0))
    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, l - 1, l, true)) do
        if line:match("^%s*$") then
            return '"_d'
        end
    end
    return "d"
end, { desc = "visual smart d", expr = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Dir Changes                                                        │
--  ╰────────────────────────────────────────────────────────────────────╯
nnoremap("<leader>cD", [[:let @"=expand("%:p")<CR>]], { desc = "expand current dir", silent = true })

nnoremap("<leader>cd", function()
    lambda.clever_tcd()
end, { desc = "Clever cd", silent = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Direct Keymap.set                                                  │
--  ╰────────────────────────────────────────────────────────────────────╯
-- vim.keymap.set({ "x", "n" }, "gx", function()
--     local file = vim.fn.expand("<cfile>")
--     if not file or vim.fn.isdirectory(file) > 0 then
--         return vim.cmd.edit(file)
--     end
--
--     if file:match("http[s]?://") then
--         return open(file)
--     end
--
--     -- consider anything that looks like string/string a github link
--     local link = file:match("[%a%d%-%.%_]*%/[%a%d%-%.%_]*")
--     if link then
--         return open(string.format("https://www.github.com/%s", link))
--     end
-- end, { noremap = true, silent = true })

vim.keymap.set("n", "gw", "<cmd>cclose | Grep <cword><CR>", { desc = "Grep for word" })
vim.keymap.set("n", "gbw", function()
    bufgrep(vim.fn.expand("<cword>"))
end, { desc = "grep open buffers for word" })
vim.keymap.set("n", "gbW", function()
    bufgrep(vim.fn.expand("<cWORD>"))
end, { desc = "Grep open buffers for WORD" })
lambda.command("Bufgrep", function(params)
    bufgrep(params.args)
end, { nargs = "+" })
vim.keymap.set("n", ",v", function()
    vim.notify(vim.fn.system("curl -s -m 3 https://vtip.43z.one"))
end)

vim.keymap.set("n", "<Leader>qd", "<CMD>bd<CR>", { desc = "Buffer: delete buffer" })
vim.keymap.set("n", "<Leader>qq", "<CMD>%bd<CR>", { silent = true, desc = "Buffer: delete all buffer" })
vim.keymap.set("n", "<Leader>qa", "<CMD>%bd!<CR>", { silent = true, desc = "Buffer: force delete all buffer" })
vim.keymap.set(
    "n",
    "<Leader>qo",
    "<CMD>%bd|e#<CR>",
    { silent = true, desc = "Buffer: delete all buffer except this one" }
)
