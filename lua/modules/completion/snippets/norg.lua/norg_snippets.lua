local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local conds = require("luasnip.extras.expand_conditions")
    norg = {

        s("neorg checkbox", {
            t("- [ ] "),
            i(1, "todo.."),
        }),

        -------------------------
        ---       links       ---
        -------------------------

        s("neorg link curly", {
            t("{"),
            i(1, "name"),
            t("}["),
            i(2, "link"),
            t("]"),
        }),
        s("neorg link paren", {
            t("("),
            i(1, "name"),
            t(")["),
            i(2, "link"),
            t("]"),
        }),
        s("neorg link square", {
            t("["),
            i(1, "name"),
            t("]["),
            i(2, "link"),
            t("]"),
        }),
        --

        s("neorg project starter", {
            t("#context $"),
            i(1, "context name"),
            t({ "$", "" }),
            t("#time.start $"),
            i(2, "date"),
            t({ "$", "" }),
            t("#time.due $"),
            i(3, "date"),
            t({ "$", "" }),
            t("* $"),
            i(4, "project name"),
            t({ "$", "" }),
            t("- [ ] $"),
            i(5, "task description"),
            t("$"),
        }),

        -- @code norg
        -- | §Area Of Focus name§
        -- marker body
        -- | _
        -- @end
        s("neorg focus area", {
            t("| $"),
            i(1, "focus_area_name"),
            t({ "$", "" }),
            i(1, "marker body"),
            t({ "", "| _" }),
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
        ls.parser.parse_snippet("OneHour", "  *** First Hour"),
        ls.parser.parse_snippet("TwoHour", "  *** Second Hour"),

        ls.parser.parse_snippet(
            "hajime",
            "* Pomodoro\n** $0\n\n*** Lectures\n\n*** work_sheets\n\n* Breaks\n** Anime\n** Neovim\n\n* How am i feeling today "
        ),

        s({
            trig = "*([2-6])",
            name = "Heading",
            dscr = "Add Heading",
            regTrig = true,
            hidden = true,
        }, {
            f(function(_, snip)
                return string.rep("*", tonumber(snip.captures[1])) .. " "
            end, {}),
        }, {
            condition = conds.line_begin,
        }),
        s({
            trig = "q([2-6])",
            name = "Quote",
            dscr = "Add Quote",
            regTrig = true,
            hidden = true,
        }, {
            f(function(_, snip)
                return string.rep(">", tonumber(snip.captures[1])) .. " "
            end, {}),
        }, {
            condition = conds.line_begin,
        }),
        s({
            trig = "-([2-6])",
            name = "Unordered lists",
            dscr = "Add Unordered lists",
            regTrig = true,
            hidden = true,
        }, {
            f(function(_, snip)
                return string.rep("-", tonumber(snip.captures[1])) .. " "
            end, {}),
        }, {
            condition = conds.line_begin,
        }),
        s({
            trig = "~([2-6])",
            name = "Ordered lists",
            dscr = "Add Ordered lists",
            regTrig = true,
            hidden = true,
        }, {
            f(function(_, snip)
                return string.rep("~", tonumber(snip.captures[1])) .. " "
            end, {}),
        }, {
            condition = conds.line_begin,
        }),
    },