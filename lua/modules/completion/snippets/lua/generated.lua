local api = vim.api
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local i = ls.insert_node

local snippets = {
    s(
        "my_snippet",
        fmt(
            [=[
Hello {}
]=],
            { i(1, "World") }
        )
    ),

    s(
        "test",
        fmt(
            [=[
local {} = require("module")

local function {}()
local x = {}        local y = {}
end

]=],
            {
                i(1, "module"),
                i(2, "my_func"),
                i(3, "10"),
                i(4, "100"),
            }
        )
    ),

s(
    "control",
    fmt([=[
local function {}()
local x = {}
local y = {}    end
]=], {
        i(1, "my_func"),
        i(2, "10"),
        i(3, "100"),
    })
),

    ------------------------------------------------------ Snippets goes here
}

local autosnippets = {}

-- Snippets goes here
return snippets, autosnippets
