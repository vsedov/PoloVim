return {
    {
        "neorg",
        ft = "norg",
        cmd = "Neorg",
        after = function()
            local opts = require("lazy_specs.notes.neorg").opts
            require("lazy_specs.notes.neorg").config(opts)
        end,
    },
}
