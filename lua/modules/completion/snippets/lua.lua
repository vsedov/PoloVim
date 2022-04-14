local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local r = require("luasnip.extras").rep
local parse = ls.parser.parse_snippet

local saved_text = require("modules.completion.snippets.sniputils").saved_text
local else_clause = require("modules.completion.snippets.sniputils").else_clause
local surround_with_func = require("modules.completion.snippets.sniputils").surround_with_func

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
local function highlight_choice()
    return sn(nil, {
        t({ "" }),
        c(1, {
            t({ "" }),
            sn(nil, {
                c(1, {
                    sn(nil, { t({ "fg=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "bg=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "sp=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "italic=true," }), i(1) }),
                    sn(nil, { t({ "bold=true," }), i(1) }),
                    sn(nil, { t({ "underline=true," }), i(1) }),
                    sn(nil, { t({ "undercurl=true," }), i(1) }),
                }),
                d(2, highlight_choice, {}),
            }),
        }),
    })
end

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

local function rec_val()
    return sn(nil, {
        c(1, {
            t({ "" }),
            sn(nil, {
                t({ ",", "\t" }),
                i(1, "arg"),
                t({ " = { " }),
                r(1),
                t({ ", " }),
                c(2, {
                    i(1, "'string'"),
                    i(1, "'table'"),
                    i(1, "'function'"),
                    i(1, "'number'"),
                    i(1, "'boolean'"),
                }),
                c(3, {
                    t({ "" }),
                    t({ ", true" }),
                }),
                t({ " }" }),
                d(4, rec_val, {}),
            }),
        }),
    })
end

local function require_import(_, parent, old_state)
    local nodes = {}

    local variable = parent.captures[1] == "l"
    local call_func = parent.captures[2] == "f"

    if variable then
        table.insert(nodes, t({ "local " }))
        if call_func then
            table.insert(nodes, r(2))
        else
            table.insert(
                nodes,
                f(function(module)
                    local name = vim.split(module[1][1], ".", true)
                    if name[#name] and name[#name] ~= "" then
                        return name[#name]
                    elseif #name - 1 > 0 and name[#name - 1] ~= "" then
                        return name[#name - 1]
                    end
                    return name[1] or "module"
                end, { 1 })
            )
        end
        table.insert(nodes, t({ " = " }))
    end

    table.insert(nodes, t({ "require" }))

    if call_func then
        table.insert(nodes, t({ "('" }))
        table.insert(nodes, i(1, "module"))
        table.insert(nodes, t({ "')." }))
        table.insert(nodes, i(2, "func"))
    else
        table.insert(nodes, t({ " '" }))
        table.insert(nodes, i(1, "module"))
        table.insert(nodes, t({ "'" }))
    end

    local snip_node = sn(nil, nodes)
    snip_node.old_state = old_state
    return snip_node
end

local auto_snippets = {
    s(
        { trig = "l(l?)fun", regTrig = true },
        fmt(
            [[
        {}function {}({})
        {}
        end
        ]],
            {
                f(function(_, snip)
                -- stylua: ignore
                return snip.captures[1] == 'l' and 'local ' or ''
                end, {}),
                i(1, "name"),
                i(2, "args"),
                d(3, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),

    s({ trig = "if(e?)", regTrig = true }, {
        t({ "if " }),
        i(1, "condition"),
        t({ " then", "" }),
        d(2, saved_text, {}, { user_args = { { indent = true } } }),
        d(3, else_clause, {}, {}),
        t({ "", "end" }),
    }),
    s({ trig = "l(l?)req(f?)", regTrig = true }, {
        d(1, require_import, {}, {}),
    }),
    s(
        { trig = "(n?)eq", regTrig = true },
        fmt([[assert.{}({}, {})]], {
            f(function(_, snip)
            -- stylua: ignore
            if snip.captures[1] == 'n' then
                -- stylua: ignore
                return 'are_not.same('
            end
            -- stylua: ignore
            return 'are.same('
            end, {}),
            i(1, "expected"),
            i(2, "result"),
        })
    ),
    s(
        { trig = "is(_?)true", regTrig = true },
        fmt([[assert.is_true({})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "true" } } }),
        })
    ),
    s(
        { trig = "is(_?)false", regTrig = true },
        fmt([[assert.is_false({})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "false" } } }),
        })
    ),
}
ls.add_snippets("lua", auto_snippets, { type = "autosnippets" })

vim.api.nvim_set_hl(0, "lasjdf", { sp = "#FF0000", bold = true })
local lua = {

    parse({ trig = "time" }, time),
    parse({ trig = "M" }, module_snippet),
    parse({ trig = "lf" }, loc_func),
    parse({ trig = "cmd" }, map_cmd),
    parse({ trig = "inspect" }, inspect_snippet),

    parse("lf", "-- Defined in $TM_FILE\nlocal $1 = function($2)\n\t$0\nend"),
    parse("mf", "-- Defined in $TM_FILE\nlocal $1.$2 = function($3)\n\t$0\nend"),

    s(
        "for",
        fmt(
            [[
    for {}, {} in ipairs({}) do
    {}
    end
    ]],
            {
                i(1, "k"),
                i(2, "v"),
                i(3, "tbl"),
                d(4, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),
    s(
        "forp",
        fmt(
            [[
    for {}, {} in pairs({}) do
    {}
    end
    ]],
            {
                i(1, "k"),
                i(2, "v"),
                i(3, "tbl"),
                d(4, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),
    s(
        "fori",
        fmt(
            [[
    for {} = {}, {} do
    {}
    end
    ]],
            {
                i(1, "idx"),
                i(2, "0"),
                i(3, "10"),
                d(4, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),

    s(
        "w",
        fmt(
            [[
    while {} do
    {}
    end
    ]],
            {
                i(1, "true"),
                d(2, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),
    s(
        "elif",
        fmt(
            [[
    elseif {} then
    {}
    ]],
            {
                i(1, "condition"),
                d(2, saved_text, {}, { user_args = { { indent = true } } }),
            }
        )
    ),

    s(
        "l",
        fmt([[local {} = {}]], {
            i(1, "var"),
            i(2, "{}"),
        })
    ),
    s("ign", { t({ "-- stylua: ignore" }) }),
    s("sty", { t({ "-- stylua: ignore" }) }),

    -- ["n|gD"] = map_cmd("<cmd>lua vim.lsp.buf.declaration()<CR>"):with_noremap():with_silent(),
    -- making a snuippet for this
    -- map_cmd should be choice snippets
    s(
        "map_",
        fmt([[ ["{}|{}"] = {}({}):{}(), ]], {
            c(1, {
                t({ "n" }),
                t({ "i" }),
                t({ "x" }),
                t({ "o" }),
            }),
            i(2, "key"),
            c(3, {
                t({ "map_cmd" }),
                t({ "map_cr" }),
                t({ "map_cu" }),
                t({ "map_args" }),
                t({ "map_key" }),
            }),
            i(4, "cmd"),

            c(5, {
                t({ "with_noremap" }),
                t({ "with_silent" }),
                t({ "with_expr" }),
            }),
        })
    ),

    s("map", {
        t({ "vim.keymap.set(" }),
        t({ "'" }),
        i(1, "n"),
        t({ "', " }),
        t({ "\t'" }),
        i(2, "LHS"),
        t({ "', " }),
        t({ "\t'" }),
        i(3, "RHS"),
        t({ "', " }),
        t({ "\t{" }),
        -- todo make this a table option
        c(4, {
            i(1, "noremap = true"),
            i(1, "silent = true"),
            i(1, "expr = true"),
            i(1, "noremap = true, silent = true"),
            i(1, "noremap = true, silent = false"),
            i(1, "noremap = true, silent = true, expr = true"),
        }),
        t({ "}" }),
        t({ ")" }),
    }),
    s("val", {
        t({ "vim.validate {" }),
        t({ "", "\t" }),
        i(1, "arg"),
        t({ " = { " }),
        r(1),
        t({ ", " }),
        c(2, {
            i(1, "'string'"),
            i(1, "'table'"),
            i(1, "'function'"),
            i(1, "'number'"),
            i(1, "'boolean'"),
        }),
        c(3, {
            t({ "" }),
            t({ ", true" }),
        }),
        t({ " }" }),
        d(4, rec_val, {}),
        t({ "", "}" }),
    }),
    s(
        "lext",
        fmt([[vim.list_extend({}, {})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "tbl" } } }),
            i(2, "'node'"),
        })
    ),
    s(
        "text",
        fmt([[vim.tbl_extend('{}', {}, {})]], {
            c(1, {
                t({ "force" }),
                t({ "keep" }),
                t({ "error" }),
            }),
            d(2, surround_with_func, {}, { user_args = { { text = "tbl" } } }),
            i(3, "'node'"),
        })
    ),
    s(
        "not",
        fmt([[vim.notify("{}", "{}"{})]], {
            d(1, surround_with_func, {}, { user_args = { { text = "msg" } } }),
            c(2, {
                t({ "INFO" }),
                t({ "WARN" }),
                t({ "ERROR" }),
                t({ "DEBUG" }),
            }),
            c(3, {
                t({ "" }),
                sn(nil, { t({ ", { title = " }), i(1, "'title'"), t({ " }" }) }),
            }),
        })
    ),
    s(
        "desc",
        fmt(
            [[
    describe('{}', funcion()
        it('{}', funcion()
            {}
        end)
    end)
    ]],
            {
                i(1, "DESCRIPTION"),
                i(2, "DESCRIPTION"),
                i(3, "-- test"),
            }
        )
    ),
    s(
        "it",
        fmt(
            [[
    it('{}', funcion()
        {}
    end)
    ]],
            {
                i(1, "DESCRIPTION"),
                i(2, "-- test"),
            }
        )
    ),

    s(
        "haserr",
        fmt([[assert.has.error(function() {} end{})]], {
            i(1, "error()"),
            c(2, {
                t({ "" }),
                sn(nil, { t({ ", '" }), i(1, "error"), t({ "'" }) }),
            }),
        })
    ),

    s(
        "pr",
        fmt([[print({})]], {
            i(1, "msg"),
        })
    ),
    s(
        "istruthy",
        fmt([[assert.is_truthy({})]], { d(1, surround_with_func, {}, { user_args = { { text = "true" } } }) })
    ),
    s(
        "isfalsy",
        fmt([[assert.is_falsy({})]], { d(1, surround_with_func, {}, { user_args = { { text = "false" } } }) })
    ),
    s("truthy", fmt([[assert.is_truthy({})]], { d(1, surround_with_func, {}, { user_args = { { text = "true" } } }) })),
    s("falsy", fmt([[assert.is_falsy({})]], { d(1, surround_with_func, {}, { user_args = { { text = "false" } } }) })),

    -- local _ = require "telescope.pickers.builtin"
    s("high", {
        t({ 'vim.api.nvim_set_hl(0,"' }),
        i(1, "group-name"),
        t({ '",{' }),
        d(2, highlight_choice, {}),
        t({ "})" }),
        i(0),
    }),
    s("lreq", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })), -- to lreq, bind parse the list
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
    s("lt", {
        t("Log:trace("),
        i(0),
        t(")"),
    }),

    s("lti", {
        t("Log:trace(vim.inspect("),
        i(0),
        t("))"),
    }),

    s("ld", {
        t("Log:debug("),
        i(0),
        t(")"),
    }),

    s("ldi", {
        t("Log:debug(vim.inspect("),
        i(0),
        t("))"),
    }),
    s("li", {
        t("Log:info("),
        i(0),
        t(")"),
    }),

    s("lii", {
        t("Log:info(vim.inspect("),
        i(0),
        t("))"),
    }),
    s("lw", {
        t("Log:warn("),
        i(0),
        t(")"),
    }),
    s("lwi", {
        t("Log:warn(vim.inspect("),
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

                for _, val in pairs(valid) do
                    -- if val is file_dir
                    if file_dir == val then
                        return s("", { t(val) })
                    end
                end

                local options = {}
                for len = 0, #valid - 1 do
                    table.insert(options, t(valid[len + 1]))
                end
                return sn(nil, {
                    c(1, options),
                })
            end),
            d(2, function()
                -- Get the author and URL in the clipboard and auto populate the author and project
                local default = s("", { i(1, "author"), t("/"), t(2, "plugin") })
                local clip = vim.fn.getreg("*") or vim.fn.getreg("+")
                if not vim.startswith(clip, "https://github.com/") then
                    return default
                end
                local parts = vim.split(clip, "/")
                if #parts < 2 then
                    return default
                end
                local author, project = parts[#parts - 1], parts[#parts]
                local project_name = vim.split(project, ".", true)[1] -- remove .lua
                return s("", {
                    t({
                        "'" .. author .. "/" .. project .. "']={",
                    }),
                    t({ "", "" }),
                    t("    opt = true,"),
                    t({ "", "" }),
                    t("    config = function()"),
                    t({ "", "" }),
                    t("        "),
                    c(1, {
                        fmt([[require("{}").setup({})]], {
                            i(1, project_name),
                            d(2, function()
                                return sn(nil, {
                                    t("{"),
                                    i(1, ""),
                                    t("}"),
                                })
                            end),
                        }),
                        fmt([[require("{}").setup({})]], {

                            d(1, function()
                                return s("", { t(project_name) })
                            end),

                            d(2, function()
                                return s("", { t("{"), i(1, "module"), t("}") })
                            end),
                        }),
                    }),

                    t({ "", "" }),
                    t("    end,"),
                    t({ "", "" }),
                    t("}"),
                })
            end),
        })
    ),
}

return lua
