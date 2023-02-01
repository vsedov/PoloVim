local tc = require("nvim-treeclimber")

return function()
    return {
        {
            name = "TS",
            config = {
                hint = {
                    position = "middle-right",
                    border = lambda.style.border.type_0,
                },
                timeout = false,
                invoke_on_body = true,
            },
            mode = { "n", "x", "o" },
            heads = {},
        },

        {
            color = "pink",
            body = ";w",
            ["<ESC>"] = { nil, { exit = true } },

            h = {
                function()
                    tc.select_backward()
                end,

                { nowait = false, exit = true, desc = "TC Back" },
            },
            j = {
                function()
                    tc.select_shrink()
                end,
                { nowait = true, desc = "TC Shrink" },
            },
            k = {
                function()
                    tc.select_expand()
                end,
                { nowait = true, desc = "TC Expand" },
            },
            l = {
                function()
                    tc.select_forward()
                end,
                { nowait = true, desc = "TC >" },
            },

            w = {
                function()
                    tc.show_control_flow()
                end,
                { nowait = true, desc = "TC Flow " },
            },
            c = {
                function()
                    tc.select_current_node()
                end,
                { nowait = true, desc = "TC [C] Node" },
            },

            e = {
                function()
                    tc.select_forward_end()
                end,
                { nowait = true, desc = "TC [E] > Node" },
            },

            --
            s = {
                function()
                    tc.select_siblings_backward()
                end,
                { nowait = true, desc = "TC [S] < Node" },
            },
            S = {
                function()
                    tc.select_siblings_forward()
                end,
                { nowait = true, desc = "TC [S] > Node" },
            },

            ["["] = {
                function()
                    tc.select_grow_forward()
                end,
                { nowait = true, desc = "TC Grow >" },
            },
            ["]"] = {
                function()
                    tc.select_grow_backward()
                end,
                { nowait = true, desc = "TC Grow <" },
            },
            W = {
                function()
                    tc.select_top_level()
                end,
                { nowait = true, desc = "TC Top Level" },
            },
        },
        { "h", "j", "k", "l", "w" },
        {
            { 1, { "W", "c", "e" } },
            { 1, { "s", "S", "[", "]" } },
        },
    }
end
