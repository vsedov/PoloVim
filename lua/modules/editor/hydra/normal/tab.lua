local Hydra = require("hydra")

local cmd = require("hydra.keymap-util").cmd

local hint = [[
 Tabpage
   
       Create    ^^^    Close   ^^    Goto      Move
 ----------------^^^ -----------^^ ----------- -------
 _n_: new             _c_: close    _]_: next  _>_: next
 _s_: split current   _o_: others   _[_: prev  _<_: prev
 ^ ^  into a new tab           ^   _\^_: first
                            ^^^^    _$_: last
 _<Esc>_: quit

]]

Hydra({
    name = "Tabpage",
    hint = hint,
    config = {
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            float_opts = {
                border = lambda.style.border.type_0,
                style = "minimal",
                focusable = true,
                noautocmd = true,
            },
        },
        color = "pink",
    },
    mode = "n",
    on_enter = function()
        vim.bo.modifiable = false
    end,
    body = ";<tab>",

    heads = {
        { "n", cmd("tabnew"), { nowait = true } },
        { "s", cmd("tab split"), { nowait = true } },
        { "c", cmd("tabclose"), { nowait = true } },
        { "o", cmd("tabonly"), { exit = true } },
        { "]", cmd("tabnext"), { nowait = true } },
        { "[", cmd("tabprevious"), { nowait = true } },
        { ">", cmd("tabmove +1"), { nowait = true } },
        { "<", cmd("tabmove -1"), { nowait = true } },
        { "$", cmd("tablast"), { nowait = true } },
        { "^", cmd("tabfirst"), { nowait = true } },
        { "<Esc>", nil, { exit = true } },
    },
})
