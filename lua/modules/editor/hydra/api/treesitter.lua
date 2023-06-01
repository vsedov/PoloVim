local ts_move = require("nvim-treesitter.textobjects.move")
local tc = require("nvim-treeclimber")
local leader = "\\<leader>"

local mx = function(feedkeys, type)
    local type = type or "m"
    return function()
        if type == "v" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, true, true), "n", true)
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(feedkeys, true, false, true), type, false)
    end
end

local motion_type = {
    d = "Del",
    c = "Cut",
    y = "Yank",
}

local config = {
    Treesitter = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },

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
    },
}

for surround, motion in pairs({ c = "ac", C = "ic", a = "af", A = "if", i = "aC", I = "iC" }) do
    for doc, key in pairs({ d = "d", y = "y" }) do
        local motiondoc = surround
        -- local exit_call = false
        local mapping = table.concat({ doc, surround })
        config.Treesitter[mapping] = {
            mx(table.concat({ key, motion })),
            { desc = motion_type[doc] .. " [" .. key .. motion .. "]", exit = true },
        }
    end
end

local bracket = { "h", "j", "k", "l", "O", "J", "K" }

return {
    config,
    "Treesitter",
    {
        { "A", "a", "i", "I", "W", "w" },
        { "yA", "ya", "yc", "yC", "yI", "yi" },
        { "dA", "da", "dc", "dC", "dI", "di" },
    },
    bracket,
    6,
    5,
}
