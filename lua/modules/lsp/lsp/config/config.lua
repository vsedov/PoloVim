local container = {
    on_attach_callback = {
        ["pylance"] = function(client, bufnr)
            print("Pylance has been parsed")
            require("modules.lsp.lsp.providers.python.pylance").attach_config(client, bufnr)
        end,
        ["pyright"] = function(client, bufnr)
            require("modules.lsp.lsp.providers.python.pyright").attach_config(client, bufnr)
        end,
        ["ltex"] = function(client, bufnr)
            require("modules.lsp.lsp.providers.latex.ltex").attach_config(client, bufnr)
        end,
        ["ruff_lsp"] = function(client, bufnr)
            client.server_capabilities.hoverProvider = false
        end,
    },

    null_ls = {
        diagnostic = {
            "cppcheck",
            "djlint",
            "eslint_d",
            "golangci_lint",
            "ktlint",
            "markdownlint",
            "misspell",
            "phpcs",
            "staticcheck",
            "stylelint",
            "write_good",
            "luacheck",
        },
        formatter = {
            "scalafmt",
            "stylish_haskell",
            "djlint",
            "fish_indent",
            "ktlint",
            "markdownlint",
            "phpcbf",
            "pint",
            "prettierd",
            "shellharden",
            "shfmt",
            "stylelint",
            "stylua",
            "trim_newlines",
            "trim_whitespace",
            "pyflyby",
        },
        code_action = { "eslint_d", "gitrebase", "refactoring" },
    },
}
return container
