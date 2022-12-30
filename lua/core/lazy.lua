local loader = require("lazy").load
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
    loader({ plugins = { theme[rand] } })

    -- loader("rose") -- Forceuflly load rosepine
end

load_colourscheme() -- loads default colourscheme

function Lazyload()
    _G.PLoader = loader
    if vim.wo.diff then
        loader({ plugins = { "nvim-treesitter" } })
        require("nvim-treesitter.configs").setup({ highlight = { enable = true, use_languagetree = false } })
        return
    else
        loader({ plugins = { "nvim-treesitter" } })
    end

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
        loader({ plugins = { "neodev.nvim" } })
        loader({ plugins = { "luv-vimdocs" } })
        loader({ plugins = { "nvim-luaref" } })
    end

    vim.g.vimsyn_embed = "lPr"

    local gitrepo = vim.fn.isdirectory(".git/index")
    if gitrepo and lambda.use_gitsigns then
        loader({ plugins = { "gitsigns.nvim" } })
    end
    local condition = function()
        if lambda.config.lsp.use_lsp_signature then
            if lambda.config.ui.noice.lsp.use_noice_signature == false then
                return true
            end
        end
    end
    if load_lsp then
        vim.defer_fn(function()
            loader({ plugins = { "lspsaga.nvim" } })
            if condition() then
                loader({ plugins = { "lsp_signature.nvim" } })
            end
        end, 60)
    end

    -- local bytes = vim.fn.wordcount()['bytes']
    if load_ts_plugins then
        loader({ plugins = { "refactoring.nvim" } })
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "vista", "guiha" },
        command = [[setlocal syntax=on]],
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            if vim.fn.wordcount()["bytes"] > 2048000 then
                -- lprint("syntax off")
                vim.notify("syntax off")
                vim.cmd([[setlocal syntax=off]])
            end
        end,
    })
end

local lazy_timer = 30

vim.defer_fn(function()
    vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)

vim.cmd([[autocmd User LoadLazyPlugin lua Lazyload()]])

vim.defer_fn(function()
    require("vscripts.tools")
    vim.api.nvim_create_user_command("Gram", function()
        require("modules.tools.config").grammcheck()
    end, { force = true })

    loader({ plugins = { "presence.nvim" } })

    if lambda.config.tabby_or_bufferline ~= nil then
        if lambda.config.use_scope then
            loader({ plugins = { "scope.nvim" } })
        end
    end
    -- lprint("ui loaded + abbreviations")
end, lazy_timer + 60)

vim.defer_fn(function()
    loader({ plugins = { "telescope.nvim" } })
    loader({ plugins = { "telescope-zoxide" } })
    loader({ plugins = { "nvim-neoclip.lua" } })
end, lazy_timer + 80)

--  TODO: (vsedov) (01:32:08 - 28/10/22): WTF is this code viv ??
--  REVISIT: (vsedov) (01:32:15 - 28/10/22): Change this once you have time
vim.defer_fn(function()
    if lambda.config.use_fzf_lua then
        loader({ plugins = { "fzf-lua" } })
    end
    loader({ plugins = { "workspaces.nvim" } })

    if lambda.config.rooter_or_project then
        loader({ plugins = { "nvim-rooter.lua" } })
    else
        loader({ plugins = { "project.nvim" } })
    end
    -- -- Notify
    if not lambda.config.ui.enable then
        loader({ plugins = { "nvim-notify" } })
    end

    -- this thing is quite laggy
    if lambda.config.use_ufo and vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) < 500 then
        -- print("nvim-ufo loading")
        loader({ plugins = { "nvim-ufo" } })
    end
    -- lprint("all done")
end, lazy_timer + 80)

-- Load Leap, after 100, because why not, this is my core movement
vim.defer_fn(function()
    if lambda.config.use_scroll then
        loader({ plugins = { "neoscroll.nvim" } })
    end
    local movement = require("modules.movement.config")
    movement.leap()
    movement.leap_spooky()
    movement.leap_flit()
end, 100)
