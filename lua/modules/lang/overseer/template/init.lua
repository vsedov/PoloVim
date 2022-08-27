local overseer = require("overseer")
local all_templates = require("core.global").modules_dir .. "/lang/overseer/template/"
local when = lambda.lib.when
local test_active = false

local exclude_table = {
    "init",
}

-- this is to check if tests are currently active or not
if not test_active then
    table.insert(exclude_table, "overseer_test")
end

local path_list = vim.split(vim.fn.glob(all_templates .. "*.lua", true), "\n")

for _, path in ipairs(path_list) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    local f = "modules.lang.overseer.template." .. name
    when(not vim.tbl_contains(exclude_table, name), function()
        for _, template in ipairs(require(f)) do
            overseer.register_template(template)
        end
    end)
end
