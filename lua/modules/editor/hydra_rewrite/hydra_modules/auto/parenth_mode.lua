local hydra = require("hydra")

local mx = require("modules.editor.hydra_rewrite.api.utils").mx
local leader = "\\l"

bracket = { "(", ")", "[", "]", "{", "}" }
-- Single characters - non Capital to Capital then to double characters then brackets
single = {}
for _, v in pairs(sorted) do
    if string.len(v) == 1 and not vim.tbl_contains(bracket, v) then
        table.insert(single, v)
    end
end
table.sort(single)
douible = {}
for _, v in pairs(sorted) do
    if string.len(v) == 2 and not vim.tbl_contains(bracket, v) then
        table.insert(douible, v)
    end
end
table.sort(douible)

return {
    {
        name = "core",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            invoke_on_body = true,
            timeout = false,
        },
        heads = {},
    },

    {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
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
    bracket,

    {
        { 1, single },
        { 1, bracket },
    },
}
