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
]]

local yanky_hydra = Hydra({
    name = "Yank ring",
    mode = "n",
    config = {
        color = "amaranth",
        invoke_on_body = true,
        hint = {
            border = lambda.style.border.type_0,
            position = "middle-right",
        },
    },
    hint = hint,
    heads = {
        { "p", "<Plug>(YankyPutAfter)", { desc = "After" } },
        { "P", "<Plug>(YankyPutBefore)", { desc = "Before" } },
        { "n", "<Plug>(YankyCycleForward)", { private = true, desc = "↓" } },
        { "N", "<Plug>(YankyCycleBackward)", { private = true, desc = "↑" } },
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
    ["]p"] = "<Plug>(YankyPutIndentAfterLinewise)",
    ["[p"] = "<Plug>(YankyPutIndentBeforeLinewise)",
    ["]P"] = "<Plug>(YankyPutIndentAfterLinewise)",
    ["[P"] = "<Plug>(YankyPutIndentBeforeLinewise)",

    [">p"] = "<Plug>(YankyPutIndentAfterShiftRight)",
    ["<p"] = "<Plug>(YankyPutIndentAfterShiftLeft)",
    [">P"] = "<Plug>(YankyPutIndentBeforeShiftRight)",
    ["<P"] = "<Plug>(YankyPutIndentBeforeShiftLeft)",

    ["=p"] = "<Plug>(YankyPutAfterFilter)",
    ["=P"] = "<Plug>(YankyPutBeforeFilter)",
}) do
    vim.keymap.set("n", key, function()
        vim.fn.feedkeys(t(putAction))
        yanky_hydra:activate()
    end)
end

require("telescope").load_extension("yank_history")
vim.keymap.set("n", "<leader>yu", "<cmd>Telescope yank_history<cr>", {})
