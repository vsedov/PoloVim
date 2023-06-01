local api, fn, fs = vim.api, vim.fn, vim.fs
local hydra_helper = require("core.helper")
local when = lambda.lib.when

local hydra = require("hydra")
local api_path = fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/api/"
local api_list = vim.split(fn.glob(api_path .. "*.lua", true), "\n")
local MODULE_PREFIX = "modules.editor.hydra."
local M = require(MODULE_PREFIX .. "utils_rewrite")
local exclude_table = { "init" }

for _, path in ipairs(api_list) do
    local name = fn.fnamemodify(path, ":t:r")
    local module_name = MODULE_PREFIX .. "api." .. name

    when(not vim.tbl_contains(exclude_table, name), function()
        data = require(module_name)
        local instance = M.new(data[1], data[2])
        local hyd = instance.new_hydra
        hyd.hint = instance:auto_hint_generate(data[3], data[4], data[5], data[6])
        print(hyd.hint)
        vim.defer_fn(function()
            hydra(hyd)
        end, 100)
    end)
end
