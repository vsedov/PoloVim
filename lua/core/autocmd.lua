local vim = vim
local fn = vim.fn
local api = vim.api
local autocmd = {}

local smart_close_filetypes = {
    "help",
    "git-status",
    "git-log",
    "gitcommit",
    "dbui",
    "fugitive",
    "fugitiveblame",
    "LuaTree",
    "log",
    "tsplayground",
    "qf",
    "startuptime",
    "lspinfo",
    "neotest-summary",
}

local smart_close_buftypes = {} -- Don't include no file buffers as diff buffers are nofile

local function smart_close()
    if fn.winnr("$") ~= 1 then
        api.nvim_win_close(0, true)
    end
end

praestrictus.augroup("VimrcIncSearchHighlight", {
    {
        event = { "CursorMoved" },
        command = function()
            require("core.event_helper").hl_search()
        end,
    },
    {
        event = { "InsertEnter" },
        command = function()
            require("core.event_helper").stop_hl()
        end,
    },
    {
        event = { "OptionSet" },
        pattern = { "hlsearch" },
        command = function()
            vim.schedule(function()
                vim.cmd("redrawstatus")
            end)
        end,
    },
})
praestrictus.augroup("SmartClose", {
    {
        -- Auto open grep quickfix window
        event = { "QuickFixCmdPost" },
        pattern = { "*grep*" },
        command = "cwindow",
    },
    {
        -- Close certain filetypes by pressing q.
        event = { "FileType" },
        pattern = "*",
        command = function()
            local is_unmapped = fn.hasmapto("q", "n") == 0

            local is_eligible = is_unmapped
                or vim.wo.previewwindow
                or vim.tbl_contains(smart_close_buftypes, vim.bo.buftype)
                or vim.tbl_contains(smart_close_filetypes, vim.bo.filetype)

            if is_eligible then
                vim.keymap.set("n", "q", smart_close, { buffer = 0, nowait = true })
            end
        end,
    },
    {
        -- Close quick fix window if the file containing it was closed
        event = { "BufEnter" },
        pattern = "*",
        command = function()
            if fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
                api.nvim_buf_delete(0, { force = true })
            end
        end,
    },
    {
        -- automatically close corresponding loclist when quitting a window
        event = { "QuitPre" },
        pattern = "*",
        nested = true,
        command = function()
            if vim.bo.filetype ~= "qf" then
                vim.cmd("silent! lclose")
            end
        end,
    },
})
praestrictus.augroup("TextYankHighlight", {
    {
        -- don't execute silently in case of errors
        event = { "TextYankPost" },
        pattern = "*",
        command = function()
            vim.highlight.on_yank({
                timeout = 500,
                on_visual = false,
                higroup = "Visual",
            })
        end,
    },
})
praestrictus.augroup("Utilities", {
    {
        -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
        event = { "BufReadCmd" },
        pattern = { "file:///*" },
        nested = true,
        command = function(args)
            vim.cmd(fmt("bd!|edit %s", vim.uri_to_fname(args.file)))
        end,
    },
    {
        -- When editing a file, always jump to the last known cursor position.
        -- Don't do it for commit messages, when the position is invalid.
        event = { "BufReadPost" },
        command = function()
            if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
                local last_place_mark = vim.api.nvim_buf_get_mark(0, '"')
                local line_nr = last_place_mark[1]
                local last_line = vim.api.nvim_buf_line_count(0)

                if line_nr > 0 and line_nr <= last_line then
                    vim.api.nvim_win_set_cursor(0, last_place_mark)
                end
            end
        end,
    },
    {
        event = { "FileType" },
        pattern = { "gitcommit", "gitrebase" },
        command = "set bufhidden=delete",
    },
    {
        event = { "BufWritePre", "FileWritePre" },
        pattern = { "*" },
        command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
    },
    {
        event = { "BufLeave" },
        pattern = { "*" },
        command = function()
            if require("core.event_helper").can_save() then
                vim.cmd("silent! update")
            end
        end,
    },
    {
        event = { "BufWritePost" },
        pattern = { "*" },
        nested = true,
        command = function()
            if require("core.event_helper").empty(vim.bo.filetype) or fn.exists("b:ftdetect") == 1 then
                vim.cmd([[
            unlet! b:ftdetect
            filetype detect
            echom 'Filetype set to ' . &ft
          ]])
            end
        end,
    },
})

