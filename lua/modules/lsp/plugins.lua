local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

lsp({
    "neovim/nvim-lspconfig",
    opt = true,
    module_pattern = "lspconfig.*",
    event = "BufEnter",
    setup = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
})

lsp({
    "williamboman/mason.nvim",
    after = "nvim-lspconfig",
    requires = { "nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
    config = conf.mason_setup,
})

-- until i figure out how to install custom languages servers with mason, il keep this here as a handy backup .
-- lsp({
--     "williamboman/nvim-lsp-installer",
--     opt = true,
--     requires = "nvim-lspconfig",
--     config = conf.lsp_install,
-- })

lsp({ "ii14/lsp-command", opt = true, after = "nvim-lspconfig" })
lsp({
    "p00f/clangd_extensions.nvim",
    opt = true,
    ft = { "c", "cpp" },
    requires = "nvim-lspconfig",
    config = conf.clangd,
})

lsp({ "max397574/lua-dev.nvim", ft = "lua", opt = true, requires = "nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", key = { "K", "gK" }, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cmd = { "Lspsaga", "LSoutlineToggle" },
    opt = true,
    config = conf.saga,
    requires = "nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    module = "lsp_signature",
    opt = true,
    -- config = conf.lsp_sig,
})

lsp({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    ft = { "python", "lua", "c", "java", "prolog", "lisp", "cpp" },
})

lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cmd = { "TL" },
    config = conf.lsp_lines,
})

lsp({ "smjonas/inc-rename.nvim", event = "BufEnter", after = "nvim-lspconfig", config = conf.rename })

lsp({ "SmiteshP/nvim-navic", event = "BufEnter", after = "nvim-lspconfig", config = conf.navic })

lsp({ "cseickel/diagnostic-window.nvim", cmd = "DiagWindowShow", requires = { "MunifTanjim/nui.nvim" } })
lsp({
    "liuchengxu/vista.vim",
    cmd = { "Vista", "Vista!", "Vista!!" },
    config = conf.vista,
})

lsp({
    --[[ lambda.use_local("null-ls.nvim", "contributing"), ]]
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufEnter",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        -- require("typos").setup()
    end,
})

lsp({
    "jayp0521/mason-null-ls.nvim",
    after = {
        "null-ls.nvim",
        "mason.nvim",
    },
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = {
                { "shellcheck", auto_update = true },
            },
            auto_update = true,
            automatic_installation = false,
        })

        require("mason-null-ls").check_install(true)
    end,
})

lsp({
    "barreiroleo/ltex-extra.nvim",
    opt = true,
    ft = { "latex", "tex" },
    module = "ltex_extra",
})

lsp({
    "theHamsta/nvim-semantic-tokens",
    opt = true,
    config = function()
        preset = "default"
        highlighters = { require("nvim-semantic-tokens.table-highlighter") }
    end,
})

lsp({
    "santigo-zero/right-corner-diagnostics.nvim",
    event = { "LspAttach" },
    config = function()
        require("rcd").setup({
            -- Where to render the diagnostics: top or bottom, the latter sitting at
            -- the bottom line of the buffer, not of the terminal.
            position = "top",

            -- In order to print the diagnostics we need to use autocommands, you can
            -- disable this behaviour and call the functions yourself if you think
            -- your autocmds work better than the default ones with this option:
            auto_cmds = true,
        })
        -- lambda.augroup("right_corner_diagnostics", {
        --     {
        --         event = { "CursorHold", "CursorHoldI" },
        --         command = function()
        --             require("rcd").show()
        --         end,
        --     },
        --     {
        --         event = { "CursorHold", "CursorHoldI" },
        --         command = function()
        --             require("rcd").hide()
        --         end,
        --     },
        -- })
    end,
})
