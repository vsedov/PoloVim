local rhs_options = {}

function rhs_options:new()
    local instance = {
        cmd = "",
        options = { noremap = false, silent = false, expr = false, nowait = false },
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function rhs_options:map_cmd(cmd_string)
    self.cmd = cmd_string
    return self
end

function rhs_options:map_cr(cmd_string)
    self.cmd = (":%s<CR>"):format(cmd_string)
    return self
end

function rhs_options:map_args(cmd_string)
    self.cmd = (":%s<Space>"):format(cmd_string)
    return self
end

function rhs_options:map_cu(cmd_string)
    self.cmd = (":<C-u>%s<CR>"):format(cmd_string)
    return self
end

function rhs_options:map_key(key_string)
    self.cmd = ("%s"):format(key_string)
    return self
end

function rhs_options:with_silent()
    self.options.silent = true
    return self
end

function rhs_options:with_noremap()
    self.options.noremap = true
    return self
end

function rhs_options:with_expr()
    self.options.expr = true
    return self
end

function rhs_options:with_nowait()
    self.options.nowait = true
    return self
end

local pbind = {}

function pbind.map_cr(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cr(cmd_string)
end

function pbind.map_cmd(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cmd(cmd_string)
end

function pbind.map_cu(cmd_string)
    local ro = rhs_options:new()
    return ro:map_cu(cmd_string)
end

function pbind.map_key(keystr)
    local ro = rhs_options:new()
    return ro:map_key(keystr)
end

function pbind.map_args(cmd_string)
    local ro = rhs_options:new()
    return ro:map_args(cmd_string)
end

-- pbind.all_keys = {}
-- function pbind.nvim_load_mapping(mapping)
--     for bind, value in pairs(mapping) do
--         if type(bind[2]) == "string" then
--             --              mode     keybind   cmd       options
--             vim.keymap.set(bind[1], bind[2], value.cmd, value.options)
--         elseif type(bind[2]) == "table" then
--             for _, key in pairs(bind[2]) do
--                 vim.keymap.set(bind[1], key, value.cmd, value.options)
--             end
--         end
--     end
-- end

-- useing memoisation to avoid duplicate keybinds
function pbind.nvim_load_mapping(mapping)
    -- [ {x, y} ] = cmd
    local memo = {}
    for bind, value in pairs(mapping) do
        if type(bind[2]) == "string" then
            --              mode     keybind   cmd       options
            if not memo[bind[1]] then
                memo[bind[1]] = {}
            end
            memo[bind[1]][bind[2]] = value
            vim.keymap.set(bind[1], bind[2], value.cmd, value.options)
        elseif type(bind[2]) == "table" then
            for _, key in pairs(bind[2]) do
                if not memo[bind[1]] then
                    memo[bind[1]] = {}
                end
                memo[bind[1]][key] = value
            end
        end
        -- make bind
    end
end

return pbind

-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, rhs, options) 93
-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, value, {}) 95
