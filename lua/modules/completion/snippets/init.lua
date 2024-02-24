local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local utils = require("modules.completion.snippets.sniputils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local is_math = utils.is_math
local not_math = utils.not_math

require("modules.completion.snippets.luasnip")

local parse = ls.parser.parse_snippet

local gitcommmit_stylua = [[chore: autoformat with stylua]]

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
        s(
            "cc",
            fmt("{type}({module}): {message}", {
                type = c(1, {
                    t("feat"),
                    t("fix"),
                    t("docs"),
                    t("style"),
                    t("refactor"),
                    t("perf"),
                    t("test"),
                    t("build"),
                    t("ci"),
                    t("chore"),
                    t("revert"),
                }),
                module = i(2, "module"),
                message = i(3, "message"),
            })
        ),
    },

    tex = {},
}
local exp_generator = function(get_bufnr_fn)
    return function(modifier)
        return f(function()
            local filename = vim.api.nvim_buf_get_name(get_bufnr_fn())

            return vim.fn.fnamemodify(filename, modifier)
        end)
    end
end
local insert_exp = exp_generator(function()
    return vim.api.nvim_get_current_buf()
end)
local fine_cmdline_exp = exp_generator(function()
    return require("vimrc.plugins.fine-cmdline").get_related_bufnr()
end)

ls.add_snippets("all", {
    s(
        "exp",
        c(1, {
            insert_exp(":t"),
            insert_exp(":t:r"),
            insert_exp(":p"),
            insert_exp(":h"),
        })
    ),
})
ls.add_snippets("fine-cmdline", {
    s(
        "exp",
        c(1, {
            fine_cmdline_exp(":t"),
            fine_cmdline_exp(":t:r"),
            fine_cmdline_exp(":p"),
            fine_cmdline_exp(":h"),
        })
    ),
})
ls.add_snippets("all", snippets.all)
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

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip.loaders.from_vscode").lazy_load()
 -- snipmate format
require("luasnip.loaders.from_snipmate").load()

-- lua format
require("luasnip.loaders.from_lua").load()
