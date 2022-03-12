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
        themes = { "kanagawa.nvim", "catppuccin", "Sakura.nvim", "vim-dogrun" }
    else
        themes = { "themer.lua", "kanagawa.nvim", "tokyonight.nvim", "Sakura.nvim", "vim-dogrun", "jabuti-nvim" }
    end
    local v = math.random(1, #themes)
    local loading_theme = themes[v]

    lprint(loading_theme)

    require("packer").loader(loading_theme)
end

function Lazyload()
    --
    _G.PLoader = loader
    -- no_file()
    loadscheme()
    if vim.wo.diff then
        -- loader(plugins)
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

    local plugins = "plenary.nvim" -- nvim-lspconfig navigator.lua   guihua.lua navigator.lua  -- gitsigns.nvim
    loader("plenary.nvim")

    -- only works if you are working from one python file .
    if vim.bo.filetype == "lua" then
        -- loader("lua-dev.nvim")
        loader("luv-vimdocs")
        loader("nvim-luaref")
        loader("structlog.nvim") -- logging
    end

    vim.g.vimsyn_embed = "lPr"

    local gitrepo = vim.fn.isdirectory(".git/index")
    if gitrepo then
        loader("gitsigns.nvim") -- neogit vgit.nvim
    end

    if load_lsp then
        loader("nvim-lspconfig") -- null-ls.nvim
        loader("lsp_signature.nvim")
        if use_nulls() then
            loader("null-ls.nvim")
        end
    end

    if load_lsp or load_ts_plugins then
        loader("guihua.lua")
        -- loader("Comment.nvim")
        -- loader("navigator.lua")
    end

    -- local bytes = vim.fn.wordcount()['bytes']
    if load_ts_plugins then
        plugins =
            "nvim-treesitter-textobjects nvim-treesitter-refactor nvim-ts-autotag nvim-ts-context-commentstring nvim-treesitter-textsubjects"
        loader(plugins)
        lprint(plugins)
        loader("neogen") -- Load neogen only for active lsp servers
        loader("indent-blankline.nvim")
        loader("refactoring.nvim") -- need to do the same thing for refactoring
    end

    loader("popup.nvim")

    -- if bytes < 2 * 1024 * 1024 and syn_on then
    --   vim.cmd([[setlocal syntax=on]])
    -- end

    -- vim.cmd([[autocmd FileType vista,guihua setlocal syntax=on]])
    -- vim.cmd(
    -- [[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] > 2048000 then print("syntax off") vim.cmd("setlocal syntax=off") end]]
    -- )
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
end

local lazy_timer = 30
if _G.packer_plugins == nil or _G.packer_plugins["packer.nvim"] == nil then
    lprint("recompile")
    vim.cmd([[PackerCompile]])
    vim.defer_fn(function()
        print("Packer recompiled, please run `:PackerCompile` and restart nvim")
    end, 1000)
    return
end

vim.defer_fn(function()
    vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)

-- vim.defer_fn(function()
--   -- lazyload()
--   local cmd = "TSEnableAll highlight " .. vim.o.ft
--   vim.cmd(cmd)
--   vim.cmd(
--     [[autocmd BufEnter * silent! lua vim.fn.wordcount()['bytes'] < 2048000 then vim.cmd('set syntax=on') local cmd= "TSBufEnable "..vim.o.ft vim.cmd(cmd) lprint(cmd, vim.o.ft, vim.o.syntax) end]]
--   )
--   -- vim.cmd([[doautocmd ColorScheme]])
--   -- vim.cmd(cmd)
-- end, lazy_timer + 20)

-- vim.cmd([[hi LineNr guifg=#505068]])

vim.api.nvim_set_hl(0, "LineNr", { fg = "#505068" })

vim.cmd([[autocmd User LoadLazyPlugin lua Lazyload()]])

vim.defer_fn(function()
    loader("heirline.nvim")
    require("modules.ui.heirline")

    require("vscripts.cursorhold")
    require("vscripts.tools")
    require("utils.ui_overwrite")

    vim.cmd("command! Gram lua require'modules.tools.config'.grammcheck()")
    vim.cmd("command! Spell call spelunker#check()")
    loader("animate.vim")
    loader("presence.nvim")
end, lazy_timer + 60)

vim.defer_fn(function()
    lprint("telescope family")
    loader("telescope.nvim")
    loader("telescope.nvim telescope-zoxide nvim-neoclip.lua") --project.nvim
    -- loader("harpoon")
    loader("workspaces.nvim")
    loader("nvim-notify")
    vim.notify = require("notify")

    lprint("all done")
end, lazy_timer + 80)
