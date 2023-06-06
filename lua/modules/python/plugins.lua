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
