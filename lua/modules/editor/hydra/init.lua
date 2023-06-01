-- Aliases
local fmt = string.format
local api, fn, fs = vim.api, vim.fn, vim.fs

local hydra_helper = require("core.helper")
local when = lambda.lib.when

local HYDRA_PATH = hydra_helper.get_config_path() .. "/lua/modules" .. "/editor/hydra/"
local MODULE_PREFIX = "modules.editor.hydra."

local exclude_table = {
    "init",
    "utils",
    "utils_rewrite",
    "parenth_mode",
}

local test_active = false
if not test_active then
    table.insert(exclude_table, "hydra_test")
end

-- Function to load hydra modules
local function loadHydraModules(path, prefix)
    local path_list = vim.split(fn.glob(path .. "*.lua", true), "\n")
    for _, path in ipairs(path_list) do
        local name = fn.fnamemodify(path, ":t:r")
        local module_name = prefix .. name
        -- Load the module if it's not in the exclude_table
        when(not vim.tbl_contains(exclude_table, name), function()
            require(module_name)
        end)
    end
end

vim.schedule_wrap(function()
    -- Load the hydra modules
    loadHydraModules(HYDRA_PATH, MODULE_PREFIX)
    loadHydraModules(fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/normal/", MODULE_PREFIX .. "normal.")
    require("modules.editor.hydra.api")
end)()
