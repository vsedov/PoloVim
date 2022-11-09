local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local hint = [[
_K_: prev diagnostic  _d_: type definition _a_: code action  _s_: symbols  _w_: references
_J_: next diagnostic  _r_: rename          _t_: trouble

]]

Hydra({
    name = "Diagnostic",
    hint = hint,
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    mode = { "n", "x" },
    body = "\\l",
    heads = {
        { "K", vim.diagnostic.goto_prev },
        { "J", vim.diagnostic.goto_next },

        { "d", vim.lsp.buf.type_definition, { exit = true } },
        { "r", cmd("Lspsaga rename"), { exit = true } },
        { "a", vim.lsp.buf.code_action, { exit = true } },
        { "t", cmd("TroubleToggle"), { exit = true } },
        { "s", cmd("SymbolsOutline"), { exit = true } },
        { "w", cmd("Telescope lsp_references"), { exit = true } },
        { "<Esc>", nil, { exit = true, desc = false } },
    },
})
