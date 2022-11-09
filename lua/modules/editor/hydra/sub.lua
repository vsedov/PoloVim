local Hydra = require("hydra")
local mx = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
    end
end

local hint = [[
  ^ ^        Options Normal L
  ^
  _L_:    Operator Sub
  _l_:    Line Sub
  _o_:    EOL Sub
  _k_:    Range word
  _K_:    Range Line Sub
  _e_:    Exchange Operator
  _E_:    Exchange Line
  _C_:    Cancel operation
  _;_:    In word = Para

  _s_:    Replace word cursor
  _S_:    Replace word Line
  _w_:    Replace word 

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
    mode = { "n" },
    body = "L",
    heads = {
        {
            "L",
            function()
                require("substitute").operator()
            end,
            { nowait = true, desc = "Operator Sub", exit = true },
        },
        {
            "l",
            function()
                require("substitute").line()
            end,
            { nowait = true, desc = "Operator line", exit = true },
        },
        {
            "o",
            function()
                require("substitute").eol()
            end,
            { nowait = true, desc = "Operator eol", exit = true },
        },
        {
            "K",
            function()
                require("substitute.range").operator({ motion1 = "iW" })
            end,
            { nowait = true, desc = "range Sub", exit = true },
        },
        {
            "k",
            function()
                require("substitute.range").word()
            end,
            { nowait = true, desc = "range word", exit = true },
        },
        {
            ";",
            function()
                require("substitute.range").operator({ motion1 = "iw", motion2 = "ap" })
            end,
            { nowait = true, desc = "range word", exit = true },
        },
        {
            "e",
            function()
                require("substitute.exchange").operator()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },
        {
            "E",
            function()
                require("substitute.exchange").word()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },
        {
            "C",
            function()
                require("substitute.exchange").cancel()
            end,
            { desc = "Exchange Sub", nowait = true, exit = true },
        },

        {
            "s",
            mx("<leader><leader>Sr"),
            { desc = "Replace word under cursor", nowait = true, exit = true },
        },
        {
            "S",
            mx("<leader><leader>Sl"),
            { desc = "Replace word under cursor on Line", nowait = true, exit = true },
        },
        {
            "w",
            mx("<leader><leader>Sc"),
            { desc = "replace current", nowait = true, exit = true },
        },

        { "<Esc>", nil, { exit = true } },
    },
})

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
    body = "L",
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
