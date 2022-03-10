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

pbind.all_keys = {}
function pbind.nvim_load_mapping(mapping)
    for bind, value in pairs(mapping) do
        local options = value.options
        local rhs = value.cmd
        if type(bind[2]) == "string" then
            vim.keymap.set(bind[1], bind[2], rhs, options)
            table.insert(pbind.all_keys, ("<%s | %s> | %s"):format(vim.inspect(bind[1]), bind[2], vim.inspect(rhs)))
        elseif type(bind[2]) == "table" then
            local function map_wrapper(map_key)
                vim.keymap.set(bind[1], map_key, rhs, options)
                table.insert(
                    pbind.all_keys,
                    ("<%s | %s> | %s"):format(vim.inspect(bind[1]), vim.inspect(map_key), vim.inspect(rhs))
                )
            end
            for _, key in pairs(bind[2]) do
                map_wrapper(key)
            end
        end
    end
end

return pbind
