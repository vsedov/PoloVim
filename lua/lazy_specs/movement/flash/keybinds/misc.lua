local lib = require("modules.movement.flash.nav.lib")
local Flash = lambda.reqidx("flash")

return {

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Window Jump and jump lines                                 │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<c-p>",
        mode = { "n" },
        lib.jump_windows,
        desc = "Jump Windows",
    },
    {
        "<c-e>",
        mode = { "n" },
        -- lib.flash_lines,
        function()
            require("flash").jump({
                search = { mode = "search", max_length = 0 },
                highlight = {
                    label = { after = { 0, 0 } },
                    matches = false,
                },
                pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
            })
        end,
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
