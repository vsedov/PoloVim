local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
-- local map_key = bind.map_key
-- local global = require("core.global")
local cur_buf = nil
local cur_cur = nil

local plug_map = {
    ["n|<M-w>"] = map_cmd("<cmd>NeoNoName<CR>", "NeoName Buffer"):with_noremap():with_silent():with_nowait(),
    ["n|_<cr>"] = map_cmd(function()
            if vim.api.nvim_win_get_config(0).relative == "" then
                cur_buf = vim.fn.bufnr()
                cur_cur = vim.api.nvim_win_get_cursor(0)
                if vim.fn.bufname() ~= "" then
                    vim.cmd("NeoNoName")
                end
                vim.cmd("NeoZoomToggle")
                vim.api.nvim_set_current_buf(cur_buf)
                vim.api.nvim_win_set_cursor(0, cur_cur)
                vim.cmd("normal! zt")
                vim.cmd("normal! 7k7j")
                return
            end
            vim.cmd("NeoZoomToggle")
            vim.api.nvim_set_current_buf(cur_buf)
            cur_buf = nil
            cur_cur = nil
            vim.cmd("NeoWellJump") -- you can safely remove this line.
        end, "NeoZoomToggle")
        :with_noremap()
        :with_silent()
        :with_nowait(),

    ["n|<leader>cd"] = map_cmd(lambda.clever_tcd, "Cwd"):with_noremap():with_silent():with_nowait(),

    -- New mapping for lspsaga
    ["n|<leader><S-Tab>"] = map_cmd("<cmd>Lspsaga open_floaterm<cr>", "float_term"):with_noremap():with_silent(),
    ["t|<leader><S-Tab>"] = map_cmd("<C-\\><C-n><cmd>Lspsaga close_floaterm<cr>", "float_term")
        :with_noremap()
        :with_silent(),

    -- check whats actually loaded
    ["n|<localleader>ps"] = map_cmd("<cmd>PackerStatus<cr>", "PackerStatus"):with_noremap():with_silent(),
    ["n|<localleader>pP"] = map_cmd("<cmd>StartupTime<cr>", "StartUpTime"):with_noremap():with_silent(),

    ["n|<Leader>e"] = map_cr("NeoTreeFocusToggle", "NeoTree Focus Toggle"):with_noremap():with_silent(),
    ["n|<Leader><leader>d"] = map_cr("Neotree diagnostics", "Diagnostics"):with_noremap():with_silent(),

    ["n|<Leader>F"] = map_cr("NeoTreeFocus", "NeoTree Focus"):with_noremap():with_silent(),
    ["n|<Leader>cf"] = map_cr("Neotree float reveal_file=<cfile> reveal_force_cwd", "Float reveal file")
        :with_noremap()
        :with_silent(),

    --  REVISIT: (vsedov) (20:40:02 - 15/09/22): See if this works
    ["n|\\;"] = map_cmd("<Cmd>Lspsaga code_action<cr>", "Code action Menu"):with_noremap():with_silent(),
    -- ["n|cc"] = map_cmd("<Cmd>CodeActionMenu<cr>", "Code action Menu"):with_noremap():with_silent(),
    ["x|ga"] = map_cmd("<C-U>Lspsaga range_code_action<CR>", "Code action Menu"):with_noremap():with_silent(),

    ---- private peek
    ["n|<localleader>D"] = map_cmd('<cmd>lua require"modules.lsp.lsp.config.peek".toggle_diagnostics_visibility()<CR>', "Toggle diagnostic Temp")
        :with_noremap()
        :with_silent(),

    ["n|dpj"] = map_cmd('<cmd>lua require"modules.lsp.lsp.config.peek".PeekTypeDefinition()<CR>', "Peek Type definition")
        :with_noremap()
        :with_silent(),

    ["n|dpk"] = map_cmd('<cmd>lua require"modules.lsp.lsp.config.peek".PeekImplementation()<CR>', "Peek Implementation")
        :with_noremap()
        :with_silent(),
    ---- private peek
    ["n|<Leader>v"] = map_cu("Vista!!", "Vistaaa"):with_noremap():with_silent(),

    ["n|<RightMouse>"] = map_cmd("<RightMouse><cmd>lua vim.lsp.buf.definition()<CR>", "rightclick def")
        :with_noremap()
        :with_silent(),
    ["n|<C-ScrollWheelUp>"] = map_cmd("<C-i>", "Buf Move"):with_noremap():with_silent(),
    ["n|<C-ScrollWheelDown>"] = map_cmd("<C-o>", "Buf Move"):with_noremap():with_silent(),
}

return plug_map
