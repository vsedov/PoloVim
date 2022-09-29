local conf = require("modules.user.config")
local user = require("core.pack").package

-- True emotional Support
user({ "rtakasuke/vim-neko", cmd = "Neko", opt = true })

-- TODO(vsedov) (00:11:22 - 13/08/22): Temp plugin

-- TODO: (vsedov) (09:02:43 - 29/08/22): https://github.com/luk400/vim-jukit set this thing up,
-- looks very nice to have .

user({
    "luk400/vim-jukit",
    opt = true,
    config = function()
        vim.g.jukit_terminal = "kitty"
        vim.cmd([[
        let g:jukit_layout = {
            \'split': 'horizontal',
            \'p1': 0.6,
            \'val': [
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

user({
    "samuzora/pet.nvim",
    opt = true,
    setup = function()
        lambda.setup_plugin("BufEnter", "pet.nvim", lambda.config.use_pet)
    end,
    config = function()
        require("pet-nvim")
    end,
})

user({
    -- for packer.nvim
    "delphinus/dwm.nvim",
    -- branch = "feature/refactor",
    opt = true,
    keys = {
        "_j",
        "_k",
        "_<CR>",
        "_@",
        "_<leader>",
        "_l",
        "_h",
        "_n",
        "_q",
        "_s",
        "_c",
    },
    config = function()
        local dwm = require("dwm")
        dwm.setup({
            key_maps = false,
            master_pane_count = 1,
            master_pane_width = "60%",
        })
        vim.keymap.set("n", "_j", "<C-w>w")
        vim.keymap.set("n", "_k", "<C-w>W")
        vim.keymap.set("n", "_<CR>", dwm.focus, { desc = "focus" })
        vim.keymap.set("n", "_@", dwm.focus, { desc = "focus" })
        vim.keymap.set("n", "_<leader>", dwm.focus, { desc = "focus" })
        vim.keymap.set("n", "_l", dwm.grow, { desc = "grow" })
        vim.keymap.set("n", "_h", dwm.shrink, { desc = "shrink" })
        vim.keymap.set("n", "_n", dwm.new, { desc = "new" })
        vim.keymap.set("n", "_q", dwm.rotateLeft, { desc = "rotate left" })
        vim.keymap.set("n", "_s", dwm.rotate, { desc = "rotate" })
        vim.keymap.set("n", "_c", function()
            vim.notify("closing!", vim.log.levels.INFO)
            dwm.close()
        end, { desc = "close dwm" })
    end,
})
