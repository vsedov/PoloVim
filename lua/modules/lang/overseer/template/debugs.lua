return {
    {
        name = "View LSP Logs",
        builder = function()
            return {
                name = "View LSP Logs",
                cmd = "tail --follow --retry ~/.local/state/nvim/lsp.log | less -S",
            }
        end,
        priority = 6000,
        params = {},
    },
    {
        name = "View Neovim Logs",
        builder = function()
            return {
                name = "View Neovim Logs",
                cmd = "tail --follow --retry ~/.local/state/nvim/log | less -S",
            }
        end,
        priority = 6000,
        params = {},
    },
    {
        generator = function()
            local logHandler = io.popen([[fd -e log]])
            local ret = {}
            if logHandler then
                local logs = logHandler:read("*a")
                logHandler:close()
                for log in logs:gmatch("([^\r\n]+)") do
                    table.insert(ret, {
                        name = "Show " .. log,
                        builder = function()
                            return {
                                name = "Show " .. log,
                                cmd = "tail --follow --retry " .. log,
                            }
                        end,
                        priority = 1000,
                        params = {},
                    })
                end
            end
            return ret
        end,
    },

    {
        name = "System Info (btop)",
        builder = function()
            return {
                name = "btop",
                cmd = "btop",
            }
        end,
        priority = 4000,
        params = {},
    },
}
