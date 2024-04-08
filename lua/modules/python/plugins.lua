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
python({
    "kmontocam/nvim-conda",
    cmd = { "CondaActivate", "CondaDeactivate" },
})

python({
    "benlubas/molten-nvim",
    dependencies = {
        "3rd/image.nvim",
        "quarto-dev/quarto-nvim",
        "jmbuhr/otter.nvim",
        "hrsh7th/nvim-cmp",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    build = ":UpdateRemotePlugins",
    ft = { "python", "julia" },
    init = function()
        -- these are examples, not defaults. Please see the readme
        vim.g.molten_image_provider = "image.nvim"
        -- Output Windowquarto.runner
        vim.g.molten_auto_open_output = false
        vim.g.molten_output_win_max_height = 30

        -- Virtual Text
        vim.g.molten_virt_text_output = true
        -- vim.g.molten_cover_empty_lines = true
        -- vim.g.molten_comment_string = "# %%"

        vim.g.molten_virt_text_output = true
        vim.g.molten_use_border_highlights = true
        vim.g.molten_virt_lines_off_by_1 = true
        vim.g.molten_wrap_output = true
        vim.g.molten_tick_rate = 142
    end,

    config = function()
        local function keys(str)
            return function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
            end
        end

        local Hydra = require("hydra")
        Hydra({
            name = "Notebook",
            hint = "_j_/_k_: ↑/↓ | _o_/_O_: new cell ↓/↑ | _l_: run | _s_how/_h_ide | run _a_bove",
            config = {
                color = "pink",
                invoke_on_body = true,
            },
            mode = { "n" },
            body = "<localleader>j",
            heads = {
                { "j", keys("]b"), { desc = "↓" } },
                { "k", keys("[b"), { desc = "↑" } },
                { "o", keys("/```<CR>:nohl<CR>o<CR>`<c-j>"), { desc = "new cell ↓", exit = true } },
                { "O", keys("?```.<CR>:nohl<CR><leader>kO<CR>`<c-j>"), { desc = "new cell ↑", exit = true } },
                { "l", ":QuartoSend<CR>", { desc = "run" } },
                { "s", ":noautocmd MoltenEnterOutput<CR>", { desc = "show" } },
                { "h", ":MoltenHideOutput<CR>", { desc = "hide" } },
                { "a", ":QuartoSendAbove<CR>", { desc = "run above" } },
                { "<esc>", nil, { exit = true, desc = false } },
                { "q", nil, { exit = true, desc = false } },
            },
        })
    end,
})
