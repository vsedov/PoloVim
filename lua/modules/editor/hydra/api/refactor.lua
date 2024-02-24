local leader = ";e"
local config = {
    Refactor = {
        body = leader,
        mode = { "n", "v" },
        ["<ESC>"] = { nil, { exit = true } },
        r = {
            function()
                require("refactoring").select_refactor()
            end,
            { exit = true, desc = "Select refactor" },
        },
        i = {
            function()
                require("refactoring").refactor("Inline Variable")
            end,
            { exit = true, desc = "Inline variable" },
        },
        b = {
            function()
                require("refactoring").refactor("Extract Block")
            end,
            { exit = true, desc = "Extract block" },
        },
        B = {
            function()
                require("refactoring").refactor("Extract Block To File")
            end,
            { exit = true, desc = "Extract block to file" },
        },
        p = {
            function()
                require("refactoring").debug.print_var({ normal = true })
            end,
            { exit = true, desc = "Debug print" },
        },
        c = {
            function()
                require("refactoring").debug.cleanup({})
            end,
            { exit = true, desc = "Debug print cleanup" },
        },
        v = {
            function()
                require("refactoring").refactor("Extract Function")
            end,
            { exit = true, desc = "Extract function" },
        },
        f = {
            function()
                require("refactoring").refactor("Extract Function To File")
            end,
            { exit = true, desc = "Extract function to file" },
        },
        e = {
            function()
                require("refactoring").refactor("Extract Variable")
            end,
            { exit = true, desc = "Extract variable" },
        },
    },
}
return {
    config,
    "Refactor",
    { { "b", "B", "p", "c", "v", "f", "e" } },
    { "r", "i" },
    6,
    3,
}
