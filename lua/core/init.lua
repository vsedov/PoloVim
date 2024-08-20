local g, api = vim.g, vim.api
-- require('internal.winbar')

local cache_dir = vim.env.HOME .. "/.cache/nvim/"

local vim = vim

local createdir = function()
    local data_dir = {
        cache_dir .. "backup",
        cache_dir .. "session",
        cache_dir .. "swap",
        cache_dir .. "tags",
        cache_dir .. "undo",
    }
    -- There only check once that If cache_dir exists
    -- Then I don't want to check subs dir exists
    if vim.fn.isdirectory(cache_dir) == 0 then
        os.execute("mkdir -p " .. cache_dir)
        for _, v in pairs(data_dir) do
            if vim.fn.isdirectory(v) == 0 then
                os.execute("mkdir -p " .. v)
            end
        end
    end
end

local disable_distribution_plugins = function()
    --[[ vim.g.loaded_gzip = 1 ]]
    --[[ vim.g.loaded_zip = 1 ]]
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 0
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
    vim.g.matchup_matchparen_enabled = 1
    vim.g.load_black = 1
    vim.g.loaded_node_provider = 1
    -- vim.g.loaded_ruby_provider = 0
    -- vim.g.loaded_perl_provider = 0
end
local file_type = function()
    if not vim.filetype then
        return
    end

    vim.filetype.add({
        extension = {
            lock = "yaml",
        },
        filename = {
            ["NEOGIT_COMMIT_EDITMSG"] = "NeogitCommitMessage",
            [".psqlrc"] = "conf", -- TODO: find a better filetype
            ["go.mod"] = "gomod",
            [".gitignore"] = "conf",
            ["launch.json"] = "jsonc",
            Podfile = "ruby",
            Brewfile = "ruby",
        },
        pattern = {
            [".*%.conf"] = "conf",
            [".*%.theme"] = "conf",
            [".*%.gradle"] = "groovy",
            [".*%.env%..*"] = "env",
        },
    })
end

local leader_map = function()
    vim.g.mapleader = " "
    vim.g.maplocalleader = ","
    vim.keymap.set("n", "<SPACE>", "<Nop>", { noremap = true })
    vim.keymap.set("n", "<SPACE>", "<Nop>", { noremap = true })

    vim.keymap.set("n", " ", "", { noremap = true })
    vim.keymap.set("x", " ", "", { noremap = true })
    vim.keymap.set("n", "<esc>", function()
        require("notify").dismiss()
        vim.cmd.nohl()
    end, {})
end

local load_core = function()
    vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim") -- lazy.nvim

    vim.loader.enable()

    require("core.globals")
    createdir()
    disable_distribution_plugins()
    leader_map()

    lambda.use_rocks = true

    require("core.options")
    require("core.autocmd")
    require("core.autocmd_optional")
    require("core.cmd")
    require("keymaps")

    if not lambda.use_rocks then
        require("core.pack")
    else
        do
            -- Specifies where to install/use rocks.nvim
            local install_location = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks")

            -- Set up configuration options related to rocks.nvim (recommended to leave as default)
            local rocks_config = {
                rocks_path = vim.fs.normalize(install_location),
            }

            vim.g.rocks_nvim = rocks_config

            -- Configure the package path (so that plugin code can be found)
            local luarocks_path = {
                vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
                vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
            }
            package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

            -- Configure the C path (so that e.g. tree-sitter parsers can be found)
            local luarocks_cpath = {
                vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
                vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
            }
            package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

            -- Load all installed plugins, including rocks.nvim itself
            vim.opt.runtimepath:append(
                vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")
            )
        end

        -- If rocks.nvim is not installed then install it!
        if not pcall(require, "rocks") then
            local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache"), "rocks.nvim")

            if not vim.uv.fs_stat(rocks_location) then
                -- Pull down rocks.nvim
                vim.fn.system({
                    "git",
                    "clone",
                    "--filter=blob:none",
                    "https://github.com/nvim-neorocks/rocks.nvim",
                    rocks_location,
                })
            end

            -- If the clone was successful then source the bootstrapping script
            assert(vim.v.shell_error == 0, "rocks.nvim installation failed. Try exiting and re-entering Neovim!")

            vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

            vim.fn.delete(rocks_location, "rf")
        end
    end
    if lambda.distro() then
        vim.cmd([[
        let g:clipboard = {
                \ 'name': 'xsel',
                \ 'copy': {
                \    '+': 'xsel --nodetach -i -b',
                \    '*': 'xsel --nodetach -i -p',
                \  },
                \ 'paste': {
                \    '+': 'xsel -o -b',
                \    '*': 'xsel -o -p',
                \ },
                \ 'cache_enabled': 1,
                \ }
        ]])
    end

    file_type()
    if not lambda.use_rocks then
        require("core.pack"):boot_strap()
    end

    if vim.env.KITTY_SCROLLBACK_NVIM then
        vim.cmd([[
     set spl=en spell
     set nospell
         ]])
    end
end

load_core()
