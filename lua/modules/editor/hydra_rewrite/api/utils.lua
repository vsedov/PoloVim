local M = {}
local Hydra = require("hydra")

--- Mx function, parses the feedkeys and type to feedkeys
---@param feedkeys Feedkeys to be parsed
---@param type Mode types, N, V ...
function M.mx(feedkeys, type)
    local type = type or "m"
    return function()
        if type == "v" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, true, true), "n", true)
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feedkeys, true, false, true), type, false)
    end
end

function M.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function M.make_core_table(core_table, second_table)
    for _, v in pairs(second_table) do
        table.insert(core_table, v)
    end
    table.insert(core_table, "\n")
end
--- Create a table with all the options
-- @param var table to be filled Normally empty as we return an empty table
-- @param sorted table with all the options, this is the given binds that we already have
-- @param string_len the length of the string that we want to filter, so xy will be filtered
-- compared to normal x
-- @param start_val the string that we want to start with, so if we want to filter all the items
-- that start with a certain item or valua, this can be ignored.
-- @param ignore a table with all the items that we want to ignore, this can be ignored, funnly
-- enough this is the top level value, so we ignore anything that gets parsed to the very top.
function M.create_table_normal(var, sorted, string_len, start_val, ignore)
    start_val = start_val or nil
    var = {}
    for _, v in pairs(sorted) do
        if string.len(v) == string_len and not vim.tbl_contains(ignore, v) then
            if start_val ~= nil then
                if type(start_val) == "table" then
                    if vim.tbl_contains(start_val, v) then
                        table.insert(var, v)
                    end
                else
                    if M.starts(v, start_val) then
                        table.insert(var, v)
                    end
                end
            else
                table.insert(var, v)
            end
        end
    end
    table.sort(var, function(a, b)
        return a:lower() < b:lower()
    end)

    return var
end

function M.table_contains_table(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" then
            return true
        end
    end
    return false
end

return M
