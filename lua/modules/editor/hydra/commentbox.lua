local utils = require("modules.editor.hydra.utils")
local hydra = require("hydra")
local config = {}
local exit = { nil, { exit = true, desc = "EXIT" } }

local bracket = { "<cr>", "lc", "cc", "rc", "aa" }

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

config.browse = {
    color = "red",
    body = "<leader>C",
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
}

local function auto_hint_generate()
    container = {}
    for x, y in pairs(config.browse) do
        local mapping = x
        if type(y[1]) == "function" then
            for x, y in pairs(y[2]) do
                if x == "desc" then
                    container[mapping] = y
                end
            end
        end
    end

    sorted = {}
    for k, v in pairs(container) do
        table.insert(sorted, k)
    end
    table.sort(sorted)

    core_table = {}

    utils.make_core_table(core_table, bracket)
    utils.make_core_table(core_table, { "ll", "lr" })
    utils.make_core_table(core_table, { "cl", "cr" })
    utils.make_core_table(core_table, { "rl", "rr" })
    utils.make_core_table(core_table, { "al", "ar" })
    utils.make_core_table(core_table, { "L", "C", "R" })

    hint_table = {}
    string_val = "^ ^          Boxing        ^ ^\n\n"
    string_val = string_val
        .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"

    for _, v in pairs(core_table) do
        if v == "\n" then
            hint = "\n"
            hint = hint
                .. "^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^\n"
        else
            if container[v] then
                hint = "^ ^ _" .. v .. "_: " .. container[v] .. " ^ ^\n"
            end
        end
        table.insert(hint_table, hint)
        string_val = string_val .. hint
    end
    return string_val
end

vim.defer_fn(function()
    local new_hydra = require("modules.editor.hydra.utils").new_hydra(config, {
        name = "Nrrwrgn",
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
    })

    val = auto_hint_generate()
    new_hydra.hint = val
    hydra(new_hydra)
end, 100)
