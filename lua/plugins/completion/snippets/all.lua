local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local function char_count_same(c1, c2)
    local line = vim.api.nvim_get_current_line()
    -- '%'-escape chars to force explicit match (gsub accepts patterns).
    -- second return value is number of substitutions.
    local _, ct1 = string.gsub(line, "%" .. c1, "")
    local _, ct2 = string.gsub(line, "%" .. c2, "")
    return ct1 == ct2
end

local function even_count(character)
    local line = vim.api.nvim_get_current_line()
    local _, ct = string.gsub(line, character, "")
    return ct % 2 == 0
end

local function neg(fn, ...)
    return not fn(...)
end

local function part(fn, ...)
    local args = { ... }
    return function()
        return fn(unpack(args))
    end
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, expand_func, ...)
    -- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
    -- ... is used to pass any args following the expand_func to it.
    return s({ trig = pair_begin, wordTrig = false }, {
        t({ pair_begin }),
        i(1),
        t({ pair_end }),
    }, {
        condition = part(expand_func, part(..., pair_begin, pair_end)),
    })
end

local all = {
    s(
        -- TODO(vsedov) (01:30:01 - 30/03/22): can probably make this smarter, need to finish it atm
        { trig = "table", dscr = "Table template" },
        {
            t("| "),
            i(1, "First Header"),
            t({
                "  | Second Header |",
                "| ------------- | ------------- |",
                "| Content Cell  | Content Cell  |",
                "| Content Cell  | Content Cell  |",
            }),
        }
    ),

    s(
        { trig = "hr", name = "Header" },
        fmt(
            [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
            {
                f(function()
                    local comment = string.format(vim.bo.commentstring:gsub(" ", "") or "#%s", "-")
                    local col = vim.bo.textwidth or 80
                    return comment .. string.rep("-", col - #comment)
                end),
                f(function()
                    return vim.bo.commentstring:gsub("%%s", "")
                end),
                i(1, "HEADER"),
                i(0),
            }
        )
    ),
    s({ trig = "date" }, {
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
            f(function()
                return "Still only counts as text!!"
            end, {}),
        })
    ),
}

return all
