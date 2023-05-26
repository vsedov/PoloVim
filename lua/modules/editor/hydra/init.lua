local fmt = string.format
local api, fn, fs = vim.api, vim.fn, vim.fs

local all_hydras = require("core.helper").get_config_path() .. "/lua/modules" .. "/editor/hydra/"
local when = lambda.lib.when

-- loader("keymap-layer.nvim gitsigns.nvim")
local exclude_table = {
    "init",
    "utils",
    "parenth_mode",
}

local path_list = vim.split(vim.fn.glob(all_hydras .. "*.lua", true), "\n")

for _, path in ipairs(path_list) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    local f = "modules.editor.hydra." .. name
    when(not vim.tbl_contains(exclude_table, name), function()
        vim.schedule_wrap(require(f))
    end)
end