praestrictus.augroup("buffer", {
    {
        event = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter" },
        pattern = "*",
        command = "if &nu && mode() != 'i' | set rnu | endif",
    },

    {
        event = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
        pattern = "*",
        command = "if &nu | set nornu | endif",
    },
    { event = { "BufRead", "BufNewFile" }, pattern = "*.norg", command = "setlocal filetype=norg" },
    { event = { "BufEnter", "BufWinEnter" }, pattern = "*.norg", command = [[set foldlevel=1000]] },
    { event = { "BufNewFile", "BufRead", "BufWinEnter" }, pattern = "*.tex", command = [[set filetype=tex]] },
    -- Reload vim config automatically
    {
        event = "BufWritePost",
        pattern = [[$VIM_PATH/{*.vim,*.yaml,vimrc}]],
        command = [[source $MYVIMRC | redraw]],
        nested = true,
    },

    -- -- Reload Vim script automatically if setlocal autoread
    {
        event = { "BufWritePost", "FileWritePost" },
        pattern = "*.vim",
        command = [[ if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
        nested = true,
    },
    {
        event = "BufWritePre",
        pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
        command = function()
            vim.opt_local.undofile = false
        end,
    },

    -- { "BufEnter", "*", [[lcd `=expand('%:p:h')`]] }, -- Not requried atm
    {
        event = "BufLeave",
        pattern = { "*.py", "*.lua", "*.c", "*.cpp", "*.norg", "*.tex" },

        command = function()
            require("core.event_helper").mkview()
        end,
    },
    {
        event = "BufWinEnter",
        pattern = { "*.py", "*.lua", "*.c", "*.cpp", "*.norg", "*.tex" },

        command = function()
            require("core.event_helper").loadview()
        end,
    },
    {
        event = "BufWritePre",
        pattern = "*",
        command = function()
            local function auto_mkdir(dir, force)
                if
                    vim.fn.empty(dir) == 1
                    or string.match(dir, "^%w%+://")
                    or vim.fn.isdirectory(dir) == 1
                    or string.match(dir, "^suda:")
                then
                    return
                end
                if not force then
                    vim.fn.inputsave()
                    local result = vim.fn.input(string.format('"%s" does not exist. Create? [y/N]', dir), "")
                    if vim.fn.empty(result) == 1 then
                        print("Canceled")
                        return
                    end
                    vim.fn.inputrestore()
                end
                vim.fn.mkdir(dir, "p")
            end
            auto_mkdir(vim.fn.expand("%:p:h"), vim.v.cmdbang)
        end,
        nested = false,
    },
})

praestrictus.augroup("WindowBehaviours", {
    {
        -- map q to close command window on quit
        event = { "CmdwinEnter" },
        pattern = { "*" },
        command = "nnoremap <silent><buffer><nowait> q <C-W>c",
    },
    -- Automatically jump into the quickfix window on open
    {
        event = { "QuickFixCmdPost" },
        pattern = { "[^l]*" },
        nested = true,
        command = "cwindow",
    },
    {
        event = { "QuickFixCmdPost" },
        pattern = { "l*" },
        nested = true,
        command = "lwindow",
    },
    {
        event = { "WinEnter", "BufEnter", "InsertLeave" },
        pattern = "*",
        command = function()
            if vim.bo.filetype ~= "dashboard" and not vim.opt_local.cursorline:get() then
                vim.opt_local.cursorline = true
            end
        end,
    },
    {
        event = { "WinLeave", "BufLeave", "InsertEnter" },
        pattern = "*",
        command = function()
            if vim.bo.filetype ~= "dashboard" and vim.opt_local.cursorline:get() then
                vim.opt_local.cursorline = false
            end
        end,
    },
    {
        event = { "WinLeave", "BufLeave", "InsertEnter" },
        pattern = "*",
        command = [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\|NvimTree\)' && ! &pvw | setlocal nocursorcolumn | endif]],
    },
    { event = "CmdLineEnter", pattern = "*", command = [[set nosmartcase]] },
    { event = "CmdLineLeave", pattern = "*", command = [[set smartcase]] },
    -- Equalize window dimensions when resizing vim window
    { event = "VimResized", pattern = "*", command = [[tabdo wincmd =]] },
    -- Force write shada on leaving nvim
    {
        event = "VimLeave",
        pattern = "*",
        command = [[if has('nvim') | wshada! | else | wviminfo! | endif]],
    },
    {
        event = "VimEnter",
        pattern = "*",
        command = function()
            if vim.fn.bufname("%") ~= "" then
                return
            end
            local byte = vim.fn.line2byte(vim.fn.line("$") + 1)
            if byte ~= -1 or byte > 1 then
                return
            end
            vim.bo.buftype = "nofile"
            vim.bo.swapfile = false
            vim.bo.undofile = false
            vim.bo.fileformat = "unix"
        end,
    },
})
if vim.env.TERM == "xterm-kitty" then
    praestrictus.augroup("VimrcIncSearchHighlight", {
        {
            event = "UIEnter",
            pattern = "*",
            command = [[if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]],
        },
        {
            event = "UILeave",
            pattern = "*",
            command = [[if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]],
        },
    })
end
