local M = {}

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
        async = true,
    })
end

function M.setup()
    local null_ls = require("null-ls")
    local lspconfig = require("lspconfig")
    local diagnostics = null_ls.builtins.diagnostics
    local hover = null_ls.builtins.hover
    local actions = null_ls.builtins.code_actions

    local config = require("modules.lsp.lsp.utils.config").null_ls

    local registered_sources = {}
    for builtin, sources in pairs({
        formatting = config.formatter,
        diagnostics = config.diagnostic,
        code_actions = config.code_action,
    }) do
        for _, source in ipairs(sources) do
            local config = require("modules.lsp.lsp.null-ls.with")[source] or {}
            source = null_ls.builtins[builtin][source].with(config)
            table.insert(registered_sources, source)
        end
    end

    local cfg = {
        sources = registered_sources,
        debounce = 1000,
        default_timeout = 3000,
        fallback_severity = vim.diagnostic.severity.WARN,
        root_dir = require("lspconfig").util.root_pattern(
            ".null-ls-root",
            "Pipfile",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "node_modules",
            "xmake.lua",
            "pom.xml",
            "CMakeLists.txt",
            ".null-ls-root",
            "Makefile",
            "package.json",
            "tsconfig.json",
            ".git"
        ),
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        lsp_formatting(bufnr)
                    end,
                })
            end
        end,
    }

    null_ls.setup(cfg)
end

return M