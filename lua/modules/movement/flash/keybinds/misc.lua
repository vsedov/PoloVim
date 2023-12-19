local lib = require("modules.movement.flash.nav.lib")
local Flash = lambda.reqidx("flash")

return {

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Window Jump and jump lines                                 │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<c-p>",
        mode = { "n" },
        function()
            Flash.jump({
                search = { mode = "search" },
                highlight = { label = { after = { 0, 0 } } },
                pattern = "^",
            })
        end,
        desc = "Jump Windows",
    },
    {
        "<c-e>",
        mode = { "n" },
        lib.flash_lines,
        desc = "Jump Lines",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Fold                                                       │
    --  ╰────────────────────────────────────────────────────────────────────╯
    {
        "z<cr>",
        function()
            Flash.treesitter()
            vim.cmd("normal! Vzf")
        end,
        mode = { "n" },
        silent = true,
        desc = "God Fold",
    },
}
