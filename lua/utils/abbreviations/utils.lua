local cmd = vim.cmd
local api = vim.api
local M = {}
local abbrevs = require("utils.abbreviations.dictionary")

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
    vim.keymap.set("ia", l, r, { noremap = true })
end

M.cnoreabbrev = function(l, r)
    vim.cmd({ cmd = "cnoreabbrev", args = { l, r } })
    -- vim.keymap.set("ca", l, r)
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
            vim.cmd("iabbrev <buffer> " .. index .. [[ ]] .. value)
        end
    end

    return str_commands
end

function M.load_dict(diction)
    local scope, items = diction.scope, diction.dict
    if scope == "global" then
        for element in pairs(items) do
            M.inoreabbrev(element, items[element])
        end

        table.insert(M.loaded_dicts, diction)
        return
    end
end

function M.unload_dict(diction)
    local scope, items = diction.scope, diction.dict
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

function M.load_filetypes()
    for _, value in ipairs(lambda.config.abbrev.languages) do
        if abbrevs[value] ~= nil then
            local scope = abbrevs[value].scope
            local dictions = abbrevs[value].dict
            lambda.augroup("Abbrev" .. scope, {
                {
                    event = "FileType",
                    pattern = { scope },
                    command = function()
                        lprint("Loading abbreviations for " .. scope .. " with buffer " .. api.nvim_get_current_buf())
                        M.parse_iabbrev_pr(dictions, "buffer")
                    end,
                },
            })
        end
    end
end

return M
