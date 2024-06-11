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

inoremap("<c-q>", [[<esc>:call search("[)\\]}>,`'\"]", 'eW')<CR>]], { desc = "Jump Brackets" })

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

lambda.command("Bufgrep", function(params)
    bufgrep(params.args)
end, { nargs = "+" })

-- Delete comments in line [normal and visual]
-- Define a table of comment patterns for different file types
local comment_patterns = {
    lua = { whole_line = "^%s*%-%-(.*)$", inline = "(.-)%s*%-%-(.*)$" },
    python = { whole_line = "^%s*#(.*)$", inline = "(.-)%s*#(.*)$" },
    hyprlang = { whole_line = "^%s*#(.*)$", inline = "(.-)%s*#(.*)$" },
    fish = { whole_line = "^%s*#(.*)$", inline = "(.-)%s*#(.*)$" },
    cpp = { whole_line = "^%s*//(.*)$", inline = "(.-)%s*//(.*)$" },
    c = { whole_line = "^%s*//(.*)$", inline = "(.-)%s*//(.*)$" },
    lua_multiline = { block_start = "%-%-%[%[", block_end = "%]%]" },
}

-- Helper function to detect file type and get the appropriate patterns
local function get_comment_patterns()
    local ft = vim.bo.filetype
    return comment_patterns[ft] or comment_patterns.lua -- Default to Lua if the file type is not listed
end

-- Normal mode mapping
vim.keymap.set("n", ";c", function()
    local patterns = get_comment_patterns()
    local start_line = vim.fn.line(".")
    local end_line = start_line
    local comment_pattern = patterns.inline
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    for i, line_content in ipairs(lines) do
        local uncommented_line = line_content:gsub(comment_pattern, "%1")
        lines[i] = uncommented_line
    end
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, { desc = "Remove comments from line", silent = true, noremap = true })

-- Visual mode mapping
vim.keymap.set("v", ";c", function()
    local patterns = get_comment_patterns()
    local start_line = vim.fn.line(".")
    local end_line = vim.fn.line("v")
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    local whole_line_comment_pattern = patterns.whole_line
    local inline_comment_pattern = patterns.inline
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    for i, line_content in ipairs(lines) do
        if line_content:match(whole_line_comment_pattern) then
            lines[i] = ""
        else
            local uncommented_line = line_content:gsub(inline_comment_pattern, "%1")
            lines[i] = uncommented_line
        end
    end
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, { desc = "Remove comments from selected lines", silent = true, noremap = true })

vim.keymap.set("n", ",v", function()
    vim.notify(vim.fn.system("curl -s -m 3 https://vtip.43z.one"))
end)

vim.keymap.set({ "n" }, "vv", "V", { noremap = true })
vim.keymap.set({ "n" }, "vvv", "<C-V>", { noremap = true })

-- TAB window management
vim.keymap.set("n", "\\bn", "<cmd>tabnew<CR>", { desc = "Tab - [t]ab [o]pen" })
vim.keymap.set("n", "\\bc", "<cmd>tabclose<CR>", { desc = "Tab - [t]ab [c]lose" })
vim.keymap.set("n", "\\bN", "<cmd>tabn<CR>", { desc = "Tab - [t]ab [n]ext" })
vim.keymap.set("n", "\\bp", "<cmd>tabp<CR>", { desc = "Tab - [t]ab [p]revious" })
vim.keymap.set("n", "\\bb", "<cmd>tabnew %<CR>", { desc = "Tab - [t]ab open current [b]uffer" })

-- Goto insert with/without copying to register from visual selection
vim.keymap.set("v", "i", function()
    if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
        vim.api.nvim_feedkeys('"_d', "n", true)
        vim.api.nvim_feedkeys("i", "n", true)
    else
        vim.api.nvim_feedkeys("i", "n", true)
    end
end, { desc = "Goto insert without copying to register", silent = true, expr = true, noremap = true })

vim.keymap.set("v", "I", function()
    if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
        vim.fn.setreg('"', vim.fn.getreg(""))
        vim.api.nvim_feedkeys("d", "n", true)
        vim.api.nvim_feedkeys("i", "n", true)
    else
        vim.api.nvim_feedkeys("i", "n", true)
    end
end, { desc = "Goto insert with copying to register", silent = true, expr = true, noremap = true })
