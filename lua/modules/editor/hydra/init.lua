local fmt = string.format
local api, fn, fs = vim.api, vim.fn, vim.fs

local all_hydras = require("core.helper").get_config_path() .. "/lua/modules" .. "/editor/hydra/"
local when = lambda.lib.when
local test_active = false

-- loader("keymap-layer.nvim gitsigns.nvim")
local exclude_table = {
    "init",
    "utils",
    "utils_rewrite",
    "parenth_mode",
}

-- this is to check if tests are currently active or not
if not test_active then
    table.insert(exclude_table, "hydra_test")
end

local path_list = vim.split(vim.fn.glob(all_hydras .. "*.lua", true), "\n")

for _, path in ipairs(path_list) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    local f = "modules.editor.hydra." .. name
    when(not vim.tbl_contains(exclude_table, name), function()
        vim.defer_fn(function()
            require(f)
        end, 100)
    end)
end
--
local function loadHydraModules(path, prefix)
    local path_list = vim.split(fn.glob(path .. "*.lua", true), "\n")
    for _, path in ipairs(path_list) do
        local name = fn.fnamemodify(path, ":t:r")
        local f = prefix .. name
        when(not vim.tbl_contains(exclude_table, name), function()
            require(f)
        end)
    end
end

-- loadHydraModules(fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/normal/", "modules.editor.hydra.normal.")

vim.defer_fn(function()
    local hydra = require("hydra")
    local api_path = fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/api/"
    local api_list = vim.split(fn.glob(api_path .. "*.lua", true), "\n")
    local M = require("modules.editor.hydra.utils_rewrite")

    local exclude_table = {}
    for _, path in ipairs(api_list) do
        local name = fn.fnamemodify(path, ":t:r")
        local f = "modules.editor.hydra.api." .. name
        when(not vim.tbl_contains(exclude_table, name), function()
            data = require(f)
            local instance = M.new(data[1], data[2])
            local hyd = instance.new_hydra

            hyd.hint = instance:auto_hint_generate(data[3], data[4], data[5], data[6])
            print(hyd.hint)
            hydra(hyd)
        end)
    end
end, 300)
