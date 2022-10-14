-- vim.cmd[[packadd lsp-format-modifications.nvim]]

local M = {}

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
        async = true,
        timeout_ms = 1000,
    })
end

local function augroup_setup(augroup, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
            lsp_formatting(bufnr)
        end,
    })
end
function M.setup()
    local null_ls = require("null-ls")
    local hover = null_ls.builtins.hover
    local actions = null_ls.builtins.code_actions

    local config = require("modules.lsp.lsp.config.config").null_ls
    local format = config.formatter
    local diagnostic = config.diagnostic

    for _, py_form in ipairs(lambda.config.lsp.python.format) do
        table.insert(format, py_form)
    end
    for _, py_diag in ipairs(lambda.config.lsp.python.lint) do
        table.insert(diagnostic, py_diag)
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

    -- table.insert(registered_sources, require("typos").actions)
    -- table.insert(registered_sources, require("typos").diagnostics)
    local cfg = {
        sources = registered_sources,
        debounce = 500,
        default_timeout = 500,
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
                local augroup = vim.api.nvim_create_augroup("FormatOnSave", {})
                vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
                    lsp_formatting(bufnr)
                end, {})
                local ammount = vim.api.nvim_buf_line_count(bufnr) < 8000
                -- P(client)
                if not ammount then
                    local lsp_format_modifications = require("lsp-format-modifications")
                    lsp_format_modifications.attach(client, bufnr, { format_on_save = true })
                    -- Currently this does not work for majority of my formatters , due to refactoring .
                    -- Needs a way to filter certain types
                else
                    augroup_setup(augroup, buffer)
                end
            end
        end,
    }

    null_ls.setup(cfg)
end

return M
