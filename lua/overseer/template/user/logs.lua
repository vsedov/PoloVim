return {
    generator = function(_, cb)
        local ret = {
            {
                name = "View LSP Logs",
                builder = function()
                    return {
                        name = "View LSP Logs",
                        cmd = "tail --follow --retry ~/.local/state/nvim/lsp.log | less -S",
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                params = {},
            },
            {
                name = "View Neovim Logs",
                builder = function()
                    return {
                        name = "View Neovim Logs",
                        cmd = "tail --follow --retry ~/.local/state/nvim/log | less -S",
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                params = {},
            },
            {
                name = "Plot from logfile",
                params = {
                    key = {
                        type = "string",
                        name = "Key",
                        desc = "A search term to find the desired parameter to plot",
                        optional = false,
                    },
                },
                builder = function(params)
                    return {
                        name = "Plot " .. params.key,
                        cmd = [[echo temp > /tmp/T.csv; rg ']]
                            .. params.key
                            .. [[' /home/viv/Projects/PowderModel/test/test_outputs/full_out.log | rg -o '[0-9.]*$' >> /tmp/T.csv;
                                julia -e '
                                    using Plots, CSV;
                                    ENV["GKSwstype"]="nul"
                                    gr()
                                    a = CSV.File("/tmp/T.csv")
                                    savefig(plot([a[i][2] for i in 1:length(a)]), "/tmp/T.png")
                                '
                                feh /tmp/T.png
                            ]],
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                condition = {
                    dir = "/home/viv/Projects/PowderModel",
                },
            },
        }
        local logs = vim.fn.systemlist([[fd -e log]])
        for _, log in pairs(logs) do
            table.insert(ret, {
                name = "Show " .. log,
                builder = function()
                    return {
                        name = "Show " .. log,
                        cmd = "tail --follow --retry " .. log,
                        components = { "default", "unique" },
                    }
                end,
                priority = 150,
                params = {},
            })
        end
        cb(ret)
    end,
}
