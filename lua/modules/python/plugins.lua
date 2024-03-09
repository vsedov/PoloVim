local conf = require("modules.python.config")
local python = require("core.pack").package

python({
    "ranelpadon/python-copy-reference.vim",
    event = "BufReadPre *.py",
    lazy = true,
    cmd = {
        "PythonCopyReferenceDotted",
        "PythonCopyReferencePytest",
        "PythonCopyReferenceImport",
    },
})

python({
    "direnv/direnv.vim",
    event = "BufReadPre *.py",
    lazy = true,
})

python({
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = { "VenvSelect", "VenvSelectCached" },
    config = true,
})

python({
    "Vimjas/vim-python-pep8-indent",
    event = "BufReadPre *.py",
})

python({
    "purpleP/python-syntax",
    cond = false,
    event = "BufReadPre *.py",
})

-- I forget this existed

python({
    "milanglacier/yarepl.nvim",
    lazy = true,
    cmd = {
        "REPLStart",
        "REPLAttachBufferToREPL",
        "REPLDetachBufferToREPL",
        "REPLCleanup",
        "REPLFocus",
        "REPLHide",
        "REPLClose",
        "REPLSwap",
        "REPLSendVisual",
        "REPLSendLine",
        "REPLSendMotion",
    },
    config = function()
        local yarepl = require("yarepl")
        vim.g.REPL_use_floatwin = 0
        yarepl.setup({
            wincmd = function(bufnr, name)
                if vim.g.REPL_use_floatwin == 1 then
                    vim.api.nvim_open_win(bufnr, true, {
                        relative = "editor",
                        row = math.floor(vim.o.lines * 0.25),
                        col = math.floor(vim.o.columns * 0.25),
                        width = math.floor(vim.o.columns * 0.5),
                        height = math.floor(vim.o.lines * 0.5),
                        style = "minimal",
                        title = name,
                        border = "rounded",
                        title_pos = "center",
                    })
                else
                    vim.cmd([[belowright 15 split]])
                    vim.api.nvim_set_current_buf(bufnr)
                end
            end,
            metas = {
                aichat = { cmd = "aichat", formatter = yarepl.formatter.bracketed_pasting },
                radian = { cmd = "radian", formatter = yarepl.formatter.bracketed_pasting },
                ipython = { cmd = "ipython", formatter = yarepl.formatter.bracketed_pasting },
                python = { cmd = "python", formatter = yarepl.formatter.trim_empty_lines },
                R = { cmd = "R", formatter = yarepl.formatter.trim_empty_lines },
                bash = { cmd = "bash", formatter = yarepl.formatter.trim_empty_lines },
                zsh = { cmd = "zsh", formatter = yarepl.formatter.bracketed_pasting },
            },
        })
    end,
})

python({
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
})

python({
    "luk400/vim-jukit",
    cond = false,
    ft = { "python", "julia" },
    lazy = true,
    config = function()
        vim.g.jukit_terminal = "kitty"
    end,
})

python({
    "kiyoon/jupynium.nvim",
    cond = false,
    build = "pip3 install --user .",
    config = true,
})
