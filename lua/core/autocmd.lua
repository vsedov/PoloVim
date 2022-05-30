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

function autocmd.load_autocmds()
    local definitions = {
        packer_call = {
            { "BufWritePost", "plugins.lua", "lua require('core.pack').auto_compile()" },
            {
                "User",
                "PackerCompileDone",
                function()
                    vim.api.nvim_chan_send(vim.v.stderr, "\027]99;i=1:d=0;Packer.nvim\027\\")
                    vim.api.nvim_chan_send(vim.v.stderr, "\027]99;i=1:d=1:p=body;Compile finished\027\\")
                end,
            },
        },
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
                [[if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
                true,
            },
            -- {
            --     { "BufWritePre", },
            --     "*.py",
            --     function()
            --     vim.cmd([[NayvyImports]])
            --     end
            -- },
            { "BufWritePre", "/tmp/*", "setlocal noundofile" },
            { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
            { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
            { "BufWritePre", "*.tmp", "setlocal noundofile" },
            { "BufWritePre", "*.bak", "setlocal noundofile" },
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
                "BufWinEnter",
                { "*.py", "*.lua", "*.tex", "*.norg" },
                function()
                    if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
                        if vim.fn.line([['"]]) > 0 and vim.fn.line([['"]]) <= vim.fn.line("$") then
                            -- Check if the last line of the buffer is the same as the window
                            if vim.fn.line("w$") == vim.fn.line("$") then
                                -- Set line to last line edited
                                vim.cmd([[normal! g`"]])
                                -- Try to center
                            elseif
                                vim.fn.line("$") - vim.fn.line([['"]])
                                > ((vim.fn.line("w$") - vim.fn.line("w0")) / 2) - 1
                            then
                                vim.cmd([[normal! g`"zz]])
                            else
                                vim.cmd([[normal! G'"<c-e>]])
                            end
                        end
                    end
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
                [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
            },
            {
                { "WinLeave", "BufLeave", "InsertEnter" },
                "*",
                [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\|NvimTree\)' && ! &pvw | setlocal nocursorline | endif]],
            },
            {
                { "WinLeave", "BufLeave", "InsertEnter" },
                "*",
                [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\|NvimTree\)' && ! &pvw | setlocal nocursorcolumn | endif]],
            },

            { "BufEnter", "NvimTree", [[setlocal cursorline]] },
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
                { "qf", "help", "man", "ls:pinfo" },
                "nnoremap <silent> <buffer> q :close<CR>",
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
                [[lua vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_macro = true, on_visual = true })]],
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
require("core.cmd")
return autocmd
