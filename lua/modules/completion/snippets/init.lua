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

-- prevent loading twice .
require("luasnip/loaders/from_vscode").load()
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

local function jdocsnip(args, _, old_state)
    -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
    -- Using a restoreNode instead is much easier.
    -- View this only as an example on how old_state functions.
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short Description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(nodes, { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) })
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(nodes, { t({ " * ", " * @return " }), inode, t({ "", "" }) })
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(nodes, { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) })
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
end

-- complicated function for dynamicNode.
local function cppdocsnip(args, _, old_state)
    dump(args)
    -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
    -- Using a restoreNode instead is much easier.
    -- View this only as an example on how old_state functions.
    local nodes = {
        t({ "/**", " * " }),
        i(1, "A short Description"),
        t({ "", "" }),
    }

    -- These will be merged with the snippet; that way, should the snippet be updated,
    -- some user input eg. text can be referred to in the new snippet.
    local param_nodes = {}

    if old_state then
        nodes[2] = i(1, old_state.descr:get_text())
    end
    param_nodes.descr = nodes[2]

    -- At least one param.
    if string.find(args[2][1], ", ") then
        vim.list_extend(nodes, { t({ " * ", "" }) })
    end

    local insert = 2
    for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
        -- Get actual name parameter.
        arg = vim.split(arg, " ", true)[2]
        if arg then
            local inode
            -- if there was some text in this parameter, use it as static_text for this new snippet.
            if old_state and old_state[arg] then
                inode = i(insert, old_state["arg" .. arg]:get_text())
            else
                inode = i(insert)
            end
            vim.list_extend(nodes, { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) })
            param_nodes["arg" .. arg] = inode

            insert = insert + 1
        end
    end

    if args[1][1] ~= "void" then
        local inode
        if old_state and old_state.ret then
            inode = i(insert, old_state.ret:get_text())
        else
            inode = i(insert)
        end

        vim.list_extend(nodes, { t({ " * ", " * @return " }), inode, t({ "", "" }) })
        param_nodes.ret = inode
        insert = insert + 1
    end

    if vim.tbl_count(args[3]) ~= 1 then
        local exc = string.gsub(args[3][2], " throws ", "")
        local ins
        if old_state and old_state.ex then
            ins = i(insert, old_state.ex:get_text())
        else
            ins = i(insert)
        end
        vim.list_extend(nodes, { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) })
        param_nodes.ex = ins
        insert = insert + 1
    end

    vim.list_extend(nodes, { t({ " */" }) })

    local snip = sn(nil, nodes)
    -- Error on attempting overwrite.
    snip.old_state = param_nodes
    return snip
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

local hour_or_minute = function(args, _)
    local text = args[1][1] or ""

    -- HH:MM then return H or if it is MM return M
    if string.find(text, ":") then
        return sn(nil, {
            t({ "H" }),
        })
    else
        return sn(nil, {
            t({ "M" }),
        })
    end
end

