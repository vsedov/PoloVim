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

vim.keymap.set({ "i", "n" }, "<C-y>", "<Plug>(dmacro-play-macro)")

vim.g.wordmotion_prefix = ","
vim.g.wordmotion_nomap = 1
require("spider").setup({
    skipInsignificantPunctuation = true,
    consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
    subwordMovement = true,
    customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
})

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
vim.keymap.set("o", "w", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set("n", "cw", "ce", { remap = true })

-- or the same in one mapping without `remap = true`
vim.keymap.set("n", "cw", "c<cmd>lua require('spider').motion('e')<CR>")
