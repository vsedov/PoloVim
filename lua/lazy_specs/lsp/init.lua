local conf = require("plugins.lsp.config")

return {
    {
        "none-ls.nvim",
        after = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            null_ls.setup({
                border = "rounded",
                cmd = { "nvim" },
                debounce = 250,
                debug = false,
                default_timeout = 5000,
                diagnostic_config = {},
                diagnostics_format = "#{m}",
                fallback_severity = vim.diagnostic.severity.ERROR,
                log_level = "warn",
                notify_format = "[null-ls] %s",
                on_init = nil,
                on_exit = nil,
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
                should_attach = nil,
                sources = nil,
                temp_dir = nil,
                update_in_insert = false,
                -- formatting on save
                on_attach = function(client, bufnr)
                    -- method textDocument/documentSymbol is not supported by any of the servers registered for the current buffer
                    client.server_capabilities.documentSymbolProvider = true
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            }) -- end of setup
        end,
    },

    {
        "mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        after = function()
            require("mason-null-ls").setup({
                automatic_setup = true,
                ensure_installed = { "shfmt", "prettier", "stylua", "black", "isort" },
                handlers = {},
            })
        end,
    },
    {
        "actions-preview.nvim",
        keys = {
            {
                "\\;",
                function()
                    require("actions-preview").code_actions()
                end,
                mode = { "n", "v" },
            },
        },
        after = function()
            require("actions-preview").setup({
                diff = {
                    algorithm = "patience",
                    ignore_whitespace = true,
                },
                telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
            })
        end,
    },
    {
        "better-diagnostic-virtual-text",
        event = "LspAttach",
        after = function()
            local default_options = {
                ui = {
                    wrap_line_after = true, -- Wrap the line after this length to avoid the virtual text is too long
                    left_text_space = 2, -- The left at the left side of the text in each line
                    right_text_space = 2, -- The right at the right side of the text in each line
                    left_kept_space = 3, --- The number of spaces kept on the left side of the virtual text, make sure it enough to custom for each line
                    right_kept_space = 3, --- The number of spaces kept on the right side of the virtual text, make sure it enough to custom for each line
                    arrow = "  ",
                    up_arrow = "  ",
                    down_arrow = "  ",
                    above = false, -- The virtual text will be displayed above the line
                },
                inline = true,
            }
            require("better-diagnostic-virtual-text").setup(default_options)
        end,
    },

    {
        "inc-rename.nvim",
        keys = {
            {
                "<leader>gr",
                function()
                    return string.format(":IncRename %s", vim.fn.expand("<cword>"))
                end,
                expr = true,
                silent = false,
                desc = "lsp: incremental rename",
            },
        },
    },
    {
        "glance.nvim",
        event = "LspAttach",
        after = function()
            local glance = require("glance")
            local actions = glance.actions
            glance.setup({
                height = 18, -- Height of the window
                zindex = 45,

                -- By default glance will open preview "embedded" within your active window
                -- when `detached` is enabled, glance will render above all existing windows
                -- and won't be restiricted by the width of your active window
                detached = true,

                preview_win_opts = { -- Configure preview window options
                    cursorline = true,
                    number = true,
                    wrap = true,
                },
                border = {
                    enable = false, -- Show window borders. Only horizontal borders allowed
                    top_char = "―",
                    bottom_char = "―",
                },
                list = {
                    position = "right", -- Position of the list window 'left'|'right'
                    width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
                },
                theme = { -- This feature might not work properly in nvim-0.7.2
                    enable = true, -- Will generate colors for the plugin based on your current colorscheme
                    mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
                },
                mappings = {
                    list = {
                        ["j"] = actions.next, -- Bring the cursor to the next item in the list
                        ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
                        ["<Down>"] = actions.next,
                        ["<Up>"] = actions.previous,
                        ["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
                        ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
                        ["<C-u>"] = actions.preview_scroll_win(5),
                        ["<C-d>"] = actions.preview_scroll_win(-5),
                        ["v"] = actions.jump_vsplit,
                        ["s"] = actions.jump_split,
                        ["t"] = actions.jump_tab,
                        ["<CR>"] = actions.jump,
                        ["o"] = actions.jump,
                        ["l"] = actions.open_fold,
                        ["h"] = actions.close_fold,
                        ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
                        ["q"] = actions.close,
                        ["Q"] = actions.close,
                        ["<Esc>"] = actions.close,
                        ["<C-q>"] = actions.quickfix,
                        -- ['<Esc>'] = false -- disable a mapping
                    },
                    preview = {
                        ["Q"] = actions.close,
                        ["<Tab>"] = actions.next_location,
                        ["<S-Tab>"] = actions.previous_location,
                        ["<leader>l"] = actions.enter_win("list"), -- Focus list window
                    },
                },
                hooks = {},
                folds = {
                    fold_closed = "",
                    fold_open = "",
                    folded = true, -- Automatically fold list on startup
                },
                indent_lines = {
                    enable = true,
                    icon = "│",
                },
                winbar = {
                    enable = true, -- Available strating from nvim-0.8+
                },
                use_trouble_qf = true, -- Quickfix action will open trouble.nvim instead of built-in quickfix list window
            })
        end,
    },
    {
        "lsp_signature.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("lsp_signature").setup({})
        end,
    },
    {
        "glance.nvim",
        event = "BufWinEnter",
        after = conf.glance,
    },
}
