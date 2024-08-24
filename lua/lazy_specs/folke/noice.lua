local M = {}
function M.noice()
    return {
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
        health = {
            checker = true, -- Disable if you don't want health checks to run
        },
        smart_move = {
            enabled = true, -- you can disable this behaviour here
            excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
    }
end

function M.noice_setup()
    require("noice").setup(M.noice())

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
