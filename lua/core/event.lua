local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(defs)
    for group_name, definition in pairs(defs) do
        vim.api.nvim_create_augroup(group_name, { clear = true })
        for _, def in ipairs(definition) do
            event = def[1]
            -- Check if def[3] is a function or a string
            local args
            if type(def[3]) == "function" then
                call = def[3]
                arg = {
                    group = group_name,
                    pattern = def[2],
                    callback = def[3],
                    nested = def[4],
                }
            else
                arg = {
                    group = group_name,
                    pattern = def[2],
                    command = def[3],
                    nested = def[4],
                }
            end

            vim.api.nvim_create_autocmd(event, arg)
        end
    end
end
function autocmd.load_autocmds()
    local definitions = {
        packer = {
            { "BufWritePost", "plugins.lua", "lua require('core.pack').auto_compile()" },
        },
        bufs = {
            { { "BufRead", "BufNewFile" }, "*.norg", "setlocal filetype=norg" },
            { { "BufEnter", "BufWinEnter" }, "*.norg", [[set foldlevel=1000]] },

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
            { "BufWritePre", "/tmp/*", "setlocal noundofile" },
            { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
            { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
            { "BufWritePre", "*.tmp", "setlocal noundofile" },
            { "BufWritePre", "*.bak", "setlocal noundofile" },
            -- { "BufEnter", "*", [[lcd `=expand('%:p:h')`]] }, -- Not requried atm
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

            -- Check if file changed when its window is focus, more eager than 'autoread'
            { "FocusGained", "*", "checktime" },
            -- -- {"CmdwinEnter,CmdwinLeave", "*", "lua require'wlfloatline'.toggle()"};
            -- {"CmdlineEnter,CmdlineLeave", "*", "echom 'kkk'"};
        },

        ft = {
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
                { "make", "grep", "grepadd", "vimgrep", "vimgrepadd" },
                [[cwin]],
            },
            {
                "QuickfixCmdPost",
                { "lmake", "lgrep", "lgrepadd", "lvimgrep", "lvimgrepadd" },
                [[lwin]],
            },
        },
    }
    local callbackdefs = {
        callback = {
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
                    vim.bo.fileformat = "unix"
                end,
            },
            {
                "BufWritePost",
                "*",
                function()
                    if vim.fn.getline(1) == "^#!" then
                        if vim.fn.getline(1) == "/bin/" then
                            vim.cmd([[chmod a+x <afile>]])
                        end
                    end
                end,
                false,
            },
            {
                "BufWritePre",
                "*",
                function()
                    function auto_mkdir(dir, force)
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
                    auto_mkdir(vim.fn.expand("<afile>:p:h"), vim.v.cmdbang)
                end,
                false,
            },
        },
    }
    autocmd.nvim_create_augroups(definitions)
    autocmd.nvim_create_augroups(callbackdefs)
end

autocmd.load_autocmds()
return autocmd
