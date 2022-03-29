local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local all = {

    s(
        -- TODO: can probably make this one much smarter; right now it's basically just syntax reminder
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
    -- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/
    s({ trig = "td", name = "TODO" }, {
        c(1, {
            t("TODO: "),
            t("FIXME: "),
            t("HACK: "),
            t("BUG: "),
        }),
        i(0),
    }),
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
