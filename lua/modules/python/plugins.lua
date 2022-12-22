local conf = require("modules.python.config")
local python = require("core.pack").package

python({
    "direnv/direnv.vim",
    opt = true,
    ft = { "python", "julia" },
})

python({
    "AckslD/swenv.nvim",
    cmd = { "VenvFind", "GetVenv" },
    ft = "python",
    config = conf.swenv,
})

python({
    "relastle/vim-nayvy",
    ft = { "python" },
    opt = true,
    config = function()
        vim.g.nayvy_import_path_format = "all_relative"
        vim.g.nayvy_import_config_path = "$HOME/.config/nayvy/nayvy.py"
    end,
})

python({
    "wookayin/vim-python-enhanced-syntax",
    ft = "python",
})

python({
    "luk400/vim-jukit",
    opt = true,
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
