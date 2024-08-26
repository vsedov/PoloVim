local toml = require("toml")
local luv = require("luv")

-- Function to read the TOML file
local function read_toml_file(file_path)
    local file = io.open(file_path, "r")
    if not file then
        error("Could not open file: " .. file_path)
    end

    local content = file:read("*all")
    file:close()
    -- return toml.parse(content)
    return toml.parse(content)
end

-- Function to perform Rocks! update
local function update_plugin(plugin_name)
    print("Updating plugin: " .. plugin_name)
    local handle = io.popen("Rocks! update " .. plugin_name)
    local result = handle:read("*a")
    handle:close()
    print(result)
end

-- Function to run updates concurrently
local function concurrent_updates(plugins)
    local threads = {}

    for plugin_name, _ in pairs(plugins) do
        local thread = luv.new_thread(update_plugin, plugin_name)
        table.insert(threads, thread)
    end

    for _, thread in ipairs(threads) do
        luv.thread_join(thread)
    end
end

-- Main function
local function main()
    local config = read_toml_file("rocks.toml")

    -- Combine all plugin tables (regular plugins and git plugins)
    local all_plugins = {}

    for section, plugins in pairs(config) do
        if section:find("plugins") then
            for plugin_name, _ in pairs(plugins) do
                print("Adding plugin: " .. plugin_name)
                all_plugins[plugin_name] = true
            end
        end
    end
end

main()
