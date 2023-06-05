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
