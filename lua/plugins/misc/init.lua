local opts = { move_cursor = true, keymaps = { visual = "s" } }
require("nvim-surround").setup(opts)

-- surr*ound_words             ysiw)           (surround_words)
-- *make strings               ys$"            "make strings"
-- [delete ar*ound me!]        ds]             delete around me!
-- remove <b>HTML t*ags</b>    dst             remove HTML tags
-- 'change quot*es'            cs'"            "change quotes"
-- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
-- delete(functi*on calls)     dsf             function calls

local bind_list = {
    ["surround_word"] = {
        bind = "ysiw)",
        text = "(surround_words)",
    },

    ["*make strings"] = {
        bind = 'ys$"',
        text = '"make strings"',
    },

    ["[delete around me!]"] = {
        bind = "ds]",
        text = "delete around me!",
    },

    ["remove <b>HTML tags</b>"] = {
        bind = "dst",
        text = "remove HTML tags",
    },

    ["'change quotes'"] = {
        bind = "cs'\"",
        text = '"change quotes"',
    },

    ["<b>or tag types</b>"] = {
        bind = "csth1<CR>",
        text = "<h1>or tag types</h1>",
    },

    ["delete(function calls)"] = {
        bind = "dsf",
        text = "function calls",
    },
}

-- not make it like info, bind , text in one big text and print it using vim.notify
table_string = ""
for k, v in pairs(bind_list) do
    table_string = table_string .. k .. " " .. v.bind .. " " .. v.text .. "\n"
end

lambda.command("SurroundBinds", function()
    vim.notify(table_string)
end)

require("ns-textobject").setup({
    auto_mapping = {
        -- automatically mapping for nvim-surround's aliases
        aliases = true,
        -- for nvim-surround's surrounds
        surrounds = true,
    },
    disable_builtin_mapping = {
        enabled = true,
        -- list of char which shouldn't mapping by auto_mapping
        chars = { "b", "B", "t", "`", "'", '"', "{", "}", "(", ")", "[", "]", "<", ">" },
    },
})
vim.g.wordmotion_prefix = ","
vim.keymap.set({ "i", "n" }, "<C-y>", "<Plug>(dmacro-play-macro)")
