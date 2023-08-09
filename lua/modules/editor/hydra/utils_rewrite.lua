local M = {}
M.__index = M

--  TODO: (vsedov) (01:52:42 - 31/05/23): Need to rewrite this section here, could do with a nice
--  rewrite
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
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n" },
    }

    self:buildHeads()
    -- remove on_exit and on_enter from self.config
    self.config[self.name].on_exit = nil
    self.config[self.name].on_enter = nil
    self.config[self.name].on_key = nil

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
        border = function(t, rhs)
            t.config.hint.border = rhs
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
        on_key = function(t, rhs)
            t.config.on_key = rhs
        end,
        on_enter = function(t, rhs)
            t.config.on_enter = rhs
        end,
        on_exit = function(t, rhs)
            t.config.on_exit = rhs
        end,
    }

    for _, spec in pairs(self.config) do
        for lhs, rhs in pairs(spec) do
            local action = mapping[lhs]

            if action == nil then
                table.insert(self.new_hydra.heads, { lhs, table.unpack(rhs) })
            else
                action(self.new_hydra, rhs)
            end
        end
    end
end

function M:addToCoreTable(value)
    table.insert(self.core_table, value)
end

function M:auto_hint_generate(listofcoretables, bracket, cali, cal_v2)
    local container = {}
    local maxLen = 0 -- Variable to store the maximum length of description + bind

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

    local hint_table = {}
    -- local string_val = fmt("^ ^%s%s^ ^\n\n", self.name, string.rep(" ", maxLen - cal_v2)) -- Adjust the alignment of the module name
    local string_val = "^ ^" .. self.name .. "^\n\n"
    string_val = string_val .. "^ ^" .. string.rep("▔", (maxLen + cali) - cal_v2) .. "^ ^\n" -- Adjust the length of the horizontal line
    for _, v in pairs(self.core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint .. "^ ^" .. string.rep("▔", (maxLen + cali) - cal_v2) .. "^ ^\n" -- Adjust the length of the horizontal line
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end

    return string_val
end

return M
