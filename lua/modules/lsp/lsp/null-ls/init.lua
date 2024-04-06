-- vim.cmd[[ Lazy load lsp-format-modifications.nvim]]
local config = lambda.config.lsp.null_ls

local M = {}

local lsp_formatting = function(bufnr, client)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
        async = #client == 1,
    })
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
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
                end, vim.lsp.get_clients({ buffer = bufnr }))
                lsp_formatting(args.bufnr, clients)
            end,
        })
    end
end
function M.setup()
    local null_ls = require("null-ls")

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
            require("modules.lsp.lsp.utils").format_on_save(true)

            -- if lambda.config.lsp.use_format_modifcation then
            --     if vim.fn.isdirectory(".git/index") then
            --         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            --         require("lsp-format-modifications").attach(client, bufnr, { format_on_save = true })
            --     else
            --         vim.api.nvim_clear_autocmds({
            --             group = "NvimFormatModificationsDocumentFormattingGroup",
            --             buffer = bufnr,
            --         })
            --     end
            -- else
            --     augroup_setup(client, bufnr)
            -- end
            -- vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
            --     lsp_formatting(bufnr)
            -- end, {})
        end,
    }

    null_ls.setup(cfg)
end

return M
