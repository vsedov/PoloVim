local leader = "\\l"

local mx = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
    end
end

local config = {}

config = {
    Parenth = {
        color = "pink",
        body = leader,
        ["<ESC>"] = { nil, { exit = true } },
        j = {
            function()
                vim.fn.search("[({[]")
            end,
            { nowait = true, desc = "next" },
        },
        k = {
            function()
                vim.fn.search("[({[]", "b")
            end,
            { nowait = true, desc = "next" },
        },
        J = {
            function()
                vim.fn.search("[)}\\]]")
            end,
            { nowait = true, desc = "next" },
        },
        K = {
            function()
                vim.fn.search("[)}\\]]", "b")
            end,
            { nowait = true, desc = "next" },
        },

        [")"] = { mx("ysi%)"), { nowait = true, desc = "i)" } },
        ["("] = { mx("ysa%)"), { nowait = true, desc = "a(" } },
        ["]"] = { mx("ysi%]"), { nowait = true, desc = "i]" } },
        ["["] = { mx("ysa%]"), { nowait = true, desc = "a[" } },
        ["}"] = { mx("ysi%}"), { nowait = true, desc = "i}" } },
        ["{"] = { mx("ysa%{"), { nowait = true, desc = "a{" } },
        ["f"] = { mx("ysa%f"), { nowait = true, desc = "af" } },
        ["F"] = { mx("ysi%f"), { nowait = true, desc = "iF" } },
    },
}
for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ d = "d", c = "c", y = "y" }) do
        local motiondoc = surround
        -- if motion == "j" then motiondoc = "i" else motiondoc = "i" end
        local mapping = table.concat({ key, motion })
        config.Parenth[mapping] = {
            mx(table.concat({ key, surround, "%" })),
            { nowait = true, desc = table.concat({ doc, motiondoc }) },
        }
    end
end

bracket = { "F", "J", "K", "f", "j", "k" }

tables = { { "(", ")", "[", "]", "{", "}" }, { "cj", "ck", "dj", "dk", "yj", "yk" } }
return {
    config,
    "Parenth",
    tables,
    bracket,
    6,
    3,
}
