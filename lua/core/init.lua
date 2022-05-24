local global = require("core.global")
local vim = vim

-- Create cache dir and subs dir
local createdir = function()
    local data_dir = {
        global.cache_dir .. "backup",
        global.cache_dir .. "session",
        global.cache_dir .. "swap",
        global.cache_dir .. "tags",
        global.cache_dir .. "undo",
    }
    -- There only check once that If cache_dir exists
    -- Then I don't want to check subs dir exists
    if vim.fn.isdirectory(global.cache_dir) == 0 then
        os.execute("mkdir -p " .. global.cache_dir)
        for _, v in pairs(data_dir) do
            if vim.fn.isdirectory(v) == 0 then
                os.execute("mkdir -p " .. v)
            end
        end
    end
end

local disable_distribution_plugins = function()
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 0
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1

    vim.g.loaded_node_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
end

local leader_map = function()
    vim.g.mapleader = " "
    vim.g.maplocalleader = "."

    vim.keymap.set("n", "<SPACE>", "<Nop>", { noremap = true })
    vim.keymap.set("n", " ", "", { noremap = true })
    vim.keymap.set("x", " ", "", { noremap = true })
end

local load_core = function()
    require("core.helper").init()
    local pack = require("core.pack")
    createdir()
    disable_distribution_plugins()
    leader_map()

    if pcall(require, "impatient") then
        require("impatient")
    end
    if pack.ensure_plugins() == "installed" then
        require("core.options")
        require("core.autocmd")
        require("core.mapping")
        require("keymap")
        -- selene: allow(global_usage)
        _G.lprint = require("utils.log").lprint
        pack.load_compile()
        require("core.lazy")
    else
        print("install all plugins, please wait")
    end
end

load_core()
