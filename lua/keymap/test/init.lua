local bind = require("keymap.test.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
local map_key = bind.map_key
local global = require("core.global")

local modes = {
    map_cr = map_cr,
    map_cu = map_cu,
    map_cmd = map_cmd,
    map_args = map_args,
    map_key = map_key,
}

local plug_map = {
    [{ { "i", "n" }, { "<Leader>8", "<Leader>0" } }] = map_cmd(function()
        print("heresdjsdhs")
    end):with_noremap(),

    [{ "n", "<C-]>" }] = map_args("Template"),
    [{ { "i", "s" }, "<TAB>", "test" }] = map_cmd("v:lua.s_tab_complete()"):with_expr(),
}

bind.nvim_load_mapping(plug_map)
-- print(vim.tbl_flatten(plug_map))
