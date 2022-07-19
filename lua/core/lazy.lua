local loader = require("packer").loader
local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f"))
if fsize == nil or fsize < 0 then
    fsize = 1
end

local load_ts_plugins = true
local load_lsp = true

if fsize > 1024 * 1024 then
    load_ts_plugins = false
    load_lsp = false
end

math.randomseed(os.time())

local function daylight()
    local h = tonumber(os.date("%H"))
    if h > 6 and h < 18 then
        return "light"
    else
        return "dark"
    end
end
local function loadscheme()
    local themes
    if daylight() == "light" then
        themes = { "kanagawa.nvim" }
        themes = {
            "kanagawa.nvim",
            "catppuccin",
            "tokyonight.nvim",
        }
    end
    local v = math.random(1, #themes)
    local loading_theme = themes[v]

    lprint(loading_theme)

    require("packer").loader(loading_theme)
end
require("vscripts.cursorhold")
vim.g.cursorhold_updatetime = 100
-- loadscheme()
require("packer").loader("kanagawa.nvim")

require("utils.ui.highlights")

function Lazyload()
    _G.PLoader = loader
    if vim.wo.diff then
        lprint("diffmode")
        vim.cmd([[packadd nvim-treesitter]])
        require("nvim-treesitter.configs").setup({ highlight = { enable = true, use_languagetree = false } })
        vim.cmd([[syntax on]])
        return
    else
        loader("nvim-treesitter")
    end
    lprint("I am lazy")

    local disable_ft = {
        "NvimTree",
        "guihua",
        "guihua_rust",
        "clap_input",
        "clap_spinner",
        "TelescopePrompt",
        "csv",
        "txt",
        "defx",
        "sidekick",
        "neo-tree",
    }

    local syn_on = not vim.tbl_contains(disable_ft, vim.bo.filetype)
    if not syn_on then
        vim.cmd([[syntax manual]])
    end

    -- local fname = vim.fn.expand("%:p:f")
    if fsize > 6 * 1024 * 1024 then
        vim.cmd([[syntax off]])
        return
    end
    -- only works if you are working from one python file .
    if vim.bo.filetype == "lua" then
        loader("lua-dev.nvim")
        loader("luv-vimdocs")
        loader("nvim-luaref")
    end

    vim.g.vimsyn_embed = "lPr"

    local gitrepo = vim.fn.isdirectory(".git/index")
    if gitrepo and use_gitsigns() then
        loader("gitsigns.nvim") -- neogit vgit.nvim
    end

    if load_lsp then
        -- loader("lsp_signature.nvim")
    end
    -- local bytes = vim.fn.wordcount()['bytes']
    if load_ts_plugins then
        plugins = "nvim-treesitter-textobjects nvim-treesitter-textsubjects"
        loader(plugins)
        lprint(plugins)
        loader("indent-blankline.nvim")
        loader("refactoring.nvim")
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "vista", "guiha" },
        command = [[setlocal syntax=on]],
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            if vim.fn.wordcount()["bytes"] > 2048000 then
                lprint("syntax off")
                vim.cmd([[setlocal syntax=off]])
            end
        end,
    })
    vim.api.nvim_create_autocmd("Syntax", {
        pattern = "*",
        command = "if 5000 < line('$') | syntax sync minlines=200 | endif",
    })
end

local lazy_timer = 30
-- selene: allow(global_usage)
if _G.packer_plugins == nil or _G.packer_plugins["packer.nvim"] == nil then
    lprint("recompile")
    vim.cmd([[PackerCompile]])
    vim.defer_fn(function()
        lprint("Packer recompiled, please run `:PackerCompile` and restart nvim")
    end, 1000)
    return
end

vim.defer_fn(function()
    vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)

-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#505068" })

vim.cmd([[autocmd User LoadLazyPlugin lua Lazyload()]])

vim.defer_fn(function()
    require("vscripts.tools")
    if vim.bo.filetype ~= "tex" or vim.bo.filetype ~= "md" or vim.bo.filetype ~= "norg" then
        require("vscripts.race_conditions").coding_support()
    end
    require("vscripts.race_conditions").language_support()
    vim.cmd("command! Spell call spelunker#check()")
    vim.api.nvim_create_user_command("Gram", function()
        require("modules.tools.config").grammcheck()
    end, { force = true })

    loader("presence.nvim")
    lprint("ui loaded + abbreviations")
end, lazy_timer + 60)

vim.defer_fn(function()
    lprint("telescope family")
    loader("telescope.nvim")
    loader("telescope.nvim telescope-zoxide nvim-neoclip.lua") --project.nvim
    loader("workspaces.nvim")
    -- Notify
    loader("nvim-notify")
    local notify = require("notify")
    vim.notify = notify
    lprint("all done")
end, lazy_timer + 80)
loader("neorg")
