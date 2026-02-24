local utils = {}
local function is_visual_mode()
    local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    return vim.tbl_contains({ "v", "V", "x" }, mode)
end

local function exit_visual_mode()
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
    vim.api.nvim_feedkeys(esc, "x", false)
end

local function run_on_visual_selection(function_call)
    if is_visual_mode() then
        exit_visual_mode()
    end
    if type(function_call) == "function" then
        return function_call()
    end
    vim.cmd("'<,'>" .. function_call)
end

function utils.visual_mode(function_call)
    -- mode
    return run_on_visual_selection(function_call)
end

function utils.run_visual_or_normal(function_call)
    if is_visual_mode() then
        return run_on_visual_selection(function_call)
    else
        if type(function_call) == "function" then
            return function_call()
        end
        return vim.cmd(function_call)
    end
end

function utils.defer_function(function_call, args, delay)
    if args == nil then
        args = ""
    end
    vim.defer_fn(function()
        vim.cmd(function_call .. args)
    end, delay)
end

--  TODO: (vsedov) (14:36:49 - 15/02/24): Do this
function utils.total_binds(config) end

return utils
