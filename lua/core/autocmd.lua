local vim = vim
local fn = vim.fn
local api = vim.api
local fmt = string.format

local autocmd = {}

local function replace_termcodes(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
    if vim.v.hlsearch == 0 or api.nvim_get_mode().mode ~= "n" then
        return
    end
    api.nvim_feedkeys(replace_termcodes("<Plug>(StopHL)"), "m", false)
end

-- [C]: in function 'nvim_replace_termcodes'
--         /home/viv/.config/nvim/lua/core/autocmd.lua:14: in function 'stop_hl'
--         /home/viv/.config/nvim/lua/core/autocmd.lua:27: in function 'hl_search'
--         /home/viv/.config/nvim/lua/core/autocmd.lua:35: in function </home/viv/.config/nvim/lua/core/autocmd.lua:34>
-- Press ENTER or type command to continue

local function hl_search()
    local col = api.nvim_win_get_cursor(0)[2]
    local curr_line = api.nvim_get_current_line()
    local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg("/"), 0)
    if not ok then
        return vim.notify(match, "error", { title = "HL SEARCH" })
    end
    local _, p_start, p_end = unpack(match)
    -- if the cursor is in a search result, leave highlighting on
    if col < p_start or col > p_end then
        stop_hl()
    end
end

lambda.augroup("VimrcIncSearchHighlight", {
    {
        event = { "CursorMoved" },
        command = function()
            hl_search()
        end,
    },
    {
        event = { "InsertEnter" },
        command = function()
            stop_hl()
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

lambda.augroup("SmartClose", {
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
lambda.augroup("TextYankHighlight", {
    {
        -- don't execute silently in case of errors
        event = { "TextYankPost" },
        pattern = "*",
        command = function()
            vim.highlight.on_yank({
                timeout = 200,
                on_visual = false,
                higroup = "Visual",
            })
        end,
    },
})
lambda.augroup("Utilities", {
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
        event = { "BufRead" },
        patter = "*",
        command = function()
            if vim.tbl_contains(vim.api.nvim_list_bufs(), vim.api.nvim_get_current_buf()) then
                -- check if filetype isn't one of the listed
                if not vim.tbl_contains({ "gitcommit", "help", "packer", "toggleterm" }, vim.bo.ft) then
                    -- check if mark `"` is inside the current file (can be false if at end of file and stuff got deleted outside neovim)
                    -- if it is go to it
                    vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])
                    -- get cursor position
                    local cursor = api.nvim_win_get_cursor(0)
                    -- if there are folds under the cursor open them
                    if fn.foldclosed(cursor[1]) ~= -1 then
                        vim.cmd([[silent normal! zO]])
                    end
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

lambda.augroup("buffer", {
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

local activate_spelling = {
    "txt",
    "norg",
    "tex",
    "md",
}

lambda.augroup("WindowBehaviours", {
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

lambda.augroup("CheckOutsideTime", {
    {
        -- automatically check for changed files outside vim
        event = { "WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained" },
        pattern = "*",
        command = "silent! checktime",
    },
})

--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
    --- Track the timer object and stop any previous timers before setting
    --- a new one so that each change waits for 10secs and that 10secs is
    --- deferred each time
    local timer
    return function()
        if timer then
            timer:stop()
        end
        timer = vim.defer_fn(function()
            if fn.mode() == "n" then
                vim.cmd([[echon '']])
            end
        end, 10000)
    end
end

lambda.augroup("ClearCommandMessages", {
    {
        event = { "CmdlineLeave", "CmdlineChanged" },
        pattern = { ":" },
        command = clear_commandline(),
    },
})
if vim.env.TERM == "xterm-kitty" then
    lambda.augroup("VimrcIncSearchHighlight", {
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

if lambda.config.neorg_auto_commit then
    lambda.augroup("NeorgAutoCommit", {
        {
            event = { "VimLeavePre", "VimSuspend" },
            pattern = "/home/viv/neorg/*",
            command = function()
                -- it might be enabled at teh start: but what happens when i dont what this to occour ?
                -- best way is to have another check - as there will be a toggle for neorg_auto_commit
                if lambda.config.neorg_auto_commit then
                    require("utils.custom_neorg_save").start()
                end
            end,
        },
    })
end

vim.api.nvim_create_user_command("SwitchBar", function()
    if lambda.config.tabby_or_bufferline then
        package.loaded["bufferline"] = nil
        lambda.config.tabby_or_bufferline = false
        require("packer").loader("tabby.nvim")
        require("modules.ui.config").tabby()
    else
        package.loaded["tabby"] = nil
        lambda.config.tabby_or_bufferline = true
        vim.cmd([[packadd bufferline]])
        require("modules.ui.config").nvim_bufferline()
    end
    require("modules.editor.hydra.buffer").buffer()
end, { force = true })
