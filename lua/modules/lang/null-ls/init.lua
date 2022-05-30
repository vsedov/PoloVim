return {
    config = function()
        local null_ls = require("null-ls")
        local lspconfig = require("lspconfig")

        local diagnostics = null_ls.builtins.diagnostics
        local actions = null_ls.builtins.code_actions
        -- local hover = null_ls.builtins.hover
        local sources = {
            -- null_ls.builtins.formatting.yapf,
            -- null_ls.builtins.formatting.isort,
            null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.yamllint,
            null_ls.builtins.code_actions.proselint,
            null_ls.builtins.code_actions.refactoring,
            -- hover.dictionary,
            diagnostics.misspell.with({
                filetypes = { "markdown", "text", "txt" },
                args = { "$FILENAME" },
            }),
            diagnostics.write_good.with({
                filetypes = { "markdown", "tex", "" },
                extra_filetypes = { "txt", "text" },
                args = { "--text=$TEXT", "--parse" },
                command = "write-good",
            }),
            diagnostics.proselint.with({
                filetypes = { "markdown", "tex" },
                extra_filetypes = { "txt", "text" },
                command = "proselint",
                args = { "--json" },
            }),
            actions.proselint.with({ filetypes = { "markdown", "tex" }, command = "proselint", args = { "--json" } }),
        }

        local function exist(bin)
            return vim.fn.exepath(bin) ~= ""
        end
        local format_lint_types = {
            ["rustfmt"] = null_ls.builtins.formatting.rustfmt,
            ["latexindent"] = null_ls.builtins.formatting.latexindent,
            ["shellcheck"] = null_ls.builtins.diagnostics.shellcheck,
            ["shfmt"] = null_ls.builtins.formatting.shfmt,
            ["golangci-lint"] = null_ls.builtins.diagnostics.golangci_lint,
            ["hadolint"] = null_ls.builtins.diagnostics.hadolint, -- docker
            ["eslint_d"] = null_ls.builtins.diagnostics.eslint_d,
            ["prettierd"] = null_ls.builtins.formatting.prettierd,
            -- ["selene"]= null_ls.builtins.diagnostics.selene, -- doesnt like gobals and i cant shut it up .
            ["stylua"] = null_ls.builtins.formatting.stylua.with({
                extra_args = { "--config-path", vim.fn.expand("~/.config/stylua.toml") },
            }),
            ["luacheck"] = null_ls.builtins.diagnostics.luacheck,
            ["vulture"] = null_ls.builtins.diagnostics.vulture,
            ["clang-format"] = null_ls.builtins.formatting.clang_format.with({
                extra_args = { "-style=file" },
            }),
            ["cppcheck"] = null_ls.builtins.diagnostics.cppcheck,
        }
        if use_gitsigns() then
            table.insert(sources, null_ls.builtins.code_actions.gitsigns)
        end

        for k, v in pairs(format_lint_types) do
            if exist(k) then
                table.insert(sources, v)
            end
        end
        local cfg = {
            sources = sources,
            debounce = 500,
            default_timeout = 3000,
            fallback_severity = vim.diagnostic.severity.WARN,
            root_dir = lspconfig.util.root_pattern(
                ".venv", -- for python
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
            diagnostics_format = "#{s}: #{m} (#{c})",
            on_attach = require("modules.lsp.lsp.utils").common_on_init,

            -- on_attach = function(client)
            --     if client.server_capabilities.documentFormatting then
            --         vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
            --     end
            -- end,
        }

        null_ls.setup(cfg)
    end,
}
