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

local parse = ls.parser.parse_snippet
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

local lua = {
    parse({ trig = "high" }, high),
    parse({ trig = "time" }, time),
    parse({ trig = "M" }, module_snippet),
    parse({ trig = "lf" }, loc_func),
    parse({ trig = "cmd" }, map_cmd),
    parse({ trig = "inspect" }, inspect_snippet),

    parse("lf", "-- Defined in $TM_FILE\nlocal $1 = function($2)\n\t$0\nend"),
    parse("mf", "-- Defined in $TM_FILE\nlocal $1.$2 = function($3)\n\t$0\nend"),
    s("lreq", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })), -- to lreq, bind parse the list

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
        t("log:trace("),
        i(0),
        t(")"),
    }),

    s("lti", {
        t("log:trace(vim.inspect("),
        i(0),
        t("))"),
    }),

    s("ld", {
        t("log:debug("),
        i(0),
        t(")"),
    }),

    s("ldi", {
        t("log:debug(vim.inspect("),
        i(0),
        t("))"),
    }),
    s("li", {
        t("log:info("),
        i(0),
        t(")"),
    }),

    s("lii", {
        t("log:info(vim.inspect("),
        i(0),
        t("))"),
    }),
    s("lw", {
        t("log:warn("),
        i(0),
        t(")"),
    }),
    s("lwi", {
        t("log:warn(vim.inspect("),
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
