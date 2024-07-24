local Hydra = require("hydra")
local api = vim.api
local function t(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

local hint = [[
^ ^ _p_: After   ^ ^
^ ^ _P_: Before  ^ ^
^ ^ _n_: ↓       ^ ^
^ ^ _N_: ↑       ^ ^
^ ^ _<c-p>_: paste from clipboard^ ^
^ ^ _<c-n>_: paste from clipboard^ ^
^ ^ _q_: quit    ^ ^
^ ^ _<esc>_: quit^ ^
]]
local yanky_hydra = Hydra({
    name = "Yank ring",
    mode = "n",
    config = {
        color = "amaranth",
        invoke_on_body = false,
        hint = {
            position = "middle-right",
        },
    },
    hint = hint,
    body = "p",
    heads = {
        { "p", "<Plug>(YankyPutAfter)", { desc = "After" } },
        { "P", "<Plug>(YankyPutBefore)", { desc = "Before" } },
        { "n", "<Plug>(YankyCycleForward)", { noremap = true, private = true, desc = "↓" } },
        { "N", "<Plug>(YankyCycleBackward)", { noremap = true, private = true, desc = "↑" } },
        {
            "<esc>",
            nil,
            { exit = true, desc = "quit" },
        },

        {
            "q",
            nil,
            { exit = true, desc = "quit" },
        },
        {

            "<c-p>",
            [[<Cmd>silent! normal! "_dP<CR>]],
            { desc = "paste from clipboard" },
        },
        {
            "<c-n>",
            [[<Cmd>silent! normal! "_dp<CR>]],
            { desc = "paste from clipboard" },
        },
    },
})
-- choose/change the mappings if you want
for key, putAction in pairs({
    ["p"] = "<Plug>(YankyPutAfter)",
    ["P"] = "<Plug>(YankyPutBefore)",
    ["gp"] = "<Plug>(YankyGPutAfter)",
    ["gP"] = "<Plug>(YankyGPutBefore)",
}) do
    vim.keymap.set({ "n", "x" }, key, function()
        vim.fn.feedkeys(t(putAction))
        yanky_hydra:activate()
    end)
end

for key, putAction in pairs({
    ["[p"] = "<Plug>(YankyPutIndentBeforeLinewise)",
    ["]P"] = "<Plug>(YankyPutIndentAfterLinewise)",

    [">p"] = "<Plug>(YankyPutIndentAfterShiftRight)",
    ["<p"] = "<Plug>(YankyPutIndentAfterShiftLeft)",
    [">P"] = "<Plug>(YankyPutIndentBeforeShiftRight)",
    ["<P"] = "<Plug>(YankyPutIndentBeforeShiftLeft)",

    ["=p"] = "<Plug>(YankyPutAfterFilter)",
    ["=P"] = "<Plug>(YankyPutBeforeFilter)",
}) do
    vim.keymap.set("n", key, function()
        vim.fn.feedkeys(t(putAction))
        vim.schedule_wrap(yanky_hydra:activate())
    end, { noremap = true, silent = true })
end
