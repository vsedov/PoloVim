local global = require("core.global")

local function bind_option(options)
    for k, v in pairs(options) do
        if v == true or v == false then
            vim.cmd("set " .. k)
        else
            vim.cmd("set " .. k .. "=" .. v)
        end
    end
end

local function load_options()
    local global_local = {
        loadplugins = false,
        termguicolors = true,
        mouse = "nv",
        errorbells = true,
        visualbell = true,
        hidden = true,
        fileformats = "unix,mac,dos",
        magic = true,
        -- autochdir = true, -- keep pwd the same as current buffer
        virtualedit = "block",
        encoding = "utf-8",
        viewoptions = "folds,cursor,curdir,slash,unix",
        sessionoptions = "curdir,help,tabpages,winsize",
        clipboard = "unnamedplus",
        wildignorecase = true,
        wildignore = ".git/**,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
        backup = false,
        writebackup = false,
        undofile = true,
        swapfile = true,
        directory = global.cache_dir .. "swag/",
        undodir = global.cache_dir .. "undo/",
        backupdir = global.cache_dir .. "backup/",
        viewdir = global.cache_dir .. "view/",
        spellfile = global.cache_dir .. "spell/en.uft-8.add",
        history = 1000,
        shada = "!,'300,<50,@100,s10,h",
        backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
        smarttab = true,
        smartindent = true,
        shiftround = true,
        -- lazyredraw     = true;
        timeout = true,
        ttimeout = true,
        timeoutlen = 500,
        ttimeoutlen = 10,
        updatetime = 300,
        redrawtime = 100,
        ignorecase = true,
        smartcase = true,
        infercase = true,
        incsearch = true,
        wrapscan = true,
        complete = ".,w,b,k",
        inccommand = "nosplit", --split
        grepformat = "%f:%l:%c:%m",
        grepprg = 'rg --hidden --vimgrep --smart-case --glob "!{.git,node_modules,*~}/*" --',
        breakat = [[\ \ ;:,!?]],
        startofline = false,
        whichwrap = "h,l,<,>,[,],~",
        splitbelow = true,
        splitright = true,
        switchbuf = "useopen",
        backspace = "indent,eol,start",
        diffopt = "filler,hiddenoff,closeoff,iwhite,internal,algorithm:patience",
        completeopt = "menuone,noselect",
        jumpoptions = "stack",
        showmode = false,
        shortmess = "aotTIcF",
        scrolloff = 2,
        sidescrolloff = 5,
        foldlevelstart = 99,
        ruler = false,
        list = true,
        showtabline = 2,
        winwidth = 30,
        winminwidth = 10,
        pumheight = 15,
        helpheight = 12,
        previewheight = 12,
        showcmd = false,
        cmdheight = 2,
        cmdwinheight = 5,
        equalalways = false,
        laststatus = 3,
        display = "lastline",
        showbreak = "﬌  ", --↳
        listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
        pumblend = 10,
        winblend = 10,
        syntax = "off",
        background = "dark",
    }

    local bw_local = {
        synmaxcol = 1000,
        formatoptions = "1jcroql",
        textwidth = 80,
        expandtab = true,
        autoindent = true,
        tabstop = 2,
        shiftwidth = 2,
        softtabstop = -1,
        breakindentopt = "shift:2,min:20",
        wrap = false,
        linebreak = true,
        number = true,
        colorcolumn = "80",
        foldenable = true,
        signcolumn = "auto:2-3", --[auto yes] yes:3  auto:2  "number" auto: 2-4
        conceallevel = 2,
        concealcursor = "niv",
    }

    local bw_global_local = {
        fillchars = {
            eob = " ",
            vert = "║",
            horiz = "═",
            horizup = "╩",
            horizdown = "╦",
            vertleft = "╣",
            vertright = "╠",
            verthoriz = "╬",
        },
        spellfile = global.home .. ".config/nvim/spell/en.utf-8.add",
    }

    if global.is_mac then
        vim.g.clipboard = {
            name = "macOS-clipboard",
            copy = {
                ["+"] = "pbcopy",
                ["*"] = "pbcopy",
            },
            paste = {
                ["+"] = "pbpaste",
                ["*"] = "pbpaste",
            },
            cache_enabled = 0,
        }
        vim.g.python_host_prog = "/usr/bin/python2"
        -- vim.g.python3_host_prog = "/usr/bin/python3"
        if vim.fn.exists("$VIRTUAL_ENV") == 1 then
            vim.g.python3_host_prog = vim.fn.substitute(
                vim.fn.system("which -a python3 | head -n2 | tail -n1"),
                "\n",
                "",
                "g"
            )
        else
            vim.g.python3_host_prog = vim.fn.substitute(vim.fn.system("which python3"), "\n", "", "g")
        end
    end
    -- vim.o
    for name, value in pairs(global_local) do
        vim.o[name] = value
    end
    -- the cooler vim.o
    for name, value in pairs(bw_global_local) do
        vim.opt[name] = value
    end
    bind_option(bw_local)
end
vim.cmd([[syntax off]])
vim.cmd([[set viminfo-=:42 | set viminfo+=:1000]])
load_options()
