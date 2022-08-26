local all_hydras = require("core.global").modules_dir .. "/editor/hydra/"
local loader = require("packer").loader
local when = lambda.lib.when
local test_active = false

loader("keymap-layer.nvim vgit.nvim gitsigns.nvim")
local exclude_table = {
    "init",
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
        if name == "buffer" then
            require(f).buffer()
        end
        require(f)
    end)
end
