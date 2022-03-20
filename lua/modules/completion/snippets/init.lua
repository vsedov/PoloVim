local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local isn = ls.indent_snippet_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local types = require("luasnip.util.types")
local util = require("luasnip.util.util")
local l = require("luasnip.extras").lambda
local p = require("luasnip.extras").partial
local rep = require("luasnip.extras").rep
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")

local utils = require("modules.completion.snippets.sniputils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local is_math = utils.is_math
local not_math = utils.not_math
-- -- prevent loading twice .
-- require("luasnip/loaders/from_vscode").lazy_load()
require("modules.completion.snippets.luasnip")

local parse = ls.parser.parse_snippet

local gitcommmit_stylua = [[chore: autoformat with stylua]]

local time = [[
local start = os.clock()
print(os.clock()-start.."s")
]]

local high = [[
${1:HighlightGroup} = { fg = "${2}", bg = "${3}" },${0}]]

local module_snippet = [[
local ${1:M} = {}
${0}
return $1]]

local loc_func = [[
local function ${1:name}(${2})
    ${0}
end
]]

local inspect_snippet = [[
print("${1:variable}:")
dump($1)]]

local map_cmd = [[<cmd>${0}<CR>]]

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

local require_var = function(args, _)
    local text = args[1][1] or ""
    local split = vim.split(text, ".", { plain = true })

    local options = {}
    for len = 0, #split - 1 do
        table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
    end

    return sn(nil, {

        c(1, options),
    })
end

ls.snippets = {
    all = {
        s({ trig = "date1" }, {
            f(function()
                return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date())
            end, {}),
        }),

        s({ trig = "Ctime" }, {
            f(function()
                return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date("%H:%M"))
            end, {}),
        }),

        s(
            "trig",
            c(1, {
                t("Ugh boring, a text node"),
                i(nil, "At least I can edit something now..."),
                f(function(args)
                    return "Still only counts as text!!"
                end, {}),
            })
        ),
    },
    lua = {
        parse({ trig = "high" }, high),
        parse({ trig = "time" }, time),
        parse({ trig = "M" }, module_snippet),
        parse({ trig = "lf" }, loc_func),
        parse({ trig = "cmd" }, map_cmd),
        parse({ trig = "inspect" }, inspect_snippet),

        -- local _ = require "telescope.pickers.builtin"
        s(
            "req",
            fmt([[local {} = require "{}"]], {
                f(function(import_name)
                    local parts = vim.split(import_name[1][1], ".", true)
                    return parts[#parts] or ""
                end, { 1 }),
                i(1),
            })
        ),

        s(
            "treq",
            fmt([[local {} = require("telescope.{}")]], {
                d(2, require_var, { 1 }),
                i(1),
            })
        ),

        s("snippet_node", {
            t('s("'),
            i(1, "snippet_title"),
            t({ '", {', "\t" }),
            i(0, "snippet_body"),
            t({ "", "})," }),
        }),

        s("function_node", {
            t("f("),
            i(1, "fn"),
            t(", "),
            i(2, "{}"),
            t(", "),
            i(3, "arg??"),
            t("), "),
        }),

        ls.parser.parse_snippet("lf", "-- Defined in $TM_FILE\nlocal $1 = function($2)\n\t$0\nend"),
        ls.parser.parse_snippet("mf", "-- Defined in $TM_FILE\nlocal $1.$2 = function($3)\n\t$0\nend"),
        s("lreq", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })), -- to lreq, bind parse the list

        s("lua print var", {
            t('print("'),
            i(1, "desrc"),
            t(': " .. '),
            i(2, "the_variable"),
            t(")"),
        }),

        s("fn basic", {
            t("-- @param: "),
            f(require("modules.completion.snippets.sniputils").copy, 2),
            t({ "", "local " }),
            i(1),
            t(" = function("),
            i(2, "fn param"),
            t({ ")", "\t" }),
            i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
            t({ "", "end" }),
        }),

        s("fn module", {
            -- make new line into snippet
            t("-- @param: "),
            f(require("modules.completion.snippets.sniputils").copy, 3),
            t({ "", "" }),
            i(1, "modname"),
            t("."),
            i(2, "fnname"),
            t(" = function("),
            i(3, "fn param"),
            t({ ")", "\t" }),
            i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
            t({ "", "end" }),
        }),

        s({ trig = "if basic", wordTrig = true }, {
            t({ "if " }),
            i(1),
            t({ " then", "\t" }),
            i(0),
            t({ "", "end" }),
        }),

        s({ trig = "ee", wordTrig = true }, {
            t({ "else", "\t" }),
            i(0),
        }),

        -- LOOPS ----------------------------------------

        s("for", {
            t("for "),
            c(1, {
                sn(nil, {
                    i(1, "k"),
                    t(", "),
                    i(2, "v"),
                    t(" in "),
                    c(3, { t("pairs"), t("ipairs") }),
                    t("("),
                    i(4),
                    t(")"),
                }),
                sn(nil, { i(1, "i"), t(" = "), i(2), t(", "), i(3) }),
            }),
            t({ " do", "\t" }),
            i(0),
            t({ "", "end" }),
        }),

        s("super", {
            i(1, "ClassName"),
            t(".super."),
            i(2, "method"),
            t("(self"),
            i(0),
            t(")"),
        }),

        s("s.", {
            t("self."),
            i(1, "thing"),
            t(" = "),
            i(2),
            i(0),
        }),

        s("ld", {
            t("log.debug("),
            i(0),
            t(")"),
        }),

        s("ldi", {
            t("log.debug(inspect("),
            i(0),
            t("))"),
        }),

        s("inc", {
            i(1, "thing"),
            t(" = "),
            f(function(args)
                return args[1][1]
            end, 1),
            t(" + "),
            i(2, "1"),
            i(0),
        }),

        s("dec", {
            i(1, "thing"),
            t(" = "),
            f(function(args)
                return args[1][1]
            end, 1),
            t(" - "),
            i(2, "1"),
            i(0),
        }),
        s(
            {
                trig = "use",
                name = "packer use",
                dscr = {
                    "packer use plugin block",
                    "e.g.",
                    "use {'author/plugin'}",
                },
            },
            -- = {
            fmt([[{}[{}]], {
                d(1, function()
                    local valid = {
                        "completion",
                        "editor",
                        "lang",
                        "tools",
                        "ui",
                        "useless",
                        "user",
                    }

                    -- get last dir name so completoin/snippets/init.lua would return snippets
                    local parts = vim.split(vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h"), "/", true)
                    local file_dir = parts[#parts]

                    -- check if file_dir is same as values in valid
                    for _, val in pairs(valid) do
                        -- if val is file_dir
                        if file_dir == val then
                            return s("", { t(val) })
                        end
                    end

                    -- default option if the above fails
                    return s("", {
                        c(1, {
                            t("completion"),
                            t("editor"),
                            t("lang"),
                            t("tools"),
                            t("ui"),
                            t("usless"),
                            t("user"),
                        }),
                    })
                end),
                d(2, function()
                    -- Get the author and URL in the clipboard and auto populate the author and project
                    local default = s("", { i(1, "author"), t("/"), t(2, "plugin") })
                    local clip = vim.fn.getreg("*")
                    if not vim.startswith(clip, "https://github.com/") then
                        return default
                    end
                    local parts = vim.split(clip, "/")
                    if #parts < 2 then
                        return default
                    end
                    local author, project = parts[#parts - 1], parts[#parts]
                    return s("", {
                        t({
                            "'" .. author .. "/" .. project .. "']={",
                        }),
                        t({ "", "" }),
                        t("    opt = true,"),
                        t({ "", "" }),
                        t("    config = function()"),
                        t({ "", "" }),
                        t("        require("),
                        i(1, "module"),
                        t(")"),
                        t({ "", "" }),
                        t("    end,"),
                        t({ "", "" }),
                        t("}"),
                    })
                end),
            })
        ),
    },
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

        s("class", {
            -- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
            c(1, {
                t("public "),
                t("private "),
            }),
            t("class "),
            i(2),
            t(" "),
            c(3, {
                t("{"),
                -- sn: Nested Snippet. Instead of a trigger, it has a position, just like insert-nodes. !!! These don't expect a 0-node!!!!
                -- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
                sn(nil, {
                    t("extends "),
                    i(1),
                    t(" {"),
                }),
                sn(nil, {
                    t("implements "),
                    i(1),
                    t(" {"),
                }),
            }),
            t({ "", "\t" }),
            i(0),
            t({ "", "}" }),
        }),

        s({ trig = "fn" }, {
            d(6, utils.jdocsnip, { 2, 4, 5 }),
            t({ "", "" }),
            c(1, {
                t({ "public " }),
                t({ "private " }),
            }),
            c(2, {
                t({ "void" }),
                i(nil, { "" }),
                t({ "String" }),
                t({ "char" }),
                t({ "int" }),
                t({ "double" }),
                t({ "boolean" }),
            }),
            t({ " " }),
            i(3, { "myFunc" }),
            t({ "(" }),
            i(4),
            t({ ")" }),
            c(5, {
                t({ "" }),
                sn(nil, {
                    t({ "", " throws " }),
                    i(1),
                }),
            }),
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
for _, snip in ipairs(require("modules.completion.snippets.latex.math_i")) do
    snip.condition = pipe({ is_math })
    snip.wordTrig = false
    table.insert(ls.snippets.tex, snip)
end
require("modules.completion.snippets.choice_popup")

for _, snip in ipairs(require("modules.completion.snippets.latex.tex")) do
    snip.condition = pipe({ is_math })
    snip.wordTrig = false
    table.insert(ls.snippets.tex, snip)
end
ls.autosnippets = {
    tex = {},
}

for _, snip in ipairs(require("modules.completion.snippets.latex.tex_math")) do
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.math_wRA_no_backslash")) do
    snip.regTrig = true
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.math_rA_no_backslash")) do
    snip.wordTrig = false
    snip.regTrig = true
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.normal_wA")) do
    snip.condition = pipe({ not_math })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.math_wrA")) do
    snip.regTrig = true
    snip.condition = pipe({ is_math })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.math_wA_no_backslash")) do
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.math_iA")) do
    snip.wordTrig = false
    snip.condition = pipe({ is_math, no_backslash })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex./math_bwA")) do
    snip.condition = pipe({ conds.line_begin, is_math })
    table.insert(ls.autosnippets.tex, snip)
end

for _, snip in ipairs(require("modules.completion.snippets.latex.bwA")) do
    snip.condition = pipe({ conds.line_begin, not_math })
    table.insert(ls.autosnippets.tex, snip)
end

-- require("modules.completion.snippets.latex.tex_math")

require("luasnip/loaders/from_vscode").lazy_load({
    paths = { "~/.local/share/nvim/site/pack/packer/opt/friendly-snippets" },
})
