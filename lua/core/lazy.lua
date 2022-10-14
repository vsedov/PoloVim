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
local function load_colourscheme()
    math.randomseed(os.clock() * 100000000000)
    local theme = lambda.config.colourscheme.themes.dark.core_themes

    local rand = math.random(#theme)
    loader(theme[rand])
    -- loader("rose") -- Forceuflly load rosepine
end

load_colourscheme()

function Lazyload()
    _G.PLoader = loader
    if vim.wo.diff then
        lprint("diffmode")
        vim.cmd([[packadd nvim-treesitter]])
        require("nvim-treesitter.configs").setup({ highlight = { enable = true, use_languagetree = false } })
        return
    else
        loader("nvim-treesitter")
        -- vim.cmd([[syntax on]])
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
    -- only works if you are working from one python file .
    if vim.bo.filetype == "lua" then
        loader("neodev.nvim")
        loader("luv-vimdocs")
        loader("nvim-luaref")
    end

    vim.g.vimsyn_embed = "lPr"

    local gitrepo = vim.fn.isdirectory(".git/index")
    if gitrepo and lambda.use_gitsigns then
        loader("gitsigns.nvim") -- neogit vgit.nvim
    end

    if load_lsp then
        vim.defer_fn(function()
            loader("lspsaga.nvim")
        end, 60)
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
                vim.notify("syntax off")
                vim.cmd([[setlocal syntax=off]])
            end
        end,
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

vim.cmd([[autocmd User LoadLazyPlugin lua Lazyload()]])

vim.defer_fn(function()
    -- require("vscripts.tools")
    vim.api.nvim_create_user_command("Gram", function()
        require("modules.tools.config").grammcheck()
    end, { force = true })

    loader("presence.nvim")

    if lambda.config.tabby_or_bufferline ~= nil then
        vim.cmd("SwitchBar")
        if lambda.config.use_scope then
            loader("scope.nvim")
        end
    end
    lprint("ui loaded + abbreviations")
end, lazy_timer + 60)

vim.defer_fn(function()
    lprint("telescope family")
    loader("telescope.nvim")
    loader("telescope.nvim telescope-zoxide nvim-neoclip.lua") --project.nvim
end, lazy_timer + 80)

vim.defer_fn(function()
    if lambda.config.use_fzf_lua then
        loader("fzf-lua")
    end
    loader("workspaces.nvim")
    if lambda.config.rooter_or_project then
        loader("nvim-rooter.lua")
    else
        loader("project.nvim")
    end
    -- -- Notify
    if lambda.config.simple_notify then
        loader("notifier.nvim")
    else
        loader("fidget.nvim")
        loader("nvim-notify")
    end
    loader("matchparen.nvim")
    lprint("all done")
end, lazy_timer + 80)
