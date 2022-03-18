local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local bwA = {
    s({ trig = "bigfun", name = "Big function" }, {
        t({ "\\begin{align*}", "\t" }),
        i(1),
        t(":"),
        t(" "),
        i(2),
        t("&\\longrightarrow "),
        i(3),
        t({ " \\", "\t" }),
        i(4),
        t("&\\longmapsto "),
        i(1),
        t("("),
        i(4),
        t(")"),
        t(" = "),
        i(0),
        t({ "", ".\\end{align*}" }),
    }),
}

return bwA
