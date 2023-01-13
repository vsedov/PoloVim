local border = {
    -- { "╔", "FloatBorder" },
    -- { "═", "FloatBorder" },
    -- { "╗", "FloatBorder" },
    -- { "║", "FloatBorder" },
    -- { "╝", "FloatBorder" },
    -- { "═", "FloatBorder" },
    -- { "╚", "FloatBorder" },
    -- { "║", "FloatBorder" },

    { "🭽", "FloatBorder" },
    { "▔", "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕", "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁", "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏", "FloatBorder" },

    --   { "┏", "FloatBorder" },
    --   { "━", "FloatBorder" },
    --   { "┓", "FloatBorder" },
    --   { "┃", "FloatBorder" },
    --   { "┛", "FloatBorder" },
    --   { "━", "FloatBorder" },
    --   { "┗", "FloatBorder" },
    --   { "┃", "FloatBorder" },
    --
    --   {  "▛","FloatBorder"},
    --   {  "▀","FloatBorder"},
    --   {  "▜","FloatBorder"},
    --   {  "▐","FloatBorder"},
    --   {  "▟","FloatBorder"},
    --   {  "▄","FloatBorder"},
    --   {  "▙","FloatBorder"},
    --   {  "▌","FloatBorder"},

    --   { "╭", "FloatBorder" },
    --   { "─", "FloatBorder" },
    --   { "╮", "FloatBorder" },
    --   { "│", "FloatBorder" },
    --   { "╯", "FloatBorder" },
    --   { "─", "FloatBorder" },
    --   { "╰", "FloatBorder" },
    --   { "│", "FloatBorder" },
}
local codes = {
    no_matching_function = {
        message = " Can't find a matching function",
        "redundant-parameter",
        "ovl_no_viable_function_in_call",
    },
    empty_block = {
        message = " That shouldn't be empty here",
        "empty-block",
    },
    missing_symbol = {
        message = " Here should be a symbol",
        "miss-symbol",
    },
    expected_semi_colon = {
        message = " Remember the `;` or `,`",
        "expected_semi_declaration",
        "miss-sep-in-table",
        "invalid_token_after_toplevel_declarator",
    },
    redefinition = {
        message = " That variable was defined before",
        "redefinition",
        "redefined-local",
    },
    no_matching_variable = {
        message = " Can't find that variable",
        "undefined-global",
        "reportUndefinedVariable",
    },
    trailing_whitespace = {
        message = " Remove trailing whitespace",
        "trailing-whitespace",
        "trailing-space",
    },
    unused_variable = {
        message = " Don't define variables you don't use",
        "unused-local",
    },
    unused_function = {
        message = " Don't define functions you don't use",
        "unused-function",
    },
    useless_symbols = {
        message = " Remove that useless symbols",
        "unknown-symbol",
    },
    wrong_type = {
        message = " Try to use the correct types",
        "init_conversion_failed",
    },
    undeclared_variable = {
        message = " Have you delcared that variable somewhere?",
        "undeclared_var_use",
    },
    lowercase_global = {
        message = " Should that be a global? (if so make it uppercase)",
        "lowercase-global",
    },
}

