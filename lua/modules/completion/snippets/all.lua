local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- For some reason, this just doesnt work
if vim.bo.filetype ~= "tex" then
    local all_a = {
        s({ trig = ":td:", name = "TODO" }, {
            c(1, {
                t(string.format(vim.bo.commentstring:gsub("%%s", " TODO(vsedov): "))),
                t(string.format(vim.bo.commentstring:gsub("%%s", " FIXME(vsedov): "))),
                t(string.format(vim.bo.commentstring:gsub("%%s", " HACK(vsedov): "))),
                t(string.format(vim.bo.commentstring:gsub("%%s", " BUG(vsedov): "))),
            }),
            i(0),
        }),
    }

    ls.add_snippets("all", all_a, { type = "autosnippets" })
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
