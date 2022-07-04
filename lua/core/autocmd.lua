local vim = vim
local fn = vim.fn
local api = vim.api
local autocmd = {}

function autocmd.nvim_create_augroups(defs)
    for group_name, definition in pairs(defs) do
        api.nvim_create_augroup(group_name, { clear = true })
        for _, def in ipairs(definition) do
            local event = def[1]
            local arg = {
                group = group_name,
                pattern = def[2],
                [type(def[3]) == "function" and "callback" or type(def[3]) == "string" and "command"] = def[3],
                nested = def[4] or false,
            }
            -- Log:info(vim.inspect(event), vim.inspect(arg))
            api.nvim_create_autocmd(event, arg)
        end
    end
end

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

function autocmd.load_autocmds()
    local definitions = {
        buffer = {
            {
                { "BufEnter", "FocusGained", "InsertLeave", "WinEnter" },
                "*",
                "if &nu && mode() != 'i' | set rnu | endif",
            },
            {
                { "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
                "*",
                "if &nu | set nornu | endif",
            },

            { { "BufRead", "BufNewFile" }, "*.norg", "setlocal filetype=norg" },
            { { "BufEnter", "BufWinEnter" }, "*.norg", [[set foldlevel=1000]] },
            { { "BufNewFile", "BufRead", "BufWinEnter" }, "*.tex", [[set filetype=tex]] },
            -- Reload vim config automatically
            {
                "BufWritePost",
                [[$VIM_PATH/{*.vim,*.yaml,vimrc}]],
                [[source $MYVIMRC | redraw]],
                true,
            },

            -- Reload Vim script automatically if setlocal autoread
            {
                { "BufWritePost", "FileWritePost" },
                "*.vim",
                [[ if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
                true,
            },
            {
                "BufWritePre",
                "*.py",
                function()
                    vim.cmd([[NayvyImports]])
                end,
            },

            {
                "BufWritePre",
                { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
                function()
                    vim.opt_local.undofile = false
                end,
            },

            -- { "BufEnter", "*", [[lcd `=expand('%:p:h')`]] }, -- Not requried atm
            {
                "BufLeave",
                { "*.py", "*.lua", "*.c", "*.cpp", "*.norg", "*.tex" },

                function()
                    require("core.event_helper").mkview()
                end,
            },
            {
                "BufWinEnter",
                { "*.py", "*.lua", "*.c", "*.cpp", "*.norg", "*.tex" },

                function()
                    require("core.event_helper").loadview()
                end,
            },
            {
                "BufWritePre",
                "*",
                function()
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
                false,
            },

            -- {
            --     "BufWritePost",
            --     { "*.py", "*.lua", "*sh", "*.scala", "*.tcl" },
            --     function()
            --         local line = (vim.inspect(api.nvim_buf_get_lines(0, 0, 1, true)))
            --         if line:find("#!") and line:find("/bin/") then
            --             vim.cmd([[silent !chmod u+x %]])
            --         end
            --     end,
            --     false,
            -- },
        },

        wins = {
            -- Highlight current line only on focused window
            {
                { "WinEnter", "BufEnter", "InsertLeave" },
                "*",
                function()
                    if vim.bo.filetype ~= "dashboard" and not vim.opt_local.cursorline:get() then
                        vim.opt_local.cursorline = true
                    end
                end,
            },
            {
                { "WinLeave", "BufLeave", "InsertEnter" },
                "*",
                function()
                    if vim.bo.filetype ~= "dashboard" and vim.opt_local.cursorline:get() then
                        vim.opt_local.cursorline = false
                    end
                end,
            },
            {
                { "WinLeave", "BufLeave", "InsertEnter" },
                "*",
                [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\|NvimTree\)' && ! &pvw | setlocal nocursorcolumn | endif]],
            },
            { "CmdLineEnter", "*", [[set nosmartcase]] },
            { "CmdLineLeave", "*", [[set smartcase]] },
            -- Equalize window dimensions when resizing vim window
            { "VimResized", "*", [[tabdo wincmd =]] },
            -- Force write shada on leaving nvim
            {
                "VimLeave",
                "*",
                [[if has('nvim') | wshada! | else | wviminfo! | endif]],
            },
            {
                "VimEnter",
                "*",
                function()
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
        },

        ft = {

            {
                "FileType",
                { "tex", "norg", "markdown" },
                function()
                    vim.cmd([[
                  setlocal spell
                  set spelllang=en,en_gb
                  nnoremap <C-k> [s1z=<c-o>

                  inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
                ]])
                end,
            },
            {
                "FileType",
                "dashboard",
                "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2",
            },

            { { "BufNewFile", "BufRead" }, "*.toml", " setf toml" },
        },
        yank = {
            {
                "TextYankPost",
                "*",
                function()
                    vim.highlight.on_yank({
                        timeout = 500,
                        on_visual = false,
                        higroup = "Visual",
                    })
                end,
            },
        },
        quickfix = {
            {
                "QuickfixCmdPost",
                { "qf", "make", "grep", "grepadd", "vimgrep", "vimgrepadd" },
                [[cwin]],
            },
            {
                "QuickfixCmdPost",
                { "lmake", "lgrep", "lgrepadd", "lvimgrep", "lvimgrepadd" },
                [[lwin]],
            },
            {
                "QuitPre",
                "qf",
                function()
                    if vim.bo.filetype ~= "qf" then
                        vim.cmd("silent! lclose")
                    end
                end,
                true,
            },
            {
                "BufEnter",
                "qf",
                function()
                    if vim.fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
                        api.nvim_buf_delete(0, { force = true })
                    end
                end,
            },
        },
        VimrcIncSearchHighlight = {
            {
                "CursorMoved",
                "*",
                function()
                    require("core.event_helper").hl_search()
                end,
            },
            {
                "InsertEnter",
                "*",
                function()
                    require("core.event_helper").stop_hl()
                end,
            },
        },
        SmartClose = {
            {
                "QuickFixCmdPost",
                "*grep*",
                "cwindow",
            },
            {
                "FileType",
                "*",

                function()
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
        },
        Utilities = {
            {
                "BufReadCmd",
                "file:///*",
                function(args)
                    vim.cmd(fmt("bd!|edit %s", vim.uri_to_fname(args.file)))
                end,
            },
            {
                -- last place
                "BufRead",
                "*",
                function()
                    if vim.tbl_contains(vim.api.nvim_list_bufs(), vim.api.nvim_get_current_buf()) then
                        -- check if filetype isn't one of the listed
                        if not vim.tbl_contains({ "gitcommit", "help", "packer", "toggleterm" }, vim.bo.ft) then
                            -- check if mark `"` is inside the current file (can be false if at end of file and stuff got deleted outside neovim)
                            -- if it is go to it
                            vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])
                            -- get cursor position
                            local cursor = vim.api.nvim_win_get_cursor(0)
                            -- if there are folds under the cursor open them
                            if vim.fn.foldclosed(cursor[1]) ~= -1 then
                                vim.cmd([[silent normal! zO]])
                            end
                        end
                    end
                end,
            },
            {
                "BufLeave",
                "*",
                function()
                    if require("core.event_helper").can_save() then
                        vim.cmd("silent! update")
                    end
                end,
            },
        },
    }
    if vim.env.TERM == "xterm-kitty" then
        local kitty_fix = {
            ui = {
                {
                    "UIEnter",
                    "*",
                    [[if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]],
                },
                {
                    "UILeave",
                    "*",
                    [[if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]],
                },
            },
        }
        autocmd.nvim_create_augroups(kitty_fix)
    end
    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
return autocmd
