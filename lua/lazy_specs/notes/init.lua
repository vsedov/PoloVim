return {
    {
        "neorg",
        ft = "norg",
        cmd = "Neorg",
        before = function()
            vim.defer_fn(function()
                -- require("lazy_specs.notes.norg.commands").setup({})
                -- require("lazy_specs.notes.norg.autocmd").setup({})
            end, 500)
        end,
        after = function()
            local opts = require("lazy_specs.notes.neorg").opts
            require("lazy_specs.notes.neorg").config(opts)
        end,
    },
}
