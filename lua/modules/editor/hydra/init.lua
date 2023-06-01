local fmt, api, fn, fs = string.format, vim.api, vim.fn, vim.fs
local when = lambda.lib.when
local hydra_helper = require("core.helper")

local MODULE_PREFIX = "modules.editor.hydra."
local EXCLUDE_TABLE = {
    "init",
    "utils",
    "utils_rewrite",
    "parenth_mode",
}

local test_active = false
if not test_active then
    table.insert(EXCLUDE_TABLE, "hydra_test")
end

local function loadHydraModules(path, prefix)
    local path_list = vim.split(fn.glob(path .. "*.lua", true), "\n")
    for _, path in ipairs(path_list) do
        local name = fn.fnamemodify(path, ":t:r")
        local module_name = prefix .. name
        -- Load the module if it's not in the exclude_table
        when(not vim.tbl_contains(EXCLUDE_TABLE, name), function()
            require(module_name)
        end)
    end
end

local function loadHydraAPI()
    local hydra = require("hydra")
    local api_path = fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/api/"
    local api_list = vim.split(fn.glob(api_path .. "*.lua", true), "\n")
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
end

vim.schedule_wrap(function()
    loadHydraModules(fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/normal/", MODULE_PREFIX .. "normal.")
    loadHydraAPI()
end)()
