-- https://github.com/fitrh/init.nvim/blob/e787af19c1f59e02a12e98cdcb6a93e7beadb018/lua/config/plugin/null-ls/with.lua
local With = {}
local null_ls = require("null-ls")
local plaintext = { "gitcommit", "markdown", "norg" }
local file_type_exclude =
    { "memento", "norg", "gitcommit", "NeogitStatus", "NeogitCommitMessage", "harpoon-menu", "harpoon" }

With.trim_newlines = {
    name = "trim_newlines",
    disabled_filetypes = file_type_exclude,
}

With.trim_whitespace = {
    name = "trim_whitespace",
    disabled_filetypes = file_type_exclude,
}

With.codespell = {
    disabled_filetypes = file_type_exclude,
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
}

With.black = {
    extra_args = { "--line-length", vim.bo.textwidth },
}

With.cppcheck = {
    condition = function(u)
        return u.root_has_file({ ".cppcheck" })
    end,
    extra_args = { "--cppcheck-build-dir=.cppcheck" },
}

With.djlint = {
    condition = function(u)
        return u.root_has_file({ ".djlintrc" })
    end,
}

With.eslint_d = {
    condition = function(u)
        return u.root_has_file({
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
        })
    end,
    extra_filetypes = { "svelte" },
}

With.golangci_lint = {
    condition = function(u)
        return u.root_has_file({
            ".golangci.yml",
            ".golangci.yaml",
            ".golangci.toml",
            ".golangci.json",
        })
    end,
}

With.isort = {
    extra_args = { "--profile", "black" },
}

With.ktlint = {
    timeout = 10000,
}

With.misspell = {
    filetypes = { "markdown", "text", "txt" },
    args = { "$FILENAME" },
}

With.mypy = {
    condition = function(u)
        return u.root_has_file({ "mypy.ini", ".mypy.ini" })
    end,
}

With.phpstan = {
    condition = function(u)
        return u.root_has_file({ "phpstan.neon", "phpstan.neon.dist" })
    end,
}

With.pint = {
    condition = function(u)
        return u.root_has_file({ "pint.json" })
    end,
}

With.pylint = {
    condition = function(u)
        return u.root_has_file({ "pylintrc", ".pylintrc" })
    end,
}

With.revive = {
    args = { "-config", "revive.toml", "-formatter", "json", "./..." },
    condition = function(u)
        return u.root_has_file({ "revive.toml" })
    end,
}

With.prettierd = {
    condition = function(u)
        return u.root_has_file({
            ".prettierrc",
            ".prettierrc.yml",
            ".prettierrc.json",
        })
    end,
    extra_filetypes = { "svelte" },
}

With.selene = {
    condition = function(u)
        return u.root_has_file({ "selene.toml" })
    end,
}

With.shfmt = {
    extra_args = { "-i", "4", "-ci" },
}

With.staticcheck = {
    condition = function(u)
        return u.root_has_file({ "staticcheck.conf" })
    end,
}

With.stylelint = {
    condition = function(u)
        return u.root_has_file({
            ".stylelintrc",
            ".stylelintrc.json",
            ".stylelintrc.yml",
            ".stylelintrc.js",
            "stylelint.config.js",
            "stylelint.config.cjs",
        })
    end,
}

With.stylua = {
    condition = function(u)
        return u.root_has_file({ "stylua.toml", ".stylua.toml" })
    end,
}

With.write_good = {
    filetypes = { "markdown", "norg" },
    extra_filetypes = { "txt", "text" },
    args = { "--text=$TEXT", "--parse" },
    command = "write-good",
}
-- see how this works for python based files .
With.semgrep = {
    filetypes = {
        "go",
        "python",
        "ruby",
        "kotlin",
        "c",
        "c++",
        "lua",
        "rust",
    },
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    extra_args = { "--config=auto" },
}

With.flake8 = {
    condition = function(u)
        return vim.api.nvim_buf_line_count(
            -- Current buffer
            0
        ) < 8000
    end,

    -- for the time, lets see how much lag this would reduce.
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
}

With.ruff = {
    condition = function(u)
        return u.root_has_file({
            "pyproject.toml",
            "poetry.toml",
        })
    end,
}

return With
