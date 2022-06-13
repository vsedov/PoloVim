local vim = vim
local options = setmetatable({}, { __index = { global_local = {}, window_local = {} } })

local function bind_option(opts)
    for k, v in pairs(opts) do
        if v == true or v == false then
            vim.cmd("set " .. k)
        else
            vim.cmd("set " .. k .. "=" .. v)
        end
    end
end
local function executable(exec)
    vim.validate({ exec = { exec, "string" } })
    assert(exec ~= "", debug.traceback("Empty executable string"))
    return vim.fn.executable(exec) == 1
end
function options:load_options()
    self.global_local = {}
    self.window_local = {}
    if vim.wo.diff then
        self.global_local = { foldmethod = "diff", diffopt = "context:0", foldlevel = 0, mouse = "a" }
        self.window_local = {
            -- foldmethod = "expr",
            cursorline = false,
            -- noreadonly = false;
        }
    else
        self.global_local = {
            ttyfast = true, -- Indicate fast terminal conn for faster redraw
            errorbells = false, -- No beeps
            hidden = true, -- Buffer should still exist if window is closed
            fileencoding = "utf-8", -- fenc
            mouse = "a",
            textwidth = 120, -- wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
            expandtab = true, -- " expand tabs to spaces
            updatetime = 1000, -- Vim waits after you stop typing before it triggers the plugin is governed by the setting updatetime
            ignorecase = true, -- Search case insensitive...
            smartcase = true, -- ... but not it begins with upper case
            incsearch = true, -- Shows the match while typing
            hlsearch = true, -- Highlight found searches
            grepformat = "%f:%l:%m,%m\\ %f\\ match%ts,%f", -- "%f:%l:%c:%m";
            shortmess = "aotTIcF",
            -- showcmd        = false;
            cmdheight = 0,
            splitbelow = true, -- Horizontal windows should split to bottom
            splitright = true, -- Vertical windows should be split to right
            backspace = "indent,eol,start", -- Makes backspace key more powerful.
            backup = true,
            writebackup = true,
            diffopt = "filler,iwhite,internal,algorithm:patience",
            completeopt = "menuone,noselect,noinsert", -- Show popup menu, even if there is one entry  menuone?
            pumheight = 15, -- Completion window max size
            laststatus = 3, -- Show status line always -- can be 3
            listchars = "tab:┊ ,nbsp:+,trail:·,extends:→,precedes:←", -- tab:»·,
            autowrite = true, -- Automatically save before :next, :make etc.
            autoread = true, -- Automatically read changed files
            breakindent = true, -- Make it so that long lines wrap smartly
            smartindent = true, -- use intelligent indentation
            showmatch = true, -- highlight matching braces
            numberwidth = 3,
        }

        self.window_local = {
            foldmethod = "indent", -- indent? expr?  expr is slow for large files
            number = true,
            relativenumber = true,
            foldenable = true,
        }
    end
    local bw_local = {
        synmaxcol = 500,
        textwidth = 120,
        colorcolumn = "110", -- will reformat lines more than 120, but show ruler at 110
        wrap = true,
    }
    bind_option(bw_local)
    for name, value in pairs(self.global_local) do
        vim.o[name] = value
    end
    for name, value in pairs(self.window_local) do
        vim.wo[name] = value
    end

    vim.cmd("imap <M-V> <C-R>+") -- mac
    vim.cmd("imap <C-V> <C-R>*")
    vim.cmd('vmap <LeftRelease> "*ygv')
    vim.cmd("unlet loaded_matchparen")
    vim.g.python_host_prog = "/usr/bin/python2"
    vim.g.python3_host_prog = "/usr/bin/python3"
    -- if executable("python3") and executable("pip3") then
    --     vim.g.python3_host_prog = vim.fn.exepath("python3")
    --     vim.g.loaded_python_provider = 0
    -- elseif executable("python2") and executable("pip2") then
    --     vim.g.python_host_prog = vim.fn.exepath("python2")
    --     vim.g.loaded_python3_provider = 0
    -- else
    --     vim.g.loaded_python_provider = 0
    --     vim.g.loaded_python3_provider = 0
    -- end
end

options:load_options()

return options
