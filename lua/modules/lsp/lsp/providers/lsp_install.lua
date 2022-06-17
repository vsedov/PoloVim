local lsp_installer = require("nvim-lsp-installer")
local lsp_config = require("lspconfig")
local lsp_util = require("lspconfig.util")
local enhance_attach = require("modules.lsp.lsp.utils").enhance_attach
lsp_installer.settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

lsp_installer.on_server_ready(function(server)
    local opts = {}
    -- (optional) Customize the options passed to the server
    if server.name == "jdtls" then
        return
    end
    server:setup(opts)
    -- vim.cmd([[ do User LspAttachBuffers ]])
end)
--
local servers = {

    ["remark_ls"] = {
        settings = {
            defaultProcessor = "remark",
        },
    },

    ["bashls"] = {},

    ["emmet_ls"] = {
        root_dir = lsp_util.find_git_ancestor,
        single_file_support = true,
        filetypes = {
            "html",
            "css",
            "scss",
            "njk",
            "nunjucks",
            "jinja",
            "markdown",
            -- 'ts', 'typescript',
            -- 'js', 'javascript',
        },
    },

    ["eslint"] = {
        on_attach = toggle_formatting(true),
        root_dir = lsp_util.find_git_ancestor,
        settings = {
            autoFixOnSave = true,
            codeActionsOnSave = {
                enable = true,
                mode = "all",
                rules = { "!debugger", "!no-only-tests/*" },
            },
        },
    },

    ["graphql"] = {},
    ["html"] = {
        settings = {
            autoFixOnSave = false,
            html = {
                format = {
                    templating = true,
                    wrapLineLength = 200,
                    wrapAttributes = "force-aligned",
                },
                editor = {
                    formatOnSave = false,
                    formatOnPaste = false,
                    formatOnType = false,
                },
                hover = {
                    documentation = true,
                    references = true,
                },
            },
        },
    },
    ["stylelint_lsp"] = {
        on_attach = toggle_formatting(true),
        filetypes = {
            "css",
            "les",
            "scss",
            "sugarss",
            "vue",
            "wxss",
        },
        settings = {
            autoFixOnSave = true,
            stylelintplus = {
                autoFixOnSave = true,
                autoFixOnFormat = true,
                cssInJs = false,
            },
        },
    },
    ["yamlls"] = {},
    ["java"] = {},
}

lsp_installer.setup({
    ensure_installed = vim.tbl_keys(servers),
})
--- setup install
--- installing each, then if install succeeded,
--- setup the server with the options specified in server_opts,
--- or just use the default options
--
for name, opts in pairs(servers) do
    opt = enhance_attach(opts)
    local server_config = vim.tbl_extend("force", opts)
    lsp_config[name].setup(server_config)
end
