require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    neorg = "~/neorg",
                }
            }
        },
        ["core.concealer"] = {},
    }
})
