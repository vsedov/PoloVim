local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.expand_conditions")

local saved_text = require("modules.completion.snippets.sniputils").saved_text
local else_clause = require("modules.completion.snippets.sniputils").else_clause

local function python_class_init(args, snip, old_state, placeholder)
    local nodes = {}

    if snip.captures[1] == "d" then
        table.insert(
            nodes,
            c(1, {
                t({ "" }),
                sn(nil, { t({ "\t" }), i(1, "attr") }),
            })
        )
    else
        table.insert(nodes, t({ "", "\tdef __init__(self" }))
        table.insert(
            nodes,
            c(1, {
                t({ "" }),
                sn(nil, { t({ ", " }), i(1, "arg") }),
            })
        )
        table.insert(nodes, t({ "):", "\t\t" }))
        table.insert(nodes, i(2, "pass"))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function python_dataclass(args, snip, old_state, placeholder)
    local nodes = {}

    table.insert(nodes, snip.captures[1] == "d" and t({ "@dataclass", "" }) or t({ "" }))

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local function generic_pdoc(ilevel, args)
    local nodes = { t({ "'''", string.rep("\t", ilevel) }) }
    nodes[#nodes + 1] = i(1, "Small Description.")
    nodes[#nodes + 1] = t({ "", "", string.rep("\t", ilevel) })
    nodes[#nodes + 1] = i(2, "Long Description")
    nodes[#nodes + 1] = t({ "", "", string.rep("\t", ilevel) .. "Args:" })

    local a = vim.tbl_map(function(item)
        local trimed = vim.trim(item)
        return trimed
    end, vim.split(args[1][1], ",", true))

    if args[1][1] == "" then
        a = {}
    end

    for idx, v in pairs(a) do
        nodes[#nodes + 1] = t({ "", string.rep("\t", ilevel + 1) .. v .. ": " })
        nodes[#nodes + 1] = i(idx + 2, "Description For " .. v)
    end

    return nodes, #a
end

local function pyfdoc(args, ostate)
    local nodes, a = generic_pdoc(1, args)
    nodes[#nodes + 1] = c(a + 2 + 1, { t(""), t({ "", "", "\tReturns:" }) })
    nodes[#nodes + 1] = i(a + 2 + 2)
    nodes[#nodes + 1] = c(a + 2 + 3, { t(""), t({ "", "", "\tRaises:" }) })
    nodes[#nodes + 1] = i(a + 2 + 4)
    nodes[#nodes + 1] = t({ "", "\t'''", "\t" })
    local snip = sn(nil, nodes)
    snip.old_state = ostate or {}
    return snip
end

local function pycdoc(args, ostate)
    local nodes, _ = generic_pdoc(2, args)
    nodes[#nodes + 1] = t({ "", "\t\t'''", "" })
    local snip = sn(nil, nodes)
    snip.old_state = ostate or {}
    return snip
end

local auto_snippets = {
    s(
        { trig = "(d?)cla", regTrig = true },
        fmt(
            [[
        {}class {}({}):
            {}
        ]],
            {
                d(1, python_dataclass, {}, {}),
                i(2, "Class"),
                c(3, {
                    t({ "" }),
                    i(1, "object"),
                }),
                -- dl(4, l._1 .. ': docstring', { 2 }),
                d(4, python_class_init, {}, {}),
            }
        )
    ),
    s(
        { trig = "fro(m ?)", regTrig = false },
        fmt([[from {} import {}]], {
            i(1, "sys"),
            i(2, "path"),
        })
    ),
    s(
        { trig = "if(e ?)", regTrig = true },
        fmt(
            [[
    if {}:
    {}{}
    ]],
            {
                i(1, "condition"),
                d(2, saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
                d(3, else_clause, {}, {}),
            }
        )
    ),
}
ls.add_snippets("python", auto_snippets, { type = "autosnippets" })

local M = {
    s({ trig = "cls", dscr = "Documented Class Structure" }, {
        t("class "),
        i(1, { "class_name" }),
        t("("),
        i(2, { "" }),
        t({ "):", "\t" }),
        t({ "def init(self," }),
        i(3),
        t({ "):", "\t\t" }),
        d(4, pycdoc, { 3 }, { 2 }),
        f(function(args)
            if not args[1][1] or args[1][1] == "" then
                return { "" }
            end
            local a = vim.tbl_map(function(item)
                local trimed = vim.trim(item)
                return "\t\tself." .. trimed .. " = " .. trimed
            end, vim.split(args[1][1], ",", true))
            return a
        end, {
            3,
        }),
        i(0),
    }),

    s({ trig = "fn", dscr = "Documented Function Structure" }, {
        t("def "),
        i(1, { "function" }),
        t("("),
        i(2),
        t({ "):", "\t" }),
        d(3, pyfdoc, { 2 }, { 1 }),
    }),
    s(
        "shebang",
        fmt(
            [[
#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# File Name: {}
    ]],
            {
                f(function()
                    return vim.fn.expand("%:p:t")
                end),
            }
        )
    ),

    s(
        "for",
        fmt(
            [[
    for {} in {}:
    {}
    ]],
            {
                i(1, "i"),
                i(2, "iterator"),
                d(3, saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
            }
        )
    ),

    s(
        "imp",
        fmt([[import {}]], {
            i(1, "sys"),
        })
    ),
    s(
        { trig = "fro(m?)", regTrig = true },
        fmt([[from {} import {}]], {
            i(1, "sys"),
            i(2, "path"),
        })
    ),

    s(
        "pr",
        fmt([[print({})]], {
            i(1, "msg"),
        })
    ),
    s(
        "ic",
        fmt([[ic({})]], {
            i(1, "msg"),
        })
    ),
    s(
        "ran",
        fmt([[range({}, {})]], {
            i(1, "0"),
            i(2, "10"),
        })
    ),
    s(
        "imp",
        fmt([[import {}]], {
            i(1, "sys"),
        })
    ),
    s(
        { trig = "def", dscr = "Advanced Def" },
        fmt(
            [[
    def {}({}{}):
    {}
    ]],
            {
                i(1, "name"),
                p(function()
            -- stylua: ignore
            local get_current_class = require('utils.treesitter_utils').get_current_class
            -- stylua: ignore
            local has_ts = require('utils.treesitter_utils').has_ts()
            -- stylua: ignore
            if has_ts and get_current_class() then
                -- stylua: ignore
                return 'self, '
            end
            -- stylua: ignore
            return ''
                end),
                i(2, "args"),
                d(3, saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
            }
        )
    ),

    s(
        "try",
        fmt(
            [[
    try:
    {}
    except {}:
        {}
    ]],
            {
                d(1, saved_text, {}, { user_args = { { text = "pass", indent = true } } }),
                c(2, {
                    t({ "Exception as e" }),
                    t({ "KeyboardInterrupt as e" }),
                    sn(nil, { i(1, "Exception") }),
                }),
                i(3, "pass"),
            }
        )
    ),

    s("ifmain", {
        t({ 'if __name__ == "__main__":', "\t" }),
        c(1, {
            sn(nil, { t({ "exit(" }), i(1, "main()"), t({ ")" }) }),
            t({ "pass" }),
        }),
        t({ "", "else:", "\t" }),
        i(2, "pass"),
    }),

    s("log", {
        t({ "logging" }),
        c(1, {
            t({ ".info(" }),
            t({ ".debug(" }),
            t({ ".warning(" }),
            t({ ".error(" }),
            t({ ".critical(" }),
        }),
        t({ "ic.format(" }),
        i(2, "info"),
        t({ "))" }),
    }),

    s("with", {
        t({ "with open(" }),
        i(1, "filename"),
        t({ ", " }),
        c(2, {
            i(1, '"r"'),
            i(1, '"a"'),
            i(1, '"w"'),
        }),
        t({ ") as " }),
        i(3, "data"),
        t({ ":", "" }),
        d(4, saved_text, {}, { text = "pass", indent = true }),
    }),
    s("w", {
        t({ "while " }),
        i(1, "True"),
        t({ ":", "" }),
        d(2, saved_text, {}, { text = "pass", indent = true }),
    }),

    s({ trig = "dcl", regTrig = true }, {
        d(1, python_dataclass, {}, {}),
        t({ "class " }),
        i(2, "Class"),
        t({ "(" }),
        c(3, {
            t({ "" }),
            i(1, "object"),
        }),
        t({ "):", '\t"""' }),
        dl(4, l._1 .. ": docstring", { 2 }),
        t({ '"""', "" }),
        d(5, python_class_init, {}, {}),
    }),
    -- snippet that calls pi.ask("question")
    s(
        { trig = "ask" },
        fmt([[   pi.ask("{}")]], {
            i(1, "How do i invert a binary tree?"),
        })
    ),
    -- # Find the functions you're looking for
    -- pi.search(pi, name='what')
    -- snippet for this
    s(
        { trig = "search" },
        fmt([[pi.search({}, name='{}')]], {
            i(1, "what"),
            i(2, "name"),
        })
    ),

    s(
        "raise",
        fmt([[raise {}({})]], {
            c(1, {
                i(1, "Exception"),
                i(1, "KeyboardInterrupt"),
                i(1, "IOException"),
            }),
            i(2, "message"),
        })
    ),
    s(
        "clist",
        fmt("[{} for {} in {}{}]", {
            r(1),
            i(1, "i"),
            i(2, "Iterator"),
            c(3, {
                t({ "" }),
                sn(nil, { t(" if "), i(1, "condition") }),
            }),
        })
    ),
    s(
        "cdict",
        fmt("{{ {}:{} for ({},{}) in {}{}}}", {
            r(1),
            r(2),
            i(1, "k"),
            i(2, "v"),
            i(3, "Iterator"),
            c(4, {
                t({ "" }),
                sn(nil, { t(" if "), i(1, "condition") }),
            }),
        })
    ),
}

return M
