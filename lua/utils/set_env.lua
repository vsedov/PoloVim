local M = {}

local job = require("plenary").job

local confs
local prefix
local port

local function get_new_port()
    local port
    local file = io.open("/tmp/PORT", "r")
    if file then
        port = tonumber(file:read("*a"))
        file:close()
    else
        port = 3000
    end
    file = io.open("/tmp/PORT", "w")
    if not file then
        return
    end
    file:write(tostring(port + 1))
    file:close()
    return port
end

function dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    if #objects == 0 then
        print("nil")
    end
    print(unpack(objects))
    return ...
end
local function set_var(name, command, args)
    job
        :new({
            command = command,
            args = args,
            on_exit = function(j)
                M.env[name] = j:result()[1]
            end,
        })
        :start()
end

local function from_pass(path)
    job
        :new({
            command = "pass",
            args = { "show", "env/" .. path },
            on_exit = function(j)
                for _, row in ipairs(j:result()) do
                    if row:sub(1, 1) ~= "#" then
                        local col = string.find(row, "=", 1, true)
                        if col then
                            local name = row:sub(1, col - 1)
                            local value = row:sub(col + 1)
                            M.env[name] = value
                        end
                    end
                end
            end,
        })
        :start()
end

local function apply_conf(conf)
    for name, value in pairs(conf) do
        if type(value) == "table" then
            set_var(name, unpack(value))
        else
            M.env[name] = value
        end
    end
end

function M.set_env()
    local pwd = vim.env.PWD
    M.env = {}
    for path, conf in pairs(confs) do
        if prefix .. path == pwd then
            if port then
                M.env.port = get_new_port()
            end
            from_pass(path)
            apply_conf(conf)
            break
        end
    end
end

function M.setup(t)
    t = t or {}
    prefix = t.prefix or ""
    confs = t.confs or {}
    port = t.port
end

return M
