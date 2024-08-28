local function read_rocks_toml(file_path)
    local file = io.open(file_path, "r")
    if not file then
        return nil, "Could not open rocks.toml file"
    end

    local plugins = {}
    local in_plugins_section = false
    local current_plugin = nil

    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$") -- Trim whitespace

        -- Check if we're entering the plugins section
        if line:match("^%[plugins%]$") then
            in_plugins_section = true
        elseif in_plugins_section then
            -- Exit when we hit a new section
            if line:match("^%[.*%]$") then
                current_plugin = nil
                in_plugins_section = false
            end

            -- Start a new plugin entry
            local plugin_name = line:match('^"([^"]+)"') or line:match("^(%S+)%s*=")
            if plugin_name then
                current_plugin = plugin_name
                plugins[current_plugin] = {}
            elseif current_plugin then
                -- Handle options like git, rev, opt under the current plugin
                local key, value = line:match("^%s*(%S+)%s*=%s*(.+)%s*$")
                if key and value then
                    plugins[current_plugin][key] = value:gsub('"', "") -- Remove quotes around values
                end
            end
        end
    end

    file:close()
    return plugins, nil
end

local function is_installed(plugin_name)
    local rocks_file = "/home/viv/.config/nvim/rocks.toml"
    local file = io.open(rocks_file, "r")
    if not file then
        return false
    end

    local in_plugins_section = false
    for line in file:lines() do
        if line:match("%[plugins%]") then
            in_plugins_section = true
        elseif in_plugins_section and line:match("%[.*%]") then
            break
        end

        if in_plugins_section and line:match('"%s*' .. plugin_name .. '%s*"') then
            file:close()
            return true
        end
    end

    file:close()
    return false
end

local function execute_command_and_check(cmd, plugin_name, opt)
    return coroutine.create(function()
        if opt then
            cmd = cmd .. " opt=true"
        end
        vim.cmd(cmd)
        coroutine.yield()
        if is_installed(plugin_name) then
            print(plugin_name .. " updated successfully.")
        else
            print("Failed to update " .. plugin_name)
        end
    end)
end

local function run_tasks(tasks)
    local co = coroutine.create(function()
        for _, task in ipairs(tasks) do
            coroutine.resume(task)
        end
    end)

    local function step()
        if coroutine.status(co) ~= "dead" then
            coroutine.resume(co)
            vim.defer_fn(step, 20000) -- Adjust delay as needed
        end
    end

    step()
end

local function update_plugins()
    local rocks_file = "/home/viv/.config/nvim/rocks.toml" -- Adjust the path to your rocks.toml
    local plugins, err = read_rocks_toml(rocks_file)

    if not plugins then
        print("Error reading rocks.toml: " .. err)
        return
    end
    function tablelength(T)
        local count = 0
        for _ in pairs(T) do
            count = count + 1
        end
        return count
    end
    print(tablelength(plugins))

    -- local tasks = {}
    -- for plugin_name, options in pairs(plugins) do
    --     local short_name = plugin_name:match("[^/]+$") -- Extracts the "plugin_name.nvim" from "author/plugin_name.nvim"
    --     local cmd = "Rocks! update " .. short_name
    --
    --     -- Add options like rev and opt
    --     if options.rev then
    --         cmd = cmd .. " rev=" .. options.rev
    --     end
    --     if options.opt == "true" then
    --         table.insert(tasks, execute_command_and_check(cmd, short_name, true))
    --     else
    --         table.insert(tasks, execute_command_and_check(cmd, short_name, false))
    --     end
    -- end
    --
    -- run_tasks(tasks)
end

-- Run the update function
update_plugins()
