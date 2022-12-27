local Hydra = require("hydra")
local mx = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
    end
end

local hint = [[
  ^ ^        Options Visual L
  ^
  _L_:    Operator visual
  _l_:    Exchange visual
  _k_:    Range visual
  ^
       ^^^^                _<Esc>_
]]

Hydra({
    name = "Options",
    hint = hint,
    config = {
        color = "amaranth",
        invoke_on_body = true,
        hint = {
            border = lambda.style.border.type_0,
            position = "middle-right",
        },
    },
    mode = { "x" },
    body = "<leader>L",
    heads = {
        {
            "L",
            function()
                require("substitute").visual()
            end,
            { nowait = true, exit = true, desc = "Operator visual" },
        },
        {
            "l",
            function()
                require("substitute.exchange").visual()
            end,
            { nowait = true, exit = true, desc = "Exchange visual" },
        },
        {
            "k",
            function()
                require("substitute.range").visual()
            end,
            { nowait = true, exit = true, desc = "Range visual" },
        },

        { "<Esc>", nil, { exit = true } },
    },
})
