local bind = require("keymap.test.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
local map_key = bind.map_key
local global = require("core.global")

local plug_map = {
    [{ { "i", "n" }, { "<Leader>8" } }] = map_cmd(function()
        print("heresdjsdhs")
    end):with_noremap(),
}
-- mode {
--   bind = "x",
--   map = { "i", "n" }
-- }
-- map {
--   bind = "x",
--   map = { "i", "n" }
-- }
bind.nvim_load_mapping(plug_map)
-- print(vim.tbl_flatten(plug_map))
