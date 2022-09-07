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

    local config = require("modules.lsp.lsp.config.config").null_ls
    local mason_package = require("mason-core.package")
    local format = config.formatter
    local diagnostic = config.diagnostic

    for _, package in ipairs(require("mason-registry").get_installed_packages()) do
        local package_categories = package.spec.categories[1]
        if package_categories == mason_package.Cat.Formatter then
            table.insert(format, package.name)
        end
        if package_categories == mason_package.Cat.Linter then
            table.insert(diagnostic, package.name)
        end
    end

    for _, py_form in ipairs(lambda.config.lsp.python.format) do
        table.insert(format, py_form)
    end
    for _, py_form in ipairs(lambda.config.lsp.python.lint) do
        table.insert(diagnostic, py_form)
    end
    local registered_sources = {}
    for builtin, sources in pairs({
        formatting = format,
        diagnostics = diagnostic,
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
                local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
                    lsp_formatting(bufnr)
                end, {})

                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    command = "undojoin | LspFormatting",
                })
            end
        end,
    }

    null_ls.setup(cfg)
end

return M
