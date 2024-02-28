local fmt, api, fn, fs = string.format, vim.api, vim.fn, vim.fs
local when = lambda.lib.when
local binds = {}

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
            require(module_name)
        end)
    end
end

local function loadHydraAPI()
    local api_path = fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/api/"
    local api_list = vim.split(fn.glob(api_path .. "*.lua", true), "\n")
    local exclude_table = { "init" }

    if lambda.config.movement.movement_type == "flash" then
        table.insert(exclude_table, "leap") -- we stilll use leap ?
    end

    -- if not (lambda.config.ai.tabnine.use_tabnine and lambda.config.ai.tabnine.use_tabnine_insert) then
    --     table.insert(exclude_table, "tabnine")
    -- end

    for _, path in ipairs(api_list) do
        local name = fn.fnamemodify(path, ":t:r")
        -- if name ~= "harpoon" then
        --     table.insert(exclude_table, name)
        -- end
        -- if not vim.tbl_contains({"harpoon", "fold", "treeclimber"}, name) then
        --     table.insert(exclude_table, name)
        --
        -- end

        local module_name = MODULE_PREFIX .. "api." .. name

        when(not vim.tbl_contains(exclude_table, name), function()
            local data = require(module_name)
            binds[name] = data[1][data[2]].body

            require(MODULE_PREFIX .. "make_hydra").make_hydra(data)
        end)
    end
end

if lambda.config.editor.hydra.load_api then
    loadHydraAPI()
end

if lambda.config.editor.hydra.load_normal then
    loadHydraModules(fn.expand("$HOME") .. "/.config/nvim/lua/modules/editor/hydra/normal/", MODULE_PREFIX .. "normal.")
end

lambda.command("HydraBinds", function()
    local binds_list = {}
    for k, v in pairs(binds) do
        table.insert(binds_list, fmt("%s: %s", k, v))
    end
    print(table.concat(binds_list, "\n"))
end)
