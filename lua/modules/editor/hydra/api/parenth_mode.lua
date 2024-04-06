local leader = ";l"

local mx = function(feedkeys, type)
    local type = type or "m"
    return function()
        if type == "v" then
            vim.api.nvim_feedkeys(vim.keycode("v", true, true, true), "n", true)
        end

        vim.api.nvim_feedkeys(vim.keycode(feedkeys, true, false, true), type, false)
    end
end

local config = {}

config = {
    Treesitter = {
        color = "pink",
        body = leader,
        ["<ESC>"] = { nil, { exit = true } },
        J = {
            function()
                vim.fn.search("[({[]")
            end,
            { nowait = true, desc = "Next Bracket" },
        },
        n = {
            function()
                vim.fn.search("[)}\\]]")
            end,
            { nowait = true, desc = "Next Bracket" },
        },

        N = {
            function()
                vim.fn.search("[({[]", "b")
            end,
            { nowait = true, desc = "Prev Bracket" },
        },

        K = {
            function()
                vim.fn.search("[)}\\]]", "b")
            end,
            { nowait = true, desc = "Prev Bracket" },
        },

        j = {
            function()
                require("nvim-treesitter.textobjects.move").goto_next_start({ "@function.outer", "@class.outer" })
            end,
            {
                nowait = true,
                desc = "Move [N] ←",
            },
        },
        h = {
            function()
                require("nvim-treesitter.textobjects.move").goto_next_end({ "@function.outer", "@class.outer" })
            end,
            { nowait = true, desc = "Move [N] →" },
        },
        k = {
            function()
                require("nvim-treesitter.textobjects.move").goto_previous_start({ "@function.outer", "@class.outer" })
            end,
            { nowait = true, desc = "Move [P] ←" },
        },
        l = {
            function()
                require("nvim-treesitter.textobjects.move").goto_previous_end({ "@function.outer", "@class.outer" })
            end,
            { nowait = true, desc = "Move [P] →" },
        },

        -- ig finds the diagnostic under or after the cursor (including any diagnostic the cursor is sitting on)
        -- ]g finds the diagnostic after the cursor (excluding any diagnostic the cursor is sitting on)
        -- [g finds the diagnostic before the cursor (excluding any diagnostic the cursor is sitting on)

        ["e"] = { mx("[g", "v"), { nowait = true, desc = "Diag A[Cur]" } }, -- ts: all class
        ["E"] = { mx("]g", "v"), { nowait = true, desc = "Diag >[Cur]" } }, -- ts: all class

        ["w"] = { mx("ac", "v"), { nowait = true, desc = "Cls  [ac]" } }, -- ts: all class
        ["W"] = { mx("ic", "v"), { nowait = true, desc = "Cls  [ic]" } }, -- ts: inner class

        ["a"] = { mx("af", "v"), { nowait = true, desc = "Func [af]" } }, -- ts: all function
        ["A"] = { mx("if", "v"), { nowait = true, desc = "Func [if]" } }, -- ts: inner function

        ["i"] = { mx("aC", "v"), { nowait = true, desc = "Cond [aC]" } }, -- ts: all conditional
        ["I"] = { mx("iC", "v"), { nowait = true, desc = "Cond [iC]" } }, -- ts: inner conditional

        ["<CR>"] = { mx(";f"), { nowait = true, desc = "Core f Key ", exit = false } }, -- ts: inner conditional

        [")"] = { mx("ysi%)"), { nowait = true, desc = "ysi % )" } },
        ["("] = { mx("ysa%)"), { nowait = true, desc = "ysa % (" } },
        ["]"] = { mx("ysi%]"), { nowait = true, desc = "yis % ]" } },
        ["["] = { mx("ysa%]"), { nowait = true, desc = "ysa % [" } },
        ["}"] = { mx("ysi%}"), { nowait = true, desc = "yis % }" } },
        ["{"] = { mx("ysa%{"), { nowait = true, desc = "ysa % {" } },

        ["f"] = { mx("ysa%f"), { nowait = true, desc = "Around Function" } },
        ["F"] = { mx("ysi%f"), { nowait = true, desc = "Inner Function" } },
    },
}
for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ d = "d", c = "c", y = "y" }) do
        local motiondoc = surround
        -- if motion == "j" then motiondoc = "i" else motiondoc = "i" end
        local mapping = table.concat({ key, motion })
        config.Treesitter[mapping] = {
            mx(table.concat({ key, surround, "%" })),
            { nowait = true, desc = table.concat({ doc, motiondoc }) },
        }
    end
end

local bracket = {

    "j",
    "k",

    "h",
    "l",

    "<CR>",
}

local tables = {
    { "J", "K", "n", "N", "F", "f" }, -- 6
    { "A", "a", "i", "I", "W", "w", "e", "E" }, -- 8

    { "(", ")", "[", "]", "{", "}" }, -- 6
    { "cj", "ck", "dj", "dk", "yj", "yk" }, -- 6
}
return {
    config,
    "Treesitter",
    tables,
    bracket,
    6,
    3,
    1,
}
