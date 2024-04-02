local conf = require("modules.python.config")
local python = require("core.pack").package

python({
    "ranelpadon/python-copy-reference.vim",
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
    ft = "python",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    cmd = { "VenvSelect", "VenvSelectCached" },
    config = function()
        require("venv-selector").setup({
            anaconda_base_path = "/opt/mambaforge",
            anaconda_envs_path = "/home/viv/.conda/envs",
        })
    end,
})

python({
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
})

python({
    "purpleP/python-syntax",
    ft = "python",
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
