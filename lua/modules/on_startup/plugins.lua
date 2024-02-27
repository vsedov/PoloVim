local startup = require("core.pack").package
-- When you open a file in Vim but it was already open in another instance or not closed properly in a past edit, Vim will warn you, but it won't show you what the difference is between the hidden swap file and the regular saved file. Of all the actions you might want to do, the most obvious one is missing: compare, that is, see a diff.
-- enabled by default, will need to load on boot
startup({
    "chrisbra/Recover.vim",
    cond = true,
    lazy = false,
})

startup({
    "lewis6991/fileline.nvim",
})