local get_time = function()
    local options = {}
    local default_option = os.date("%p")
    table.insert(options, t(default_option))
    table.insert(options, t(default_option == "AM" and "PM" or "AM"))

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
    },
    python = require("modules.completion.snippets.python"),
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
            d(6, jdocsnip, { 2, 4, 5 }),
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
            d(4, cppdocsnip, { 1, 3, 3 }),
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
            d(6, require("modules.completion.snippets.sniputils").jdocsnip, { 2, 4, 5 }),
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
    norg = {
        -- ls.parser.parse_snippet("ses", "- [ ] session $1 {$2} [$3->to]"),
        s("programmersay", {
            t({ "> Great programmer what can u teach me? " }),
            t({ "", "" }),
            t({ "@code comment" }),
            t({ "", "" }),
            f(function(args)
                local quotes = require("custom.quotes")
                math.randomseed(os.clock())
                local index = math.random() * #quotes
                local quote = quotes[math.floor(index) + 1]
                table.insert(quote, "")
                return quote
            end),
            t({ "" }),
            t({
                "      /",
                "     /",
                "    -",
                "   / \\",
                "   | |",
                "    -",
                "   /|\\",
                "  / | \\",
                "    |",
                "    |",
                "   / \\",
                "  /   \\",
                " /     \\",
                "",
            }),
            t({ "@end" }),
        }),

        s("Cowthsay", {
            t({ "> Senpai of the pool whats your wisdom ?" }),
            t({ "", "" }),
            t({ "@code comment" }),
            t({ "", "" }),
            f(function(args)
                local cow = io.popen("fortune | cowsay -f vader")
                local cow_text = cow:read("*a")
                cow:close()
                return vim.split(cow_text, "\n", true)
            end, {}),
            t({ "@end" }),
        }),

        s("weebsay", {
            t({ "> Senpai of the pool whats your wisdom ?" }),
            t({ "", "" }),
            t({ "@code comment" }),
            t({ "", "" }),
            f(function(args)
                local weeb = io.popen("weebsay")
                local weeb_text = weeb:read("*a")
                weeb:close()
                return vim.split(weeb_text, "\n", true)
            end, {}),
            t({ "@end" }),
        }),
        s("randomsay", {
            t({ "> Senpai of the pool whats your /Random/ wisdom ?" }),
            t({ "", "" }),
            t({ "@code comment" }),
            t({ "", "" }),
            f(function(args)
                local animal_list = {
                    "beavis.zen",
                    "default",
                    "head-in",
                    "milk",
                    "small",
                    "turkey",
                    "blowfish",
                    "dragon",
                    "hellokitty",
                    "moofasa",
                    "sodomized",
                    "turtle",
                    "bong",
                    "dragon-and-cow",
                    "kiss",
                    "moose",
                    "stegosaurus",
                    "tux",
                    "bud-frogs",
                    "elephant",
                    "kitty",
                    "mutilated",
                    "stimpy",
                    "udder",
                    "bunny",
                    "elephant-in-snake",
                    "koala",
                    "ren",
                    "surgery",
                    "vader",
                    "vader-koala",
                    "cower",
                    "flaming-sheep",
                    "luke-koala",
                    "sheep",
                    "skeleton",
                    "three-eyes",
                    "daemon",
                    "ghostbusters",
                    "meow",
                    "skeleton",
                    "three-eyes",
                }

                local cow_command = "fortune | cowsay -f " .. animal_list[math.random(1, #animal_list)]
                local cow = io.popen(cow_command)
                local cow_text = cow:read("*a")
                cow:close()
                return vim.split(cow_text, "\n", true)
            end, {}),
            t({ "@end" }),
        }),

        s({ trig = "Ses" }, {
            t({ "Session " }),
            i(1, "1"),
            f(function()
                local input = vim.fn.input(" Enter time in HH:MM or MM format: ")
                local plus_hour, plus_min
                if input:find(":") == nil then
                    plus_hour = 00
                    plus_min = input
                else
                    plus_hour, plus_min = input:match("(%d+):(%d+)")
                end

                local t = os.date("%H:%M")
                local h = tonumber(string.sub(t, 1, 2))
                local m = tonumber(string.sub(t, 4, 5))
                -- add plus_hour and plus_min to current time
                h = h + tonumber(plus_hour)
                m = m + tonumber(plus_min)
                -- if minutes are more than 60, add 1 hour and subtract 60 minutes
                if m > 60 then
                    h = h + 1
                    m = m - 60
                end
                if h > 24 then
                    h = h - 24
                end
                if m < 10 then
                    m = "0" .. m
                end

                local added_time
                if plus_hour ~= 00 then
                    added_time = plus_hour .. ":" .. plus_min .. " H"
                else
                    added_time = plus_min .. "M"
                end

                local session_time = h .. ":" .. m

                local twentry_four_to_twelve_hour = function(t)
                    local hour, min = t:match("(%d+):(%d+)")
                    if tonumber(hour) > 12 then
                        hour = tonumber(hour) - 12
                        return hour .. ":" .. min .. " PM"
                    else
                        return hour .. ":" .. min .. " AM"
                    end
                end

                local current_12_hour = twentry_four_to_twelve_hour(t)
                local session_12_hour = twentry_four_to_twelve_hour(session_time)

                return " [" .. added_time .. "]" .. "(" .. current_12_hour .. " -> " .. session_12_hour .. ")"
            end, {}),
            t({ "{" }),
            i(3, "topic"),
            t({ "}" }),
        }),
        ls.parser.parse_snippet("lec", "  *** Lectures"),
        ls.parser.parse_snippet("work", "  *** work_sheets"),
        ls.parser.parse_snippet("1Hour", "  *** First Hour"),
        ls.parser.parse_snippet("2Hour", "  *** Second Hour"),

        ls.parser.parse_snippet(
            "hajime",
            "* Pomodoro\n** $0\n*** Lectures\n*** work_sheets\n\n* Breaks\n** Anime\n** Neovim\n\n* How am i feeling today "
        ),

        s("neorg focus area", {
            t("| $"),
            i(1, "focus_area_name"),
            t({ "$", "" }),
            i(2, "marker body"),
            t({ "", "| _" }),
        }),
    },
}

require("modules.completion.snippets.tex_math")
require("modules.completion.snippets.choice_popup")
require("modules.completion.snippets.tex")
require("luasnip/loaders/from_vscode").lazy_load({
    paths = { "~/.local/share/nvim/site/pack/packer/opt/friendly-snippets" },
})
