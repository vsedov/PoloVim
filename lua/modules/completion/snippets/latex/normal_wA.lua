local ls = require("luasnip")

local normal_wA = {
    ls.parser.parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${inline}} \\) $0"),
    ls.parser.parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${blockwise}}\n.\\] $0"),
}

return normal_wA
