lambda.highlight.plugin("whichkey", {
    theme = {
        ["*"] = { { WhichkeyFloat = { link = "NormalFloat" } } },
        horizon = { { WhichKeySeparator = { link = "Todo" } } },
    },
})

local wk = require("which-key")
wk.setup({
    plugins = { spelling = { enabled = true } },
    window = { border = lambda.style.border.type_0 },
    layout = { align = "center" },
})

wk.register({
    ["i"] = {
        name = "inner textobject",
        rw = "inner word",
        rW = "inner WORD",
        rp = "inner paragraph",
        ["r["] = 'inner [] from "[" to the matching "]"',
        ["r]"] = "same as i[",
        ["r("] = "same as ib",
        ["r)"] = "same as ib",
        ["rb"] = "inner block from [( to )]",
        ["r>"] = "same as i<",
        ["r<"] = 'inner <> from "<" to the matching ">"',
        ["rt"] = "inner tag block",
        ["r{"] = "same as iB",
        ["r}"] = "same as iB",
        ["rB"] = "inner Block from [{ to }]",
        ['r"'] = "double quoted string without the quotes",
        ["r'"] = "single quoted string without the quotes",
        ["r`"] = "string in backticks without the backticks",
    },
    ["a"] = {
        name = "Around... textobject",
        rw = "inner word",
        rW = "inner WORD",
        rp = "inner paragraph",
        ["r["] = 'inner [] from "[" to the matching "]"',
        ["r]"] = "same as i[",
        ["r("] = "same as ib",
        ["r)"] = "same as ib",
        ["rb"] = "inner block from [( to )]",
        ["r>"] = "same as i<",
        ["r<"] = 'inner <> from "<" to the matching ">"',
        ["rt"] = "inner tag block",
        ["r{"] = "same as iB",
        ["r}"] = "same as iB",
        ["rB"] = "inner Block from [{ to }]",
        ['r"'] = "double quoted string without the quotes",
        ["r'"] = "single quoted string without the quotes",
        ["r`"] = "string in backticks without the backticks",
    },
}, { mode = "o" })
