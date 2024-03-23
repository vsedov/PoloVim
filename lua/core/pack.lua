local uv, api, fn = vim.loop, vim.api, vim.fn
local helper = require("core.helper")
local main_debug = false
local pack = {}
pack.__index = pack

function pack:load_modules_packages()
    local modules_dir = helper.get_config_path() .. "/lua/modules"
    self.repos = {}

    local get_plugins_list = function()
        local list = {}
        local tmp = vim.split(fn.globpath(modules_dir, "*/plugins.lua"), "\n")
        for _, f in ipairs(tmp) do
            list[#list + 1] = string.match(f, "lua/(.+).lua$")
        end
        return list
    end

    local plugins_file = get_plugins_list()
    local disable_modules = {}
    if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
        -- modules/ai/plugins
        -- modules/buffers/plugins
        -- modules/clipboard/plugins
        -- modules/colourscheme/plugins
        -- modules/completion/plugins
        -- modules/documentation/plugins
        -- modules/editor/plugins
        -- modules/folke/plugins
        -- modules/fun/plugins
        -- modules/git/plugins
        -- modules/lang/plugins
        -- modules/latex/plugins
        -- modules/lsp/plugins
        -- modules/mini/plugins
        -- modules/misc/plugins
        -- modules/movement/plugins
        -- modules/notes/plugins
        -- modules/on_startup/plugins
        -- modules/python/plugins
        -- modules/runner/plugins
        -- modules/search/plugins
        -- modules/tmux/plugins
        -- modules/tools/plugins
        -- modules/treesitter/plugins
        -- modules/ui/plugins
        -- modules/user/plugins
        -- modules/windows/plugins

        disable_modules = {
            -- "ai",
            "buffers",
            -- "clipboard",
            "colourscheme",
            "completion",
            "documentation",
            -- "editor",
            "folke",
            "fun",
            -- "git",
            "lang",
            "latex",
            -- "lsp",
            "mini",
            "misc",
            -- "movement",
            "notes",
            -- "on_startup",
            "python",
            -- "runner",
            -- "search",
            -- "tmux",
            -- "tools",
            -- "user",
            -- "windows",
        }
        new_name = "modules/?/plugins"
        for i, v in ipairs(disable_modules) do
            disable_modules[i] = new_name:gsub("?", v)
        end
    end
    if main_debug then
        all_modules = {
            "ai",
            "buffers",
            "clipboard",
            -- -- "colourscheme",
            -- -- "completion",
            "documentation",
            -- -- "editor",
            "folke",
            "fun",
            -- "git",
            -- -- "lang",
            -- "latex",
            -- "lsp",
            -- "mini",
            -- -- "misc",
            -- -- "movement",
            -- -- "notes",
            -- "on_startup",
            -- "python",
            -- "runner",
            -- -- "search",
            -- "tmux",
            -- "tools",
            -- "treesitter",
            -- "ui",
            -- "user",
            -- "windows",
        }

        disable_modules = {}

        for _, m in ipairs(all_modules) do
            if not vim.tbl_contains(disable_modules, m) then
                disable_modules[#disable_modules + 1] = "modules/" .. m .. "/plugins"
            end
        end
    end

    if fn.exists("g:disable_modules") == 1 then
        disable_modules = vim.split(vim.g.disable_modules, ",")
    end

    for _, m in ipairs(plugins_file) do
        if not vim.tbl_contains(disable_modules, m) then
            require(m)
        end
    end
end

function pack:boot_strap()
    local lazy_path = string.format("%s/lazy/lazy.nvim", helper.get_data_path())
    local state = uv.fs_stat(lazy_path)
    if not state then
        local cmd = "!git clone https://github.com/folke/lazy.nvim " .. lazy_path
        api.nvim_command(cmd)
    end
    vim.opt.runtimepath:prepend(lazy_path)
    local lazy = require("lazy")
    local opts = {
        lockfile = helper.get_data_path() .. "/lazy-lock.json",
        dev = { path = "~/GitHub/neovim/personal/" },
    }
    self:load_modules_packages()
    lazy.setup(self.repos, opts)
    for k, v in pairs(self) do
        if type(v) ~= "function" then
            self[k] = nil
        end
    end
end

function pack.package(repo)
    if not pack.repos then
        pack.repos = {}
    end
    table.insert(pack.repos, repo)
end

return pack
