local M = {}
M.__index = M

function M.new(config, module_name)
    local self = setmetatable({}, M)
    self.config = config or {}
    self.name = module_name
    self.core_table = {}
    self.new_hydra = {
        name = self.name,
        hint = "",
        config = {
            hint = {
                position = "bottom-right",
                float_opts = {
                    border = lambda.style.border.type_0,
                    style = "minimal",
                    focusable = true,
                    noautocmd = true,
                },
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n" },
    }

    self:buildHeads()

    -- Handle funcs if present
    if self.config[self.name].funcs then
        if type(self.config[self.name].funcs.on_enter) == "function" then
            self.new_hydra.config.on_enter = self.config[self.name].funcs.on_enter
        end
        if type(self.config[self.name].funcs.on_exit) == "function" then
            self.new_hydra.config.on_exit = self.config[self.name].funcs.on_exit
        end
        if type(self.config[self.name].funcs.on_key) == "function" then
            self.new_hydra.config.on_key = self.config[self.name].funcs.on_key
        end
        -- Remove funcs from self.config to avoid processing them as heads
        self.config[self.name].funcs = nil
    end

    return self
end

function M:buildHeads()
    local mapping = {
        color = function(t, rhs)
            t.config.color = rhs
        end,
        body = function(t, rhs)
            t.body = rhs
        end,
        position = function(t, rhs)
            t.config.hint.position = rhs
        end,
        mode = function(t, rhs)
            t.mode = rhs
        end,
        invoke_on_body = function(t, rhs)
            t.config.invoke_on_body = rhs
        end,
        timeout = function(t, rhs)
            t.config.timeout = rhs
        end,
        foreign_keys = function(t, rhs)
            t.config.foreign_keys = rhs
        end,
        buffer = function(t, rhs)
            t.config.buffer = rhs
        end,
        float_opts = function(t, rhs)
            t.config.hint.float_opts = rhs
        end,
        desc = function(t, rhs)
            t.config.desc = rhs
        end,
    }

    for _, spec in pairs(self.config) do
        for lhs, rhs in pairs(spec) do
            local action = mapping[lhs]
            if action then
                action(self.new_hydra, rhs)
            elseif type(rhs) == "table" and #rhs >= 2 then
                table.insert(self.new_hydra.heads, { lhs, rhs[1], rhs[2] })
            elseif lhs ~= "funcs" then
                print("Warning: Unexpected configuration for " .. lhs)
            end
        end
    end
end
function M:addToCoreTable(value)
    table.insert(self.core_table, value)
end
local vim = vim -- Assuming you're in the Neovim environment

local max_hint_length = 30

function M:auto_hint_generate(listofcoretables, bracket, cali, cal_v2, column)
    column = column or 2 -- If not provided, default to 2

    local container = {}

    local maxLen = 0 -- Variable to store the maximum length of description + bind
    if column == 1 then
        maxLen = 0
    else
        maxLen = max_hint_length
        cal_v2 = 0
        cali = 10
    end

    local function updateContainer(mapping, description)
        container[mapping] = description
        local len = string.len(mapping) + string.len(description)
        if len > maxLen then
            maxLen = len
        end
    end
    for x, y in pairs(self.config[self.name]) do
        local mapping = x
        local desc = ""
        if type(y) == "function" then
        else
            if type(y[1]) == "function" then
                desc = y[2].desc
            else
                if type(y[2]) == "table" then
                    desc = y[2].desc
                else
                    desc = y[2]
                end
            end

            if desc then
                updateContainer(mapping, desc)
            end
        end
    end

    local sorted = {}
    for k, v in pairs(container) do
        table.insert(sorted, k)
    end
    table.sort(sorted)

    for _, v in pairs(bracket) do
        self:addToCoreTable(v)
    end

    self:addToCoreTable("\n")
    for _, v in pairs(listofcoretables) do
        if type(v) == "table" then
            for _, item in ipairs(v) do
                self:addToCoreTable(item)
            end
        else
            self:addToCoreTable(v)
        end
        self:addToCoreTable("\n")
    end
    -- string_val = string_val .. "^ ^\n" .. string.rep("▔", (maxLen + cali) - cal_v2) .. "^ ^\n"

    local columns = math.floor(vim.api.nvim_get_option_value("columns", {}) / max_hint_length)

    local hint_table = {}
    local string_val = "^ ^" .. self.name .. "^\n\n"
    -- string_val = string_val .. "^ ^"
    -- .. string.rep("▔", (maxLen + cali)) .. "^ ^\n" -- Adjust the length of the horizontal line

    local line = "" -- to store current line being built
    local count = 0 -- to track how many items have been added in the current line
    for _, v in pairs(self.core_table) do
        if v == "\n" then
            table.insert(hint_table, line) -- insert the current line to hint_table
            string_val = string_val .. line .. "\n"

            -- Add the divider and reset the line and count
            table.insert(hint_table, "^ ^\n")
            line = ""
            count = 0
        else
            if container[v] then
                -- if
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^"
                -- Check if this hint is larger than the max_hint_length then we have to cap v to
                -- a limit of 5 or something
                if string.len(hint) > max_hint_length then
                    hint = "^ ^ _" .. v .. "_: " .. string.sub(container[v], 1, max_hint_length - 15) .. ". ^ ^"
                end
                count = count + 1

                if count < column then
                    line = line .. hint .. string.rep(" ", max_hint_length - string.len(hint))
                else
                    line = line .. hint
                    table.insert(hint_table, line) -- insert the current line to hint_table
                    string_val = string_val .. line .. "\n"
                    line = "" -- reset the line
                    count = 0 -- reset the count
                end
            end
        end
    end

    return string_val
end

return M
