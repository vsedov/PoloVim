-- https://github.com/josephsdavid/neovim2/blob/master/lua/core/hydra.lua

local Hydra = require("hydra")

local ex = function(feedkeys)
    return function()
        local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
        vim.api.nvim_feedkeys(keys, "x", false)
    end
end

local pmode = {
    name = "Parenth-mode",
    config = { color = "pink", invoke_on_body = true, timeout = false, hint = { type = "statusline" } },
    mode = "n",
    body = "\\<leader>",
    heads = {
        {
            "\\<leader>",
            nil,
            { exit = true, desc = "EXIT" },
        },
        {
            "j",
            function()
                vim.fn.search("[({[]")
            end,
            { nowait = true, desc = "next (" },
        },
        {
            "k",
            function()
                vim.fn.search("[({[]", "b")
            end,
            { nowait = true, desc = "previous (" },
        },
    },
}

for surround, motion in pairs({ i = "j", a = "k" }) do
    for doc, key in pairs({ delete = "d", change = "c" }) do
        local motiondoc
        if motion == "j" then
            motiondoc = "within"
        else
            motiondoc = "around"
        end
        pmode["heads"][#pmode.heads + 1] = {
            table.concat({ key, motion }),
            ex(table.concat({ key, surround, "%" })),
            { nowait = true, desc = table.concat({ doc, motiondoc }, " ") },
        }
    end
end

Hydra(pmode)
