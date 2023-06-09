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
    require("utils.ui.highlights")
    math.randomseed(os.clock() * 100000000000)
    local theme = lambda.config.colourscheme.themes.dark.core_themes

    local rand = math.random(#theme)
    loader({ plugins = { theme[rand] } })

    -- loader("rose") -- Forceuflly load rosepine
end

load_colourscheme() -- loads default colourscheme

function Lazyload()
    loader({ plugins = { "nvim-treesitter" } })
    if vim.bo.filetype == "lua" then
        loader({ plugins = { "neodev.nvim" } })
        loader({ plugins = { "luv-vimdocs" } })
        loader({ plugins = { "nvim-luaref" } })
    end
end

local lazy_timer = 30

vim.defer_fn(function()
    vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)

vim.cmd([[autocmd User LoadLazyPlugin lua Lazyload()]])

vim.defer_fn(function()
    vim.api.nvim_create_user_command("Gram", function()
        require("modules.tools.config").grammcheck()
    end, { force = true })

    loader({ plugins = { "presence.nvim" } })
end, lazy_timer + 60)

vim.defer_fn(function()
    loader({ plugins = { "telescope.nvim", "telescope-zoxide", "nvim-neoclip.lua" } })
end, lazy_timer + 80)

vim.defer_fn(function()
    if lambda.config.extra_search.enable and lambda.config.extra_search.providers.use_fzf_lua then
        loader({ plugins = { "fzf-lua" } })
    end
end, lazy_timer + 100)

vim.defer_fn(function()
    if lambda.config.record_your_self then
        loader({ plugins = { "vim-wakatime" } })
    end
end, 120)
vim.defer_fn(function()
    if vim.fn.getenv("TMUX") ~= nil then
        lambda.config.movement.harpoon.use_tmux_or_normal = "tmux"
    end
    loader({ plugins = { "nvim-various-textobjs", "nvim-surround" } })
    loader({ plugins = { "leap.nvim", "leap-spooky.nvim", "flit.nvim", "leap-search.nvim" } })
    require("modules.movement.leap").highlight()
    require("vscripts")
end, 150)
