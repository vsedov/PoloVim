local leader = ";w"
local tc = require("nvim-treeclimber")

local bracket = { "h", "j", "k", "l", "w" }

local exit = { nil, { exit = true, desc = "EXIT" } }

local config = {
    Climber = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },

        h = {
            tc.select_backward,

            { nowait = false, desc = "TC B" },
        },
        j = {
            tc.select_shrink,
            { nowait = true, desc = "TC Shrink" },
        },
        k = {
            tc.select_expand,
            { nowait = true, desc = "TC Expand" },
        },
        l = {
            tc.select_forward,
            { nowait = true, desc = "TC F" },
        },

        w = {
            tc.show_control_flow,
            { nowait = true, desc = "TC Flow " },
        },
        c = {
            tc.select_current_node,
            { nowait = true, desc = "TC C Node" },
        },

        e = {
            tc.select_forward_end,
            { nowait = true, desc = "TC [E] F Node" },
        },

        --
        s = {
            tc.select_siblings_backward,
            { nowait = true, desc = "Sib Node B" },
        },
        S = {
            tc.select_siblings_forward,
            { nowait = true, desc = "Sib Node F" },
        },

        ["["] = {
            tc.select_grow_forward,
            { nowait = true, desc = "TC Grow F" },
        },
        ["]"] = {
            tc.select_grow_backward,
            { nowait = true, desc = "TC Grow B" },
        },
        W = {
            tc.select_top_level,
            { nowait = true, desc = "TC Top Level" },
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
