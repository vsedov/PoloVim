local fn, uv, api = vim.fn, vim.loop, vim.api
local vim_path = require("core.global").vim_path
local path_sep = require("core.global").path_sep
local data_dir = require("core.global").data_dir
-- local home = require('core.global').home
local modules_dir = require("core.global").modules_dir
local packer_compiled = data_dir .. "lua/packer_compiled.lua"
local packer = nil

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
    self.repos = {}
    self.rocks = {}
    local get_plugins_list = function()
        local list = {}
        local tmp = vim.split(fn.globpath(modules_dir, "*/plugins.lua"), "\n")
        for _, f in ipairs(tmp) do
            list[#list + 1] = string.match(f, "lua/(.+).lua$")
        end
        return list
    end

    local plugins_file = get_plugins_list()
    for _, m in ipairs(plugins_file) do
        require(m)
    end
    self.rocks = require("modules.rocks")
end

function Packer:load_packer()
    if not packer then
        api.nvim_command("packadd packer.nvim")
        packer = require("packer")
    end
    packer.init({
        compile_path = packer_compiled,
        disable_commands = true,
        display = {
            working_sym = "ﰭ",
            error_sym = "",
            done_sym = "",
            removed_sym = "",
            moved_sym = "ﰳ",
        },
        git = { clone_timeout = 120 },
    })
    packer.reset()
    local use = packer.use
    local use_rocks = packer.use_rocks
    self:load_plugins()
    use({ "wbthomason/packer.nvim" })
    use({ "lewis6991/impatient.nvim" })

    for _, repo in ipairs(self.repos) do
        use(repo)
    end
    for _, rock in ipairs(self.rocks) do
        use_rocks(rock)
    end
end

function Packer:init_ensure_plugins()
    local packer_dir = data_dir .. "pack" .. path_sep .. "packer" .. path_sep .. "start" .. path_sep .. "packer.nvim"
    local state = uv.fs_stat(packer_dir)
    if not state then
        local cmd = "!git clone https://github.com/wbthomason/packer.nvim " .. packer_dir
        api.nvim_command(cmd)
        uv.fs_mkdir(data_dir .. "lua", 511, function()
            assert("make compile path dir faield")
        end)
        self:load_packer()
        packer.sync()
        return "installing"
    end
    return "installed"
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then
            Packer:load_packer()
        end
        return packer[key]
    end,
})

function plugins.ensure_plugins()
    return Packer:init_ensure_plugins()
end

function plugins.package(repo)
    table.insert(Packer.repos, repo)
end

function plugins.auto_compile()
    local file = vim.fn.expand("%:p")
    if not file:match(vim_path) then
        return
    end

    if file:match("plugins.lua") then
        plugins.clean()
    end
    plugins.compile()
    require("packer_compiled")
end

function plugins.compile_loader()
    plugins.clean()
    plugins.auto_compile()
    vim.cmd([[silent UpdateRemotePlugins]])
end

function plugins.load_compile()
    if vim.fn.filereadable(packer_compiled) == 1 then
        require("packer_compiled")
    else
        assert("Missing packer compile file Run PackerCompile Or PackerInstall to fix")
        vim.cmd("packadd packer.nvim")
        plugins.compile()
        require("packer_compiled")
        vim.notify("compile finished successfully wrote to " .. packer_compiled)
    end

    local cmds = {
        "Compile",
        "Install",
        "Update",
        "Sync",
        "Clean",
        "Status",
    }
    for _, cmd in ipairs(cmds) do
        api.nvim_create_user_command("Packer" .. cmd, function()
            require("core.pack")[fn.tolower(cmd)]()
        end, {})
    end

    local PackerHooks = vim.api.nvim_create_augroup("PackerHooks", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        pattern = "PackerCompileDone",
        callback = function()
            vim.notify("Compile Done!", vim.log.levels.INFO, { title = "Packer" })
        end,
        group = PackerHooks,
    })

    vim.cmd([[autocmd User PackerComplete lua require('core.pack').compile_loader()]])
end

return plugins
