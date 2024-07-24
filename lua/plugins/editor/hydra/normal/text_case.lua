local hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

local current_word = function(key, operator_name, desc)
    return {
        key,
        function()
            require("textcase").current_word(operator_name)
        end,
        { desc = desc },
    }
end

local lsp_rename = function(key, operator_name, desc)
    return {
        key,
        function()
            require("textcase").lsp_rename(operator_name)
        end,
        { desc = desc },
    }
end

local operator = function(key, operator_name, desc)
    return {
        key,
        function()
            require("textcase").operator(operator_name)
        end,
        { desc = desc },
    }
end

local gaa_hint = [[
^ ^                   Current_word                   ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _u_: to upper case        _f_: to path case      ^ ^
^ ^ _l_: to lower case        _w_: to snake case     ^ ^
^ ^ _d_: to dash case         _c_: to camel case     ^ ^
^ ^ _n_: to constant case     _p_: to pascal case    ^ ^
^ ^ _._: to dot case          _t_: to title case     ^ ^
^ ^ _a_: to phrase case                              ^ ^
^ ^                                                  ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^                   Lsp_rename                     ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _U_: to upper case        _F_: to path case      ^ ^
^ ^ _L_: to lower case        _W_: to snake case     ^ ^
^ ^ _D_: to dash case         _C_: to camel case     ^ ^
^ ^ _N_: to constant case     _P_: to pascal case    ^ ^
^ ^ _>_: to dot case          _T_: to title case     ^ ^
^ ^ _A_: to phrase case                              ^ ^
^ ^                                                  ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^                             _<Esc>_: quit        ^ ^
]]
local gae_hint = [[
^ ^                   current_word                   ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _u_: to upper case        _f_: to path case      ^ ^
^ ^ _l_: to lower case        _w_: to snake case     ^ ^
^ ^ _d_: to dash case         _c_: to camel case     ^ ^
^ ^ _n_: to constant case     _p_: to pascal case    ^ ^
^ ^ _<_: to dot case          _t_: to title case     ^ ^
^ ^ _a_: to phrase case                              ^ ^
^ ^                                                  ^ ^
^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ e                           _<Esc>_: quit        ^ ^
]]

hydra({
    hint = gaa_hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
        },
    },
    name = "Change case",
    mode = "n",
    body = "<leader>ga",
    heads = {
        { "[", cmd("TextCaseOpenTelescope") },

        current_word("u", "to_upper_case", "to_upper_case"),
        current_word("l", "to_lower_case", "to_lower_case"),
        current_word("d", "to_dash_case", "to_dash_case"),
        current_word("n", "to_constant_case", "to_constant_case"),
        current_word(".", "to_dot_case", "to_dot_case"),
        current_word("a", "to_phrase_case", "to_phrase_case"),
        current_word("c", "to_camel_case", "to_camel_case"),
        current_word("p", "to_pascal_case", "to_pascal_case"),
        current_word("t", "to_title_case", "to_title_case"),
        current_word("f", "to_path_case", "to_path_case"),
        current_word("w", "to_snake_case", "to_snake_case"),

        lsp_rename("U", "to_upper_case", "to_upper_case"),
        lsp_rename("L", "to_lower_case", "to_lower_case"),
        lsp_rename("W", "to_snake_case", "to_snake_case"),
        lsp_rename("D", "to_dash_case", "to_dash_case"),
        lsp_rename("N", "to_constant_case", "to_constant_case"),
        lsp_rename(">", "to_dot_case", "to_dot_case"),
        lsp_rename("A", "to_phrase_case", "to_phrase_case"),
        lsp_rename("C", "to_camel_case", "to_camel_case"),
        lsp_rename("P", "to_pascal_case", "to_pascal_case"),
        lsp_rename("T", "to_title_case", "to_title_case"),
        lsp_rename("F", "to_path_case", "to_path_case"),

        { "<Esc>", nil, { exit = true } },
    },
})

hydra({
    hint = gae_hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
        },
    },
    name = "Change case",
    mode = "n",
    body = "<leader>ge",
    heads = {
        { "[", cmd("TextCaseOpenTelescope") },
        operator("u", "to_upper_case", "to_upper_case"),
        operator("l", "to_lower_case", "to_lower_case"),
        operator("d", "to_dash_case", "to_dash_case"),
        operator("n", "to_constant_case", "to_constant_case"),
        operator("<", "to_dot_case", "to_dot_case"),
        operator("a", "to_phrase_case", "to_phrase_case"),
        operator("c", "to_camel_case", "to_camel_case"),
        operator("p", "to_pascal_case", "to_pascal_case"),
        operator("t", "to_title_case", "to_title_case"),
        operator("f", "to_path_case", "to_path_case"),
        operator("w", "to_snake_case", "to_snake_case"),
        { "<Esc>", nil, { exit = true } },
    },
})
