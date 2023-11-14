local function quick_toggle(prefix, suffix, callback, name)
    require("hydra")({
        name = name,
        body = prefix,
        mode = "n",
        config = {
            timeout = 5000,
            on_key = function()
                -- Preserve animation
                vim.wait(50, function()
                    vim.cmd("redraw!")
                    return false
                end, 30, false)
            end,
        },
        heads = {
            { suffix, callback, { desc = name } },
        },
    })
end
quick_toggle("<leader>T", "d", function()
    require("modules.lsp.lsp.utils").toggle_diagnostics()
end)
quick_toggle("<leader>T", "i", loadstring("vim.lsp.buf.inlay_hint(0)"))
