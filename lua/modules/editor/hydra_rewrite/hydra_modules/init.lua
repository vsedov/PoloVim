local fmt = string.format
local api, fn, fs = vim.api, vim.fn, vim.fs
local all_hydras = require("core.helper").get_config_path() .. "/lua/modules" .. "/editor/hydra_rewrite/hydra_modules/"
local neorg_api = lambda.lib
local test_active = false

local exclude_table = {
    "init",
    "readme",
}

-- this is to check if tests are currently active or not
if not test_active then
    table.insert(exclude_table, "hydra_test")
end

local function parser(conf) end

local function setup_module()
    local path_list = vim.split(vim.fn.glob(all_hydras .. "*.lua", true), "\n")

    for _, path in ipairs(path_list) do
        local name = vim.fn.fnamemodify(path, ":t:r")
        neorg_api.when(not vim.tbl_contains(exclude_table, name), function()
            data = require("modules.editor.hydra_rewrite.hydra_modules." .. name)
            parser(data())
        end)
    end
end
setup_module()
