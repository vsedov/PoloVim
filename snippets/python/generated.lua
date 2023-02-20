local api = vim.api
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local i = ls.insert_node

local snippets = {
    s(
        "pr",
        fmt([[print({})]], {
            i(1, "msg"),
        })
    ),
    ------------------------------------------------------ Snippets goes here
}

local autosnippets = {}

-- Snippets goes here
return snippets, autosnippets
