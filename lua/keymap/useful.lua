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
            vim.cmd("NeoZoomToggle")
            vim.cmd("NeoWellJump") -- you can safely remove this line.
        end, "NeoZoomToggle")
        :with_noremap()
        :with_silent()
        :with_nowait(),

    ["n|<leader>cd"] = map_cmd(lambda.clever_tcd, "Cwd"):with_noremap():with_silent():with_nowait(),
    ["n|<localleader>pP"] = map_cmd("<cmd>StartupTime<cr>", "StartUpTime"):with_noremap():with_silent(),
    ["n|<Leader>e"] = map_cr("NeoTreeFocusToggle", "NeoTree Focus Toggle"):with_noremap():with_silent(),
    ["n|<Leader><leader>d"] = map_cr("Neotree diagnostics", "Diagnostics"):with_noremap():with_silent(),

    ["n|<Leader>F"] = map_cr("NeoTreeFocus", "NeoTree Focus"):with_noremap():with_silent(),

    --  REVISIT: (vsedov) (20:40:02 - 15/09/22): See if this works
    ["n|cc"] = map_cmd("<Cmd>Lspsaga code_action<cr>", "Code action Menu"):with_noremap():with_silent(),
    -- ["n|cc"] = map_cmd("<Cmd>CodeActionMenu<cr>", "Code action Menu"):with_noremap():with_silent(),

    ["x|ga"] = map_cmd("<C-U>Lspsaga range_code_action<CR>", "Code action Menu"):with_noremap():with_silent(),
    --
    ---- private peek
    ["n|<Leader>v"] = map_cu("Vista!!", "Vistaaa"):with_noremap():with_silent(),

    ["n|<RightMouse>"] = map_cmd("<RightMouse><cmd>lua vim.lsp.buf.definition()<CR>", "rightclick def")
        :with_noremap()
        :with_silent(),
}

if lambda.falsy(vim.fn.mapcheck("<ScrollWheelDown>")) then
    vim.keymap.set("n", "<ScrollWheelDown>", "<c-d>", { noremap = true, silent = true })
end
if lambda.falsy(vim.fn.mapcheck("<ScrollWheelUp>")) then
    vim.keymap.set("n", "<ScrollWheelUp>", "<c-u>", { noremap = true, silent = true })
end

return plug_map
