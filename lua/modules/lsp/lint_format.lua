local uv = vim.uv or vim.loop
local prettier = { "prettierd", "prettier" }
local slow_format_filetypes = {}

local config = {}
function config.get_lsp_fallback(bufnr)
    local formatters = require("conform").list_formatters(bufnr)
    if #formatters > 0 and formatters[1].name == "trim_whitespace" then
        return "always"
    else
        return true
        
    end
end

function config.ale()
    vim.g.ale_virtualtext_cursor = 0
    vim.g.ale_floating_preview = 1
    vim.g.ale_float_window_border = { "│", "─", "╭", "╮", "╯", "╰" }
    vim.g.ale_set_ballons = 1
    vim.g.ale_lint_on_enter = 1
    vim.g.ale_warn_about_trailing_whitespace = 0
    vim.g.ale_fix_on_save = 1
    vim.g.ale_echo_cursor = 0
    vim.g.ale_python_flake8_options = "--max-line-length=88 --ignore=E203,E501,W503"
    vim.g.ale_python_ruff_options = "--ignore E501"
    -- vim.g.ale_python_autoimport_options = "--config-file ~/.vim/autoimport-config.toml"
    vim.g.ale_fixers = {
        python = { "black", "ruff" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        go = { "gopls" },
        typescript = { "eslint" },
    }
    vim.g.ale_linters = {
        lua = {},
        python = {},
        rust = { "analyzer", "rustc" },
        go = { "gopls" },
        typescript = { "eslint" },
    }
end

function config.conform(_, opts)
    vim.list_extend(require("conform.formatters.shfmt").args, { "-i", "2" })
    if vim.g.started_by_firenvim then
        opts.format_on_save = false
        opts.format_after_save = false
    end
    require("conform").setup(opts)
end

function config.nvim_lint(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft
    for k, v in pairs(opts.linters) do
        lint.linters[k] = v
    end
    local timer = assert(uv.new_timer())
    local DEBOUNCE_MS = 500
    local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = aug,
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            timer:stop()
            timer:start(
                DEBOUNCE_MS,
                0,
                vim.schedule_wrap(function()
                    if vim.api.nvim_buf_is_valid(bufnr) then
                        vim.api.nvim_buf_call(bufnr, function()
                            lint.try_lint(nil, { ignore_errors = true })
                        end)
                    end
                end)
            )
        end,
    })
    lint.try_lint(nil, { ignore_errors = true })
end

return config
