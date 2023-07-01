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

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Lasterisk and better search                                │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "*",
        function()
            require("lasterisk").search()
            lib.search_win()
        end,
        desc = "Search cword *",
    },
    {
        "*",
        function()
            require("lasterisk").search({ is_whole = false })
            vim.schedule(lib.search_win)
            return "<C-\\><C-N>"
        end,
        mode = { "x" },
        expr = true,
        desc = "Search cword *",
    },
    {
        "g*",
        function()
            require("lasterisk").search({ is_whole = false })
            lib.search_win()
        end,
        desc = "Search cword g*",
    },
    {
        "#",
        function()
            if lib.search_ref() then
                return
            end
            require("lasterisk").search()
            lib.search_win()
        end,
        desc = "Search cword (ref) # ",
    },
    {
        "#",
        function()
            require("lasterisk").search({ is_whole = false })

            vim.schedule(lib.search_win)
            return "<C-\\><C-N>"
        end,
        mode = { "x" },
        expr = true,
        desc = "Search #",
    },
    {
        "g#",
        function()
            require("lasterisk").search({ is_whole = false })
            lib.search_win()
        end,

        desc = "Search g#",
    },
}
