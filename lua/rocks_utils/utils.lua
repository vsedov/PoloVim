---@param file_path string
---@return boolean existed
function rocks.deleteFileIfExists(file_path)
    if vim.fn.filereadable(file_path) == 1 then
        os.remove(file_path)
        return true
    end
    return false
end

function rocks.split_string(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

---Requires plenary
---@param cmd string[]
---@param cwd string
---@return table
---@return unknown
---@return table
function rocks.get_os_command_output(cmd, cwd)
    if type(cmd) ~= "table" then
        print("[get_os_command_output]: cmd has to be a table")
        ---@diagnostic disable-next-line: return-type-mismatch
        return {}, nil, nil
    end
    local command = table.remove(cmd, 1)
    local stderr = {}
    local stdout, ret = require("plenary.job")
        :new({
            command = command,
            args = cmd,
            cwd = cwd,
            on_stderr = function(_, data)
                table.insert(stderr, data)
            end,
        })
        :sync()
    return stdout, ret, stderr
end

function rocks.authTerminal()
    local session
    local handle
    handle = io.popen([[bw login --check ]], "r")
    if handle then
        session = handle:read("*l")
        handle:close()
    end
    if vim.fn.expand("$BW_SESSION") ~= "$BW_SESSION" then
        session = vim.fn.expand("$BW_SESSION")
    else
        if session == "You are logged in!" then
            handle = io.popen([[bw unlock --raw --nointeraction ]] .. vim.fn.inputsecret("Enter password: "), "r")
            if handle then
                session = handle:read("*l")
                handle:close()
            end
        else
            local email = vim.fn.inputsecret("Enter email: ")
            local pass = vim.fn.inputsecret("Enter password: ")
            local client_secret = vim.fn.inputsecret("Enter api key client_secret: ")
            handle = io.popen([[bw login --raw --quiet ]] .. email .. " " .. pass .. ">/dev/null 2>&1", "w")
            if handle then
                handle:write(client_secret)
                handle:close()
            end
            handle = io.popen([[bw unlock --raw --nointeraction ]] .. pass, "r")
            if handle then
                session = handle:read("*l")
                handle:close()
            end
        end
    end
    return session
end

---@param plugin_names string[]|string
function rocks.safe_packadd(plugin_names)
    local names
    if type(plugin_names) == "table" then
        names = plugin_names
    elseif type(plugin_names) == "string" then
        names = { plugin_names }
    else
        return
    end
    for _, name in ipairs(names) do
        if type(name) == "string" then
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok, err = pcall(vim.cmd, "packadd " .. name)
            if not ok then
                vim.notify(
                    "packadd " .. name .. " failed: " .. err,
                    vim.log.levels.WARN,
                    { title = "birdee.utils.safe_packadd_list" }
                )
            end
        end
    end
end

---@param plugin_names string[]|string
function rocks.safe_force_packadd(plugin_names)
    local names
    if type(plugin_names) == "table" then
        names = plugin_names
    elseif type(plugin_names) == "string" then
        names = { plugin_names }
    else
        return
    end
    for _, name in ipairs(names) do
        if type(name) == "string" then
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok, err = pcall(vim.cmd, "packadd! " .. name)
            if not ok then
                vim.notify(
                    "packadd " .. name .. " failed: " .. err,
                    vim.log.levels.WARN,
                    { title = "birdee.utils.safe_force_packadd_list" }
                )
            end
        end
    end
end

---@param plugin_names string[]|string
function rocks.packadd_with_after_dirs(plugin_names)
    local names
    if type(plugin_names) == "table" then
        names = plugin_names
    elseif type(plugin_names) == "string" then
        names = { plugin_names }
    else
        return
    end
    local to_source = {}
    for _, name in ipairs(names) do
        if type(name) == "string" then
            ---@diagnostic disable-next-line: param-type-mismatch
            local ok, err = pcall(vim.cmd, "packadd " .. name)
            if not ok then
                vim.notify(
                    "packadd " .. name .. " failed: " .. err,
                    vim.log.levels.WARN,
                    { title = "rocks.utils.safe_packadd_list" }
                )
            else
                table.insert(to_source, name)
            end
        end
    end
end

---@param str any
---@param prefix any
---@return boolean
function rocks.starts_with(str, prefix)
    if str == nil or prefix == nil then
        return false
    end
    return string.sub(str, 1, string.len(prefix)) == prefix
end
