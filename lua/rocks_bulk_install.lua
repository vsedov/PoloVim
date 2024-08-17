local test = {
    "danymat/neogen",
    "L3MON4D3/LuaSnip",
    "prichrd/refgo.nvim",
    "amrbashir/nvim-docs-view",
    "KabbAmine/zeavim.vim",
    "romainl/vim-devdocs",
    "loganswartz/updoc.nvim",
    "lalitmee/browse.nvim",
    "nvim-telescope/telescope.nvim",
    "piersolenski/wtf.nvim",
    "dpayne/CodeGPT.nvim",
}
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
            print(plugin_name .. " installed successfully.")
        else
            print("Failed to install " .. plugin_name)
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

local tasks = {}
for _, plugin in ipairs(test) do
    local short_name = plugin:match("[^/]+$") -- Extracts the "plugin_name.nvim" from "author/plugin_name.nvim"

    if not is_installed(short_name) then
        table.insert(tasks, execute_command_and_check("Rocks! install " .. short_name, short_name, true))
    else
        print(short_name .. " is already installed.")
    end

    if not is_installed(short_name) then
        table.insert(tasks, execute_command_and_check("Rocks! install " .. plugin, short_name, true))
    end
end

run_tasks(tasks)
