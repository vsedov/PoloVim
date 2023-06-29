local fmt, api, fn, fs = string.format, vim.api, vim.fn, vim.fs
local when = lambda.lib.when

local MODULE_PREFIX = "modules.editor.hydra."
local EXCLUDE_TABLE = {
    "init",
    "utils_rewrite",
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
            local ok, err = pcall(require, module_name)
            if not ok then
                print(fmt("Error while loading Hydra module '%s': %s", module_name, err))
            end
        end)
    end
end

local function loadHydraAPI()
    local hydra = require("hydra")
    local api_path = fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/api/"
    local api_list = vim.split(fn.glob(api_path .. "*.lua", true), "\n")
    local M = require(MODULE_PREFIX .. "utils_rewrite")
    local exclude_table = { "init" }
    if lambda.config.movement.movement_type == "flash" then
        table.insert(exclude_table, "leap")
    end

    for _, path in ipairs(api_list) do
        local name = fn.fnamemodify(path, ":t:r")
        local module_name = MODULE_PREFIX .. "api." .. name

        when(not vim.tbl_contains(exclude_table, name), function()
            local ok, data = pcall(require, module_name)
            if not ok then
                vim.notify(fmt("Error while loading Hydra API module '%s': %s", module_name, data), vim.log.levels.ERROR, {
                    title = "Hydra Error",
                })
                return
            end
            local instance = M.new(data[1], data[2])
            local hyd = instance.new_hydra
            -- hyd.hint = instance:auto_hint_generate(data[3], data[4], data[5], data[6])
            local hint_ok, hint = pcall(instance.auto_hint_generate, instance, data[3], data[4], data[5], data[6])
            if not hint_ok then
                vim.notify(fmt("Error while generating hint for Hydra '%s'", hyd.name), vim.log.levels.ERROR, {
                    title = "Hydra Error",
                })
                return
            end
            hyd.hint = hint
            vim.defer_fn(function()
                local ok, err = pcall(hydra, hyd)
                if not ok then
                    vim.notify(fmt("Error while running Hydra '%s': %s", hyd.name, err), vim.log.levels.ERROR, {
                        title = "Hydra Error",
                    })
                end
            end, 100)
        end)
    end
end

vim.schedule_wrap(function()
    loadHydraModules(fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/normal/", MODULE_PREFIX .. "normal.")
    loadHydraAPI()
    require("modules.editor.hydra.after.lsp")
end)()
