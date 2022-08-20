local cmd = vim.cmd
local api = vim.api
local auto_cmd_id = nil
local M = {}
M.loaded_dicts = {}

local has_element = function(table, element, type)
    if type == "value" then
        for index, value in pairs(table) do
            if value == element then
                return true
            end
        end
    elseif type == "index" then
        for index, value in pairs(table) do
            if index == element then
                return true
            end
        end
    end
    return false
end

local remove_element_tbl = function(tbl, element)
    for key, value in pairs(tbl) do
        if value == element then
            tbl[key] = nil
        end
    end
end

M.inoreabbrev = function(l, r)
    vim.cmd({ cmd = "inoreabbrev", args = { l, r } })
end

M.cnoreabbrev = function(l, r)
    vim.cmd({ cmd = "cnoreabbrev", args = { l, r } })
end

M.cnoremap = function(l, r)
    vim.cmd({ cmd = "cnoremap", args = { l, r } })
end

M.unmap_iabbrev = function(element, scope)
    scope = scope or "global"

    if scope == "global" then
        cmd([[iunabbrev ]] .. element)
    elseif scope == "buffer" then
        cmd([[iunabbrev <buffer>]] .. element)
    end
end

M.parse_iabbrev_pr = function(tabl, objective)
    local str_commands = ""

    if objective == "global" then
        for index, value in pairs(tabl) do
            local to_concat = "iabbrev " .. index .. [[ ]] .. value
            cmd(to_concat)
        end
    elseif objective == "buffer" then
        for index, value in pairs(tabl) do
            local to_concat = "iabbrev <buffer> " .. index .. [[ ]] .. value
            cmd(to_concat)
        end
    end

    return str_commands
end

-- require("utils.abbreviations.utils").unload_dict(require("utils.abbreviations.dictionary").python)
function M.load_dict(diction)
    local scope, items = diction.scope, diction.dict
    if scope == "global" then
        for element in pairs(items) do
            M.inoreabbrev(element, items[element])
        end

        table.insert(M.loaded_dicts, diction)
        return
    else
        lambda.augroup("AutoCorrect" .. scope, {
            {
                event = { "BufNewFile", "BufRead", "BufWinEnter" }, -- this seems to be more reliable.
                pattern = { "*." .. scope },
                command = function()
                    M.parse_iabbrev_pr(items, "buffer")
                end,
                once = true,
            },
        })
        table.insert(M.loaded_dicts, diction)
        return
    end
end
function M.unload_dict(diction)
    scope, items = diction.scope, diction.dict
    if has_element(M.loaded_dicts, diction, "value") then
        if string.find(scope, "global") then
            for element in pairs(items) do
                M.unmap_iabbrev(items[element])
            end
        else
            vim.api.nvim_clear_autocmds({ group = "AutoCorrect" .. scope })
            for element in pairs(items) do
                M.unmap_iabbrev(items[element], "buffer")
            end
        end
    end
    remove_element_tbl(M.loaded_dicts, diction)
end

return M