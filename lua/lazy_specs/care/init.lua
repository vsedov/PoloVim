return {
    {

        "care.nvim",
        event = "InsertEnter",
        after = function()
            local conf = require("plugins.completion.config")
            local labels = { "q", "w", "r", "t", "z", "i", "o" }

            local labels = { "q", "w", "r", "t", "z", "i", "o" }

            require("care").setup({
                ui = {
                    menu = {
                        max_height = 10,

                        format_entry = function(entry, data)
                            local completion_item = entry.completion_item
                            local type_icons = require("care.config").options.ui.type_icons or {}
                            local entry_kind = type(completion_item.kind) == "string" and completion_item.kind
                                or require("care.utils.lsp").get_kind_name(completion_item.kind)
                            return {
                                {
                                    {
                                        " " .. require("care.presets.utils").LabelEntries(labels)(entry, data) .. " ",
                                        "Comment",
                                    },
                                },
                                { { completion_item.label .. " ", data.deprecated and "Comment" or "@care.entry" } },
                                {
                                    {
                                        " " .. (type_icons[entry_kind] or type_icons.Text) .. " ",
                                        ("@care.type.blended.%s"):format(entry_kind),
                                    },
                                },
                                {
                                    {
                                        " (" .. data.source_name .. ") ",
                                        ("@care.type.fg.%s"):format(entry_kind),
                                    },
                                },
                            }
                        end,
                        -- alignment = { "left", "left", "right" },
                        scrollbar = {
                            -- character = "║",
                            character = "┃",
                        },
                    },
                    ghost_text = { enabled = false },
                },
                sources = {
                    lsp = {
                        filter = function(entry)
                            return entry.completion_item.kind ~= 1
                        end,
                        -- priority = 5,
                        -- enabled = false,
                    },
                    cmp_buffer = {
                        -- priority = 5,
                        enabled = true,
                    },
                },
                -- completion_events = {},
                -- preselect = false,
                -- selection_behavior = "insert",
                -- sorting_direction = "away-from-cursor",
                -- debug = false,
                selection_behavior = "insert",
                confirm_behavior = "insert",
                keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
                preselect = false,
                sorting_direction = "top-down", -- away-from-cursror,
                completion_events = { "TextChangedI" }, -- InsertEnter also works
                enabled = function()
                    local enabled = true
                    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
                        enabled = false
                    end
                    return enabled
                end,
                max_view_entries = 400,
                debug = false,
            })

            -- Keymappings
            for i, label in ipairs(labels) do
                vim.keymap.set("i", "<c-" .. label .. ">", function()
                    require("care").api.select_visible(i)
                end)
            end

            vim.keymap.set("i", "<c-n>", function()
                vim.snippet.jump(1)
            end)
            vim.keymap.set("i", "<c-p>", function()
                vim.snippet.jump(-1)
            end)
            vim.keymap.set("i", "<CR>", function()
                require("care").api.complete()
            end)

            vim.keymap.set("i", "<c-f>", function()
                if require("care").api.doc_is_open() then
                    require("care").api.scroll_docs(4)
                elseif require("luasnip").choice_active() then
                    require("luasnip").change_choice(1)
                else
                    vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
                end
            end)

            vim.keymap.set("i", "<c-d>", function()
                if require("care").api.doc_is_open() then
                    require("care").api.scroll_docs(-4)
                elseif require("luasnip").choice_active() then
                    require("luasnip").change_choice(-1)
                else
                    vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
                end
            end)

            vim.keymap.set("i", "<cr>", "<Plug>(CareConfirm)")
            vim.keymap.set("i", "<c-e>", "<Plug>(CareClose)")
            vim.keymap.set("i", "<S-Tab>", "<Plug>(CareSelectPrev)")
            vim.keymap.set("i", "<Tab>", "<Plug>(CareSelectNext)")

            -- or "<Plug>(neotab-out)"
            vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help)
            vim.api.nvim_create_autocmd("CursorHoldI", {
                desc = "Show diagnostics on CursorHold",
                pattern = "* !silent",

                callback = function()
                    vim.lsp.buf.signature_help()
                end,
            })
        end,
    },
}

-- conf.luasnip()
--
-- require("luasnip-latex-snippets").setup()
-- require("luasnip").config.setup({ enable_autosnippets = true })
--
-- conf.neotab()
-- conf.autopair()