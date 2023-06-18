-- vim.cmd[[ Lazy load lsp-format-modifications.nvim]]
local active = true
local lsp_format_modifications = require("lsp-format-modifications")

local M = {}

local lsp_formatting = function(bufnr, client)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
        async = #client == 1,
    })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local function augroup_setup(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function(args)
                local clients = vim.tbl_filter(function(c)
                    return c.server_capabilities["documentFormattingProvider"]
                end, vim.lsp.get_active_clients({ buffer = bufnr }))
                lsp_formatting(args.bufnr, clients)
            end,
        })
    end
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
    local registered_sources = {
        null_ls.builtins.hover.dictionary,
        null_ls.builtins.hover.printenv,
    }
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

    if lambda.config.lsp.use_typos then
        table.insert(registered_sources, require("typos").actions)
        table.insert(registered_sources, require("typos").diagnostics)
    end

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
            vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
                lsp_formatting(bufnr)
            end, {})
            if lambda.config.lsp.use_format_modifcation then
                if vim.fn.isdirectory(".git/index") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    lsp_format_modifications.attach(client, bufnr, { format_on_save = true })
                else
                    vim.api.nvim_clear_autocmds({
                        group = "NvimFormatModificationsDocumentFormattingGroup",
                        buffer = bufnr,
                    })
                end
            else
                augroup_setup(client, bufnr)
            end
        end,
    }

    null_ls.setup(cfg)
end

return M
