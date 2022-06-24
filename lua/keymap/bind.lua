local rhs_options = {}

function rhs_options:new()
    local instance = {
        cmd = "",
        description = "",
        options = { noremap = false, silent = false, expr = false, nowait = false },
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function rhs_options:map_cmd(cmd_string, description)
    description = description or nil
    self.cmd = cmd_string
    self.description = description
    return self
end

function rhs_options:map_cr(cmd_string, description)
    description = description or nil

    self.cmd = (":%s<CR>"):format(cmd_string)
    self.description = description
    return self
end

function rhs_options:map_args(cmd_string, description)
    description = description or nil

    self.cmd = (":%s<Space>"):format(cmd_string)
    self.description = description
    return self
end

function rhs_options:map_cu(cmd_string, description)
    description = description or nil

    self.cmd = (":<C-u>%s<CR>"):format(cmd_string)
    self.description = description
    return self
end

function rhs_options:map_key(key_string, description)
    description = description or nil

    self.cmd = ("%s"):format(key_string)
    self.description = description
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

function pbind.map_cr(cmd_string, description)
    local ro = rhs_options:new()
    return ro:map_cr(cmd_string, description)
end

function pbind.map_cmd(cmd_string, description)
    local ro = rhs_options:new()
    return ro:map_cmd(cmd_string, description)
end

function pbind.map_cu(cmd_string, description)
    local ro = rhs_options:new()
    return ro:map_cu(cmd_string, description)
end

function pbind.map_key(keystr, description)
    local ro = rhs_options:new()
    return ro:map_key(keystr, description)
end

function pbind.map_args(cmd_string, description)
    local ro = rhs_options:new()
    return ro:map_args(cmd_string, description)
end

pbind.all_keys = {}
function pbind.nvim_load_mapping(mapping)
    for key, value in pairs(mapping) do
        --  Regex is faster for some reason than {{..},.. } or {..,{..}}
        local mode, keymap = key:match("([^|]*)|?(.*)")
        local opts
        if value.description ~= nil then
            opts = vim.tbl_extend("keep", value.options, { desc = value.description })
        else
            opts = value.options
        end
        for i = 1, #mode do
            if type(value) == "table" then
                vim.keymap.set(mode:sub(i, i), keymap, value.cmd, opts)
            elseif type(value) == "string" then
                vim.keymap.set(mode:sub(i, i), keymap, value.cmd, {})
            end
        end
    end
end
return pbind
