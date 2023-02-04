local fmt = string.format
local api, fn, fs = vim.api, vim.fn, vim.fs
local all_hydras = require("core.helper").get_config_path()
    .. "/lua/modules"
    .. "/editor/hydra_rewrite/hydra_modules/auto/"
local neorg_api = lambda.lib
local test_active = false
local hydra = require("hydra")
--
local exclude_table = {
    "readme",
    "init",
}

-- this is to check if tests are currently active or not
if not test_active then
    table.insert(exclude_table, "hydra_test")
end

local function setup_module()
    for _, path in ipairs(vim.split(vim.fn.glob(all_hydras .. "*.lua", true), "\n")) do
        local name = vim.fn.fnamemodify(path, ":t:r")
        x = require("modules.editor.hydra_rewrite.hydra_modules.auto." .. name)
        data = x
        require("modules.editor.hydra_rewrite.api.api").parser(data)
    end
end
setup_module()
