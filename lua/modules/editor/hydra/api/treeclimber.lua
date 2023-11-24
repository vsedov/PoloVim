--  TODO: (vsedov) (16:38:03 - 17/07/23): fix
local leader = ";w"

local bracket = { "h", "j", "k", "l", "w" }

local config = {
    Climber = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },

        h = {
            function()
                require("nvim-treeclimber").select_backward()
            end,
            { exit = true, nowait = false, desc = "TC B" },
        },
        j = {
            function()
                require("nvim-treeclimber").select_shrink()
            end,

            { exit = true, nowait = true, desc = "TC Shrink" },
        },
        k = {
            function()
                require("nvim-treeclimber").select_expand()
            end,
            { exit = true, nowait = true, desc = "TC Expand" },
        },
        l = {
            function()
                require("nvim-treeclimber").select_forward()
            end,
            { exit = true, nowait = true, desc = "TC F" },
        },

        w = {
            function()
                require("nvim-treeclimber").show_control_flow()
            end,
            { exit = true, nowait = true, desc = "TC Flow " },
        },
        c = {
            function()
                require("nvim-treeclimber").select_current_node()
            end,
            { exit = true, nowait = true, desc = "TC C Node" },
        },

        e = {
            function()
                require("nvim-treeclimber").select_forward_end()
            end,
            { exit = true, nowait = true, desc = "TC [E] F Node" },
        },

        --
        s = {
            function()
                require("nvim-treeclimber").select_siblings_backward()
            end,
            { exit = true, nowait = true, desc = "Sib Node B" },
        },
        S = {
            function()
                require("nvim-treeclimber").select_siblings_forward()
            end,
            { exit = true, nowait = true, desc = "Sib Node F" },
        },

        ["["] = {
            function()
                require("nvim-treeclimber").select_grow_forward()
            end,
            { exit = true, nowait = true, desc = "TC Grow F" },
        },
        ["]"] = {
            function()
                require("nvim-treeclimber").select_grow_backward()
            end,
            { exit = true, nowait = true, desc = "TC Grow B" },
        },
        W = {
            function()
                require("nvim-treeclimber").select_top_level()
            end,
            { exit = true, nowait = true, desc = "TC Top Level" },
        },
    },
}

return {
    config,
    "Climber",
    { { "W", "c", "e" }, { "s", "S", "[", "]" } },
    bracket,
    6,
    3,
}
