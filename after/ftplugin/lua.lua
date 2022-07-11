local fn = vim.fn
local fmt = string.format

local function find(word, ...)
    for _, str in ipairs({ ... }) do
        local match_start, match_end = string.find(word, str)
        if match_start then
            return str, match_start, match_end
        end
    end
end

--- Stolen from nlua.nvim this function attempts to open
--- vim help docs if an api or vim.fn function otherwise it
--- shows the lsp hover doc
--- @param word string
--- @param callback function
local function keyword(word, callback)
    local original_iskeyword = vim.bo.iskeyword

    vim.bo.iskeyword = vim.bo.iskeyword .. ",."
    word = word or fn.expand("<cword>")

    vim.bo.iskeyword = original_iskeyword

    -- TODO: This is a sub par work around, since I usually rename `vim.api` -> `api` or similar
    -- consider maybe using treesitter in the future
    local api_match = find(word, "api", "vim.api")
    local fn_match = find(word, "fn", "vim.fn")
    if api_match then
        local _, finish = string.find(word, api_match .. ".")
        local api_function = string.sub(word, finish + 1)

        vim.cmd(string.format("help %s", api_function))
        return
    elseif fn_match then
        local _, finish = string.find(word, fn_match .. ".")
        if not finish then
            return
        end
        local api_function = string.sub(word, finish + 1) .. "()"

        vim.cmd(string.format("help %s", api_function))
        return
    elseif callback then
        callback()
    else
        vim.lsp.buf.hover()
    end
end

vim.keymap.set("n", "gK", keyword, { buffer = 0 })
vim.opt_local.textwidth = 100
vim.opt_local.formatoptions:remove("o")
vim.o.smarttab = true

--- Returns the item that matches the first item in statements
---@param value any #The value to compare against
---@param compare? function #A custom comparison function
---@return function #A function to invoke with a table of potential matches
local match = function(value, compare)
    -- Returning a function allows for such syntax:
    -- match(something) { ..matches.. }
    return function(statements)
        if value == nil then
            return
        end

        -- Set the comparison function
        -- A comparison function may be required for more complex
        -- data types that need to be compared against another static value.
        -- The default comparison function compares booleans as strings to ensure
        -- that boolean comparisons work as intended.
        compare = compare
            or function(lhs, rhs)
                if type(lhs) == "boolean" then
                    return tostring(lhs) == rhs
                end

                return lhs == rhs
            end

        -- Go through every statement, compare it, and perform the desired action
        -- if the comparison was successful
        for case, action in pairs(statements) do
            if compare(value, case) then
                -- The action can be a function, in which case it is invoked
                -- and the return value of that function is returned instead.
                if type(action) == "function" then
                    return action(value)
                end

                return action
            end
        end

        -- If we've fallen through all statements to check and haven't found
        -- a single match then see if we can fall back to a `_` clause instead.
        if statements._ then
            local action = statements._

            if type(action) == "function" then
                return action(value)
            end

            return action
        end
    end
end
local editing = function(options)
    local function set_options(keys, value)
        return function()
            for _, key in ipairs(keys) do
                vim.opt_local[key] = value
            end
        end
    end

    for key, value in pairs(options) do
        match(key)({
            indent = set_options({ "shiftwidth", "tabstop", "softtabstop" }, value),
            spaces = set_options({ "expandtab" }, value),
        })
    end
end
editing({
    indent = 4,
    spaces = true,
})
