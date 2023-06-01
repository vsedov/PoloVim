local exit = { nil, { exit = true, desc = "EXIT" } }
local bracket = { "<cr>", "lc", "cc", "rc", "aa" }
local leader = "<leader>C"

local cb = require("comment-box")
local options = {
    ll = { label = "[L] Aligned Box With [L]", fn = cb.llbox },
    lc = { label = "[L] Aligned Box With [C]", fn = cb.lcbox },
    lr = { label = "[L] Aligned Box With [R]", fn = cb.lrbox },

    cl = { label = "[C] Box With [L]", fn = cb.clbox },
    cc = { label = "[C] Box With [C]", fn = cb.ccbox },
    cr = { label = "[C] Box With [R]", fn = cb.crbox },

    rl = { label = "[R] Aligned Box With [L]", fn = cb.rlbox },
    rc = { label = "[R] Aligned Box With [C]", fn = cb.rcbox },
    rr = { label = "[R] Aligned Box With [R] ", fn = cb.rrbox },

    aa = { label = "[L] Aligned adapted box", fn = cb.albox },
    ac = { label = "[C] Adapted Box", fn = cb.acbox },
    ar = { label = "[R] Aligned adapted box", fn = cb.arbox },

    L = { label = "[L] Line", fn = cb.line },
    C = { label = "[C] Centered Line", fn = cb.cline },
    R = { label = "[R] Right Aligned Line", fn = cb.rline },
}

local config = {
    Box = {
        color = "red",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        ["<cr>"] = {
            function()
                vim.ui.select(vim.tbl_keys(options), {
                    prompt = "Select an option: ",
                    format_item = function(entry, _)
                        return string.format("%s: %s", entry, options[entry].label)
                    end,
                }, function(selected)
                    if selected == nil then
                        return
                    end
                    options[selected].fn()
                end)
            end,
            { nowait = true, silent = true, desc = "All Options", exit = true },
        },
        ["L"] = { options["L"].fn, { desc = options["L"].label, nowait = true, silent = true } },
        ["C"] = { options["C"].fn, { desc = options["C"].label, nowait = true, silent = true } },
        ["R"] = { options["R"].fn, { desc = options["R"].label, nowait = true, silent = true } },

        ["ll"] = { options["ll"].fn, { desc = options["ll"].label, nowait = true, silent = true } },
        ["lc"] = { options["lc"].fn, { desc = options["lc"].label, nowait = true, silent = true } },
        ["lr"] = { options["lr"].fn, { desc = options["lr"].label, nowait = true, silent = true } },

        ["cl"] = { options["cl"].fn, { desc = options["cl"].label, nowait = true, silent = true } },
        ["cc"] = { options["cc"].fn, { desc = options["cc"].label, nowait = true, silent = true } },
        ["cr"] = { options["cr"].fn, { desc = options["cr"].label, nowait = true, silent = true } },

        ["rl"] = { options["rl"].fn, { desc = options["rl"].label, nowait = true, silent = true } },
        ["rc"] = { options["rc"].fn, { desc = options["rc"].label, nowait = true, silent = true } },
        ["rr"] = { options["rr"].fn, { desc = options["rr"].label, nowait = true, silent = true } },

        ["aa"] = { options["aa"].fn, { desc = options["aa"].label, nowait = true, silent = true } },
        ["ac"] = { options["ac"].fn, { desc = options["ac"].label, nowait = true, silent = true } },
        ["ar"] = { options["ar"].fn, { desc = options["ar"].label, nowait = true, silent = true } },
    },
}
return {
    config,
    "Box",
    { { "ll", "lr" }, { "cl", "cr" }, { "rl", "rr" }, { "ac", "ar" }, { "L", "C", "R" } },
    bracket,
    6,
    3,
}
