local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node
-- local isn = ls.indent_snippet_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local types = require("luasnip.util.types")
-- local util = require("luasnip.util.util")
-- local l = require("luasnip.extras").lambda
-- local p = require("luasnip.extras").partial
-- local rep = require("luasnip.extras").rep
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local utils = require("modules.completion.snippets.sniputils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local is_math = utils.is_math
local not_math = utils.not_math
-- -- prevent loading twice .
require("modules.completion.snippets.luasnip")

local parse = ls.parser.parse_snippet

local gitcommmit_stylua = [[chore: autoformat with stylua]]

local public_string = [[
public String ${1:function_name}(${2:parameters}) {
  ${0}
}]]

local public_void = [[
public void ${1:function_name}(${2:parameters}) {
  ${0}
}]]

local gitcommit_fix = [[
fix(${1:scope}): ${2:title}

${0}]]

local gitcommit_cleanup = [[
cleanup(${1:scope}): ${2:title}

${0}]]
local gitcommit_revert = [[
revert: ${2:header of reverted commit}

This reverts commit ${0:<hash>}]]

local gitcommit_feat = [[
feat(${1:scope}): ${2:title}

${0}]]
local gitcommit_docs = [[
docs(${1:scope}): ${2:title}

${0}]]

local gitcommit_refactor = [[
refactor(${1:scope}): ${2:title}

${0}]]

local snippets = {
    all = require("modules.completion.snippets.all"),
    lua = require("modules.completion.snippets.lua"),
    python = require("modules.completion.snippets.python"),
    norg = require("modules.completion.snippets.norg_snip"),

    help = {
        s({ trig = "con", wordTrig = true }, {
            i(1),
            f(function(args)
                return { " " .. string.rep(".", 80 - (#args[1][1] + #args[2][1] + 2 + 2)) .. " " }
            end, { 1, 2 }),
            t({ "|" }),
            i(2),
            t({ "|" }),
            i(0),
        }),
    },
    java = {
        parse({ trig = "pus" }, public_string),
        parse({ trig = "puv" }, public_void),
        -- Very long example for a java class.
        s("fn", {
            d(6, utils.jdocsnip, { 2, 4, 5 }),
            t({ "", "" }),
            c(1, {
                t("public "),
                t("private "),
            }),
            c(2, {
                t("void"),
                t("char"),
                t("int"),
                t("double"),
                t("boolean"),
                t("float"),
                i(nil, ""),
            }),
            t(" "),
            i(3, "myFunc"),
            t("("),
            i(4),
            t(")"),
            c(5, {
                t(""),
                sn(nil, {
                    t({ "", " throws " }),
                    i(1),
                }),
            }),
            t({ " {", "\t" }),
            i(0),
            t({ "", "}" }),
        }),
    },
    cpp = {
        s("fn", {
            d(4, utils.cppdocsnip, { 1, 3, 3 }),
            t({ "", "" }),
            c(1, {
                t("void"),
                t("String"),
                t("char"),
                t("int"),
                t("double"),
                t("boolean"),
                i(nil, ""),
            }),
            t(" "),
            i(2, "myFunc"),
            t("("),
            i(3),
            t(")"),
            t({ " {", "\t" }),
            i(0),
            t({ "", "}" }),
        }),
    },
    c = {
        s("all fn", {
            -- Simple static text.
            t("//Parameters: "),
            -- function, first parameter is the function, second the Placeholders
            -- whose text it gets as input.
            f(require("modules.completion.snippets.sniputils").copy, 2),
            t({ "", "function " }),
            -- Placeholder/Insert.
            i(1),
            t("("),
            -- Placeholder with initial text.
            i(2, "int foo"),
            -- Linebreak
            t({ ") {", "\t" }),
            -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
            i(0),
            t({ "", "}" }),
        }),

        s("fn", {
            d(4, utils.cppdocsnip, { 1, 3, 3 }),
            t({ "", "" }),
            c(1, {
                t("void"),
                t("String"),
                t("char"),
                t("int"),
                t("double"),
                t("boolean"),
                i(nil, ""),
            }),
            t(" "),
            i(2, "myFunc"),
            t("("),
            i(3),
            t(")"),
            t({ " {", "\t" }),
            i(0),
            t({ "", "}" }),
        }),

        s("#if", {
            t("#if "),
            i(1, "1"),
            t({ "", "" }),
            i(0),
            t({ "", "#endif // " }),
            f(function(args)
                return args[1]
            end, 1),
        }),
    },
    gitcommit = {
        parse({ trig = "docs" }, gitcommit_docs),
        parse({ trig = "feat" }, gitcommit_feat),
        parse({ trig = "refactor" }, gitcommit_refactor),
        parse({ trig = "revert" }, gitcommit_revert),
        parse({ trig = "cleanup" }, gitcommit_cleanup),
        parse({ trig = "fix" }, gitcommit_fix),
        parse({ trig = "stylua" }, gitcommmit_stylua),
    },

    tex = {},
}

ls.add_snippets("all", snippets.all)
ls.add_snippets("lua", snippets.lua)
ls.add_snippets("python", snippets.python)
ls.add_snippets("norg", snippets.norg)
ls.add_snippets("help", snippets.help)
ls.add_snippets("java", snippets.java)
ls.add_snippets("cpp", snippets.cpp)
ls.add_snippets("c", snippets.c)
ls.add_snippets("gitcommit", snippets.gitcommit)

require("modules.completion.snippets.choice_popup")

for _, snip in ipairs(require("modules.completion.snippets.latex.tex")) do
    snip.condition = pipe({ is_math })
    snip.wordTrig = false
    ls.add_snippets("tex", { snip })
end
ls.add_snippets("tex", require("modules.completion.snippets.latex.tex_math"), { type = "autosnippets" })

-- HACK: For some reason you have to load it twice
require("luasnip/loaders/from_vscode").load({
    paths = { "~/.local/share/nvim/site/pack/packer/opt/friendly-snippets" },
})
