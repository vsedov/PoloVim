local M = {}
function M.noice()
    return {
        cmdline = {
            enabled = false, -- enables the Noice cmdline UI
            -- view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
            opts = {}, -- global options for the cmdline. See section on views
            ---@type table<string, CmdlineFormat>
            format = {
                cmdline = { pattern = "^:", icon = "", lang = "vim" },
                -- search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                -- search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                input = {}, -- Used by input()
                -- lua = false, -- to disable a format, set to `false`
            },
        },
        messages = {
            enabled = false, -- enables the Noice messages UI
        },
        popupmenu = {
            enabled = false, -- enables the Noice popupmenu UI
            backend = "cmp", -- backend to use to show regular cmdline completions
            kind_icons = {}, -- set to `false` to disable icons
        },
        commands = {
            history = {
                view = "split",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
            },
            -- :Noice last
            last = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
                filter_opts = { count = 1 },
            },
            -- :Noice errors
            errors = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = { error = true },
                filter_opts = { reverse = true },
            },
        },
        notify = {
            -- Noice can be used as `vim.notify` so you can route any notification like other messages
            -- Notification messages have their level and other properties set.
            -- event is always "notify" and kind can be any log level as a string
            -- The default routes will forward notifications to nvim-notify
            -- Benefit of using Noice for this is the routing and consistent history view
            enabled = false,
            view = "notify",
        },

        lsp = {
            hover = {
                enabled = lambda.config.folke.noice.lsp.use_noice_hover,
            },
            progress = {
                enabled = false, -- this is just annoying
            },
            signature = {
                enabled = lambda.config.folke.noice.lsp.use_noice_signature, -- this just does not work well .
            },
            message = {
                enabled = false,
            },
            override = {
                -- override the default lsp markdown formatter with Noice
                ["vim.lsp.util.convert_input_to_markdown_lines"] = lambda.config.folke.noice.lsp.use_markdown,
                -- override the lsp markdown formatter with Noice
                ["vim.lsp.util.stylize_markdown"] = lambda.config.folke.noice.lsp.use_markdown,
                -- override cmp documentation with Noice (needs the other options to work)
                ["cmp.entry.get_documentation"] = lambda.config.folke.noice.lsp.use_documentation,
            },
            -- defaults for hover and signature help
            documentation = {
                view = "hover",
                ---@type NoiceViewOptions
                opts = {
                    lang = "markdown",
                    replace = true,
                    render = "plain",
                    format = { "{message}" },
                    win_options = { concealcursor = "n", conceallevel = 3 },
                },
            },
        },
        markdown = {
            hover = {
                ["|(%S-)|"] = vim.cmd.help, -- vim help links
                ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
            },
            highlights = {
                ["|%S-|"] = "@text.reference",
                ["@%S+"] = "@parameter",
                ["^%s*(Parameters:)"] = "@text.title",
                ["^%s*(Return:)"] = "@text.title",
                ["^%s*(See also:)"] = "@text.title",
                ["{%S-}"] = "@parameter",
            },
        },
        health = {
            checker = true, -- Disable if you don't want health checks to run
        },
        smart_move = {
            enabled = true, -- you can disable this behaviour here
            excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
        ---@type NoicePresets
        presets = {
            -- you can enable a preset by setting it to true, or a table that will override the preset config
            -- you can also add custom presets that you can enable/disable with enabled=true
            bottom_search = false, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = true, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
        routes = {
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                opts = { skip = true },
            },
        },
    }
end

function M.noice_setup(_, opts)
    require("noice").setup(opts)

    lambda.highlight.plugin("noice", {
        { NoiceMini = { inherit = "MsgArea", bg = { from = "Normal" } } },
        { NoicePopupBaseGroup = { inherit = "NormalFloat", fg = { from = "DiagnosticSignInfo" } } },
        { NoicePopupWarnBaseGroup = { inherit = "NormalFloat", fg = { from = "Float" } } },
        { NoicePopupInfoBaseGroup = { inherit = "NormalFloat", fg = { from = "Conditional" } } },
        { NoiceCmdlinePopup = { bg = { from = "NormalFloat" } } },
        { NoiceCmdlinePopupBorder = { link = "FloatBorder" } },
        { NoiceCmdlinePopupTitle = { link = "FloatTitle" } },
        { NoiceCmdlinePopupBorderCmdline = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlinePopupBorderSearch = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupBorderFilter = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupBorderHelp = { link = "NoicePopupInfoBaseGroup" } },
        { NoiceCmdlinePopupBorderSubstitute = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupBorderIncRename = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlinePopupBorderInput = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlinePopupBorderLua = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlineIconCmdline = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlineIconSearch = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconFilter = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconHelp = { link = "NoicePopupInfoBaseGroup" } },
        { NoiceCmdlineIconIncRename = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconSubstitute = { link = "NoicePopupWarnBaseGroup" } },
        { NoiceCmdlineIconInput = { link = "NoicePopupBaseGroup" } },
        { NoiceCmdlineIconLua = { link = "NoicePopupBaseGroup" } },
        { NoiceConfirm = { bg = { from = "NormalFloat" } } },
        { NoiceConfirmBorder = { link = "NoicePopupBaseGroup" } },
    })
end

return M
