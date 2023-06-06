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

local get_extra_binds = function()
    local binds = {}
    if lambda.config.use_saga_maps then
        binds = {
            ["gd"] = { "<cmd> Lspsaga peek_definition<cr>", "preview_definition" },

            ["gh"] = { "<cmd> Lspsaga lsp_finder<cr>", "lsp_finder" },
            ["gs"] = { "<cmd> Lspsaga goto_definition<cr>", "Goto Def" },
            -- ["<C-f>"] = { "<cmd> lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", "lsp scroll up" },
            -- ["<C-b>"] = { "<cmd> lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", "lsp scroll down" },

            ["gr"] = { "<cmd>Lspsaga rename<CR>", "rename" },
            ["gR"] = { "<cmd>Lspsaga rename ++project<CR>", "Rename Project" },

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
            ["gD"] = { require("definition-or-references").definition_or_references, "Goto Def" },

            ["<leader>ap"] = { "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "incoming calls" },
            ["<leader>ao"] = { "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", "outgoing calls" },
            ["K"] = {
                function()
                    if not lambda.config.lsp.use_hover then
                        vim.cmd([[Lspsaga hover_doc]])
                    else
                        require("hover").hover()
                    end
                end,
                "hover",
            },

            ["gk"] = {
                function()
                    vim.cmd([[Lspsaga hover_doc ++keep]])
                end,
                "Hover Left",
            },
        },
        visual_mode = {
            ["\\'"] = { "<cmd>Lspsaga range_code_action()<CR>", "Code action" },
        },
        insert_mode = {},
        extra_binds = get_extra_binds(),
    },
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
