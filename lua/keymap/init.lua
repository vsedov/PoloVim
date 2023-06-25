local fn, api, uv, cmd, command, fmt = vim.fn, vim.api, vim.loop, vim.cmd, lambda.command, string.format

local recursive_map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.remap = true
    map(mode, lhs, rhs, opts)
end
local function open(path)
    vim.fn.jobstart({ "waterfox-g", path }, { detach = true })
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

--  ╭────────────────────────────────────────────────────────────────────╮
--  │                           Core Mappings                            │
--  ╰────────────────────────────────────────────────────────────────────╯
nnoremap("<C-x>k", [[<cmd>bd<CR>]], { desc = "Buffer Delete", silent = true })
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
cnoremap("/", [[getcmdtype() == "/" ? "\/" : "/"]], { desc = "escape forward slash" })
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
imap("<c-q>", [[<esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>]], { desc = "Jump Brackets" })
imap("<c-BS>", [[<esc>cvb]], { desc = "Jump Brackets" })

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
nnoremap("||_", [[v:count ? "<C-W>v<C-W><Right>" : '|']], { desc = "New Vertical Buffer", silent = true, expr = true })
nnoremap(
    "|||",
    [[v:count ? "<C-W>s<C-W><Down>"  : '_']],
    { desc = "New Horizontal Buffer", silent = true, expr = true }
)

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

nnoremap("<leader><leader>Sl", ":%s/<C-R><C-W>//gI<left><left><left>", {
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
xnoremap("ie", "gg0oG$", { desc = "entire object", silent = true })
onoremap("ie", '<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>', { desc = "entire object", expr = true })

nnoremap("0", [[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^"']], { desc = "0", expr = true })
xnoremap("0", [[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^"']], { desc = "0", expr = true })
onoremap("0", [[getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^"']], { desc = "0", expr = true })
--
-- -- This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap("<Leader><leader>so", [[<Cmd>source $MYVIMRC<cr> <bar> :lua vim.notify('Sourced init.vim')<cr>]], {
    desc = "Source init.lua",
    silent = true,
})
--

inoremap("!", [[<c-g>u!]], { desc = "!" })
inoremap(".", [[<c-g>u.]], { desc = "." })
inoremap("?", [[<c-g>u?]], { desc = "?" })

-- visually select the block of text I just pasted in Vim
nnoremap("gV", [[`[v`]], { desc = "visually select the block of text", silent = true })

xnoremap("@", ":<C-u>call ExecuteMacroOverVisualRange()<CR>", { desc = "Macro Execute" })

-- -- Credit: JGunn Choi ?il | inner line
xnoremap("aL", "$o0", { desc = "inner line", silent = true })
onoremap("aL", [[<cmd>normal val<CR>]], { desc = "nromal val", silent = true })

xnoremap("iL", [[<Esc>^vg_]], { desc = "inner line", silent = true })
onoremap("iL", [[<cmd>normal! ^vg_<CR>]], { desc = "nromal val", silent = true })

nnoremap("<localleader><cr>", function()
    if fn.empty(fn.getbufvar(fn.bufnr(), "&buftype")) then
        return "@@"
    else
        return "<CR>"
    end
end, { desc = "repeat macros", expr = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Folds                                                              │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap("<leader>Z", [[@=(foldlevel('.')?'za':"\<Space>")<CR>]], { desc = "toggle fold under cursor", silent = true })
--     -- Refocus folds
nnoremap("z<leader>", [[zMzvzz]], { desc = "center viewport" })
--     -- Make zO recursively open whatever top level fold we're in, no matter where the
nnoremap("z0", [[zCzO]], { desc = "recursively open whatever top level fold" })
vnoremap("$", "g_")
nnoremap("j", [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
nnoremap("k", [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
-- Toggle top/center/bottom
nmap("zz", [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Lsp Diagnostics                                                    │
--  ╰────────────────────────────────────────────────────────────────────╯
nnoremap("D", "<cmd>LspSaga show_line_diagnostics<cr>", { desc = "Diagnostic", silent = true, expr = true })
nnoremap(
    "}",
    ":lua vim.diagnostic.goto_next({ float = false })<cr>:DiagWindowShow<cr>",
    { desc = "Diag show next", silent = true, expr = true }
)
nnoremap(
    "{",
    ":lua vim.diagnostic.goto_prev({ float = false })<cr>:DiagWindowShow<cr>",
    { desc = "Diag show Prev", silent = true, expr = true }
)

nnoremap(";R", ":NeoRoot<cr>", { desc = "root switch", silent = true, expr = true })

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Telscope Mappings                                                  │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap("<Leader>U", ":lua require'utils.telescope'.find_updir()<CR>", { desc = "Up dir", silent = true })
nnoremap("<leader>xW", ":lua require'utils.telescope'.help_tags()<CR>", { desc = "Help tag", silent = true })
nnoremap(
    "<Leader>gw",
    ":lua require'utils.telescope'.grep_last_search()<CR>",
    { desc = "Grep last word", silent = true }
)
vnoremap(
    "<Leader>gw",
    ":lua require'utils.telescope'.grep_string_visual()<CR>",
    { desc = "Grep last word", silent = true }
)
nnoremap("<Leader>yy", ":lua require'utils.telescope'.neoclip()<CR>", { desc = "NeoClip", silent = true })
--

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ misc                                                               │
--  ╰────────────────────────────────────────────────────────────────────╯

nnoremap("<F1>", ":UndotreeToggle<cr>", { desc = "Undo Tree", silent = true })

nnoremap("<Leader>J", ":TSJJoin<Cr>", { desc = "TSJJoin", silent = true })
nnoremap("<Leader>j", ":TSJToggle<cr>", { desc = "TSJToggle", silent = true })
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
vim.keymap.set({ "x", "n" }, "gx", function()
    local file = vim.fn.expand("<cfile>")
    if not file or vim.fn.isdirectory(file) > 0 then
        return vim.cmd.edit(file)
    end

    if file:match("http[s]?://") then
        return open(file)
    end

    -- consider anything that looks like string/string a github link
    local link = file:match("[%a%d%-%.%_]*%/[%a%d%-%.%_]*")
    if link then
        return open(string.format("https://www.github.com/%s", link))
    end
end, { noremap = true, silent = true })
