local home = require("core.global").home
-- neovim/contributing and neovim/perosnal contain git directories
local get_git_directories = function()
    return {
        home .. "/Github/neovim/contributing",
        home .. "/Github/neovim/personal",
    }
end
local ignore_list = {
    "telescope-bookmarks.nvim",
}
-- each directory contains plugins with .git directories
-- run git --work-tree=/X/Y --git-dir=/X/Y/.git pull origin branch
-- where x/y is full path to plugin dir

local git_pull = function(dir)
    -- check if oring branch is main or master
    local branch = io.popen("git rev-parse --abbrev-ref HEAD"):read("*l")
    if not branch == "main" or not branch == "master" then
        vim.notify("Branch is main or master, skipping")
        return
    end
    local proj_name = vim.split(dir, "/")[#vim.split(dir, "/")]
    if vim.tbl_contains(ignore_list, proj_name) then
        vim.notify("Ignoring " .. proj_name)
        return
    end

    vim.fn.system(("git --work-tree=%s --git-dir=%s/.git pull origin %s"):format(dir, dir, branch))
end

local get_all_plugins = function()
    local dirs = get_git_directories()
    local plugins = {}
    for _, dir in ipairs(dirs) do
        local files = vim.split(vim.fn.glob(dir .. "/*"), "\n")
        for _, file in ipairs(files) do
            table.insert(plugins, file)
        end
    end
    return plugins
end

return function()
    for _, plugin in ipairs(get_all_plugins()) do
        git_pull(plugin)
    end
end
