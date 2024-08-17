local fmt, api, fn, fs = string.format, vim.api, vim.fn, vim.fs
local when = lambda.lib.when
local binds = {}

local MODULE_PREFIX = "lazy_specs.hydra."
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
    local api_path = fn.expand("$HOME") .. "/.config/nvim/lua/lazy_specs/hydra/api/"
    local api_list = vim.split(fn.glob(api_path .. "*.lua", true), "\n")
    local exclude_table = { "init" }

    if lambda.config.movement.movement_type == "flash" then
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

vim.defer_fn(function()
    if lambda.config.editor.hydra.load_api then
        loadHydraAPI()
    end

    if lambda.config.editor.hydra.load_normal then
        loadHydraModules(fn.expand("$HOME") .. "/.config/nvim/lua/lazy_specs/hydra/normal/", MODULE_PREFIX .. "normal.")
    end
    lambda.command("HydraBinds", function()
        local binds_list = {}
        for k, v in pairs(binds) do
            table.insert(binds_list, fmt("%s", k))
        end
        -- print(table.concat(binds_list, "\n"))
        -- Vim.ui.select this and then run that key stroke
        vim.ui.select(binds_list, {
            prompt = "Select a choice",
            -- format_item = function(item)
            --     return binds[item]
            -- end,
        }, function(choice)
            if choice == nil then
                return
            end
            choice = binds[choice]
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(choice, true, false, true), "m", true)
        end)
    end)

    vim.keymap.set("n", "<leader>H", "<cmd>HydraBinds<CR>", { noremap = true, silent = true })
end, 1000)
