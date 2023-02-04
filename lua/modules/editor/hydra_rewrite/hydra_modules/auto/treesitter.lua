local ts_move = require("nvim-treesitter.textobjects.move")
local tc = require("nvim-treeclimber")
local leader = "\\<leader>"
local mx = require("modules.editor.hydra_rewrite.api.utils").mx

local motion_type = {
    d = "Del",
    c = "Cut",
    y = "Yank",
}

local config = {
    color = "pink",
    body = leader,
    ["<ESC>"] = { nil, { exit = true } },
    j = {
        function()
            ts_move.goto_next_start({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [N] ←" },
    },
    h = {
        function()
            ts_move.goto_next_end({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [N] →" },
    },
    k = {
        function()
            ts_move.goto_previous_start({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [P] ←" },
    },
    l = {
        function()
            ts_move.goto_previous_start({ "@function.outer", "@class.outer" })
        end,
        { nowait = true, desc = "Move [P] →" },
    },

    -- ig finds the diagnostic under or after the cursor (including any diagnostic the cursor is sitting on)
    -- ]g finds the diagnostic after the cursor (excluding any diagnostic the cursor is sitting on)
    -- [g finds the diagnostic before the cursor (excluding any diagnostic the cursor is sitting on)

    ["O"] = { mx("ig", "v"), { nowait = true, desc = "Diag A[Cur]" } }, -- ts: all class
    ["J"] = { mx("]g", "v"), { nowait = true, desc = "Diag >[Cur]" } }, -- ts: all class
    ["K"] = { mx("[g", "v"), { nowait = true, desc = "Diag <[Cur]" } }, -- ts: all class

    ["w"] = { mx("ac", "v"), { nowait = true, desc = "Cls  [ac]" } }, -- ts: all class
    ["W"] = { mx("ic", "v"), { nowait = true, desc = "Cls  [ic]" } }, -- ts: inner class

    ["a"] = { mx("af", "v"), { nowait = true, desc = "Func [af]" } }, -- ts: all function
    ["A"] = { mx("if", "v"), { nowait = true, desc = "Func [if]" } }, -- ts: inner function

    ["i"] = { mx("aC", "v"), { nowait = true, desc = "Cond [aC]" } }, -- ts: all conditional
    ["I"] = { mx("iC", "v"), { nowait = true, desc = "Cond [iC]" } }, -- ts: inner conditional
    ["<CR>"] = { mx("J"), { nowait = true, desc = "Jump", exit = true } }, -- ts: inner conditional
}

--  TODO: (vsedov) (02:33:50 - 07/11/22): Cut and delete in this instance would do the same thing if
--  im not mistaken c = "c"
for surround, motion in pairs({ c = "ac", C = "ic", a = "af", A = "if", i = "aC", I = "iC" }) do
    for doc, key in pairs({ d = "d", y = "y" }) do
        local motiondoc = surround
        -- local exit_call = false
        local mapping = table.concat({ doc, surround })
        config[mapping] = {
            mx(table.concat({ key, motion })),
            { desc = motion_type[doc] .. " [" .. key .. motion .. "]", exit = true },
        }
    end
end

return {
    {
        name = "TS",
        config = {
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
            timeout = false,
            invoke_on_body = true,
        },
        heads = {},
        mode = { "n", "v", "x", "o" },
    },
    config,

    { "h", "j", "k", "l", "O", "J", "K" },

    {
        { 1, {} },
        { 2, "y" },
        { 2, "d" },
    },
}
