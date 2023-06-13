local conf = require("modules.python.config")
local python = require("core.pack").package

python({
    "ranelpadon/python-copy-reference.vim",
    lazy = true,
    ft = "python",
    cmd = {
        "PythonCopyReferenceDotted",
        "PythonCopyReferencePytest",
        "PythonCopyReferenceImport",
    },
})

python({
    "direnv/direnv.vim",
    lazy = true,
    ft = { "python", "julia" },
})

python({
    "AckslD/swenv.nvim",
    lazy = true,
    ft = "python",
    cmd = { "VenvFind", "GetVenv" },
    config = conf.swenv,
})
python({
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    keys = {
        {
            "<leader>vs",
            "<cmd>:VenvSelect<cr>",
            -- key mapping for directly retrieve from cache. You may set autocmd if you prefer the no hand approach
            "<leader>vs",
            "<cmd>:VenvSelectCached<cr>",
        },
    },
    config = true,
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
})

python({
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
})

python({
    "purpleP/python-syntax",
    ft = { "python" },
})

python({
    "luk400/vim-jukit",
    lazy = true,
    config = function()
        vim.g.jukit_terminal = "kitty"
        vim.cmd([[
        let g:jukit_layout = {
            \'split': 'horizontal',
           \'val': [
             \'p1': 0.6,
                \'file_content',
                \{
                    \'split': 'vertical',
                    \'p1': 0.6,
                    \'val': ['output', 'output_history']
                \}
            \]
        \}
        fun! DFColumns()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = visual_selection . '.columns'
            call jukit#send#send_to_split(cmd)
        endfun
        vnoremap C :call DFColumns()<cr>

        fun! PythonHelp()
            let visual_selection = jukit#util#get_visual_selection()
            let cmd = 'help(' . visual_selection . ')'
            call jukit#send#send_to_split(cmd)
        endfun
        vnoremap H :call PythonHelp()<cr>
        ]])
    end,
})

--  TODO: (vsedov) (08:12:27 - 04/06/23): I am not sure if this is even viable
python({
    "kiyoon/jupynium.nvim",
    lazy = true,
    cmd = {
        "JupyniumStartAndAttachToServer",
        "JupyniumStartSync",
    },
    build = "pip3 install --user .",
    config = true,
})
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
    init = function()
        lambda.augroup("REPL", {
            {
                event = { "FileType" },
                pattern = { "quarto", "markdown", "markdown.pandoc", "rmd", "python", "sh", "REPL" },
                desc = "set up REPL keymap",
                command = function()
                    local utils = require("modules.editor.hydra.repl_utils")
                    vim.keymap.set("n", "<localleader>r", function()
                        vim.schedule_wrap(require("hydra")(require("modules.editor.hydra.normal.repl")):activate())
                    end, { desc = "Start an REPL", buffer = 0 })
                    vim.keymap.set("n", "<localleader>sc", utils.send_a_code_chunk, {
                        desc = "send a code chunk",
                        expr = true,
                        buffer = 0,
                    })
                end,
            },
        })
    end,
    config = function()
        vim.g.REPL_use_floatwin = 0
        require("yarepl").setup({
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
        })
    end,
})