local get_extra_binds = function()
    local binds = {}
    if lambda.config.use_saga_maps then
        binds = {
            ["gd"] = { "<cmd> Lspsaga peek_definition<cr>", "preview_definition" },
            ["gh"] = { "<cmd> Lspsaga lsp_finder<cr>", "lsp_finder" },
            ["gs"] = { "<cmd> Lspsaga signature_help<cr>", "signature_help" },
            -- ["<C-f>"] = { "<cmd> lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", "lsp scroll up" },
            -- ["<C-b>"] = { "<cmd> lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", "lsp scroll down" },

            ["gr"] = { "<cmd>Lspsaga rename<CR>", "rename" },
            ["gI"] = { "<cmd>Lspsaga implement<CR>", "implementation" },

            ["[E"] = {
                function()
                    require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
                end,
                "Error Diagnostic",
            },
            ["]E"] = {
                function()
                    require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
                end,
                "Error Diagnostic",
            },
            ["[e"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Diagnostic Jump next" },
            ["]e"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Diagnostic Jump prev" },
        }
    else
        binds = {
            ["[e"] = { "<cmd> lua vim.diagnostic.goto_prev({ float = false })<cr>", "Diagnostic Jump next" },
            ["]e"] = { "<cmd> lua vim.diagnostic.goto_next({ float = false })<cr>", "Diagnostic Jump prev" },
        }
    end
    return binds
end
local container = {
    buffer_mappings = {
        normal_mode = {
            ["<leader>ap"] = { "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "incoming calls" },
            ["<leader>ao"] = { "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "outgoing calls" },
            ["<leader>;"] = {
                function()
                    require("modules.lsp.lsp.config.list").change_active("Quickfix")
                    vim.lsp.buf.references()
                end,
                "utils list quickfix change",
            },
            ["K"] = {
                function()
                    if lambda.config.lsp.use_ruff_lsp then
                        vim.cmd([[Lspsaga hover_doc]])
                    else
                        require("hover").hover()
                    end
                end,
                "hover",
            },
            ["gK"] = {

                function()
                    if lambda.config.lsp.use_ruff_lsp then
                        vim.cmd([[Lspsaga hover_doc]])
                    else
                        require("hover").hover_select()
                    end
                end,
                "Hover select",
            },
        },
        visual_mode = {
            ["\\'"] = { "<cmd>Lspsaga range_code_action()<CR>", "Code action" },
        },
        insert_mode = {},
        extra_binds = get_extra_binds(),
    },
    signs = {
        { name = "DiagnosticSignError", text = lambda.style.icons.lsp.error },
        { name = "DiagnosticSignWarn", text = lambda.style.icons.lsp.warn },
        { name = "DiagnosticSignHint", text = lambda.style.icons.lsp.hint },
        { name = "DiagnosticSignInfo", text = lambda.style.icons.lsp.info },
    },
    diagnostics = {
        signs = true,
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            border = border,
            scope = "cursor",
            source = "always",
            format = function(diagnostic)
                -- require("utils.helpers.helper").dump(diagnostic)
                if diagnostic.user_data == nil then
                    return diagnostic.message
                elseif vim.tbl_isempty(diagnostic.user_data) then
                    return diagnostic.message
                end
                local code = diagnostic.user_data.lsp.code
                for _, table in pairs(codes) do
                    if vim.tbl_contains(table, code) then
                        return table.message
                    end
                end
                return diagnostic.message
            end,
            header = { "Cursor Diagnostics:", "DiagnosticHeader" },
            prefix = function(diagnostic, i, total)
                local icon, highlight
                if diagnostic.severity == 1 then
                    icon = ""
                    highlight = "DiagnosticError"
                elseif diagnostic.severity == 2 then
                    icon = ""
                    highlight = "DiagnosticWarn"
                elseif diagnostic.severity == 3 then
                    icon = ""
                    highlight = "DiagnosticInfo"
                elseif diagnostic.severity == 4 then
                    icon = ""
                    highlight = "DiagnosticHint"
                end
                return i .. "/" .. total .. " " .. icon .. "  ", highlight
            end,
        },
    },
    document_highlight = true,
    code_lens_refresh = true,
    float = {
        focusable = true,
        border = border,
        source = "always",
    },
    open_float = (function(orig)
        return function(bufnr, opts)
            local line_number = vim.api.nvim_win_get_cursor(0)[1] - 1
            local opts = opts or {}

            local diagnostics = vim.diagnostic.get(opts.bufnr or 0, { lnum = line_number })
            local max_severity = vim.diagnostic.severity.HINT
            for _, d in ipairs(diagnostics) do
                if d.severity < max_severity then
                    max_severity = d.severity
                end
            end
            local border_color = ({
                [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
                [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
                [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            })[max_severity]
            opts.border = border
            orig(bufnr, opts)
        end
    end)(vim.diagnostic.open_float),
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
    },

    on_init_callback = nil,
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
            "brittany",
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
        },
        code_action = { "eslint_d", "gitrebase", "refactoring" },
    },
}

return container
