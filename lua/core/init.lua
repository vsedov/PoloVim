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

    require("core.pack")
    createdir()
    disable_distribution_plugins()
    leader_map()
    require("core.options")
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

    require("core.autocmd")
    require("core.autocmd_optional")
    require("core.cmd")
    require("keymaps")
    file_type()
    require("core.pack"):boot_strap()

    if vim.env.KITTY_SCROLLBACK_NVIM then
        vim.cmd([[
     set spl=en spell
     set nospell
         ]])
    end

    require("core.after_init")
end

load_core()
