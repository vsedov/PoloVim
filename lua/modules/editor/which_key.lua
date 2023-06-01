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
