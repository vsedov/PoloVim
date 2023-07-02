local current_dir = vim.fn.expand(vim.fn.stdpath("config") .. "/lua/modules/movement/flash/keybinds")
local keybinds = {}

local function add_keybinds(keybinds_list)
    for _, keybind in ipairs(keybinds_list) do
        table.insert(keybinds, keybind)
    end
end
local function walk_dir(dir)
    local files = vim.fn.readdir(dir)
    for _, file in ipairs(files) do
        if file ~= "init.lua" then
            local path = dir .. "/" .. file
            local stat = vim.loop.fs_stat(path)
            if stat.type == "directory" then
                walk_dir(path)
            else
                local keybinds_list = require("modules.movement.flash.keybinds." .. file:gsub(".lua", ""))
                add_keybinds(keybinds_list)
            end
        end
    end
end

walk_dir(current_dir)
return keybinds
