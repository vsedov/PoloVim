local leader = "L"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local config = {
    Sad = {
        color = "teal",
        body = leader,
        mode = { "n", "x", "v" },
        ["<ESC>"] = { nil, { exit = true } },
        L = {
            function()
                require("substitute").operator()
            end,
            { nowait = true, desc = "Operator Sub", exit = true },
        },

        l = {
            function()
                require("substitute").line()
            end,
            { nowait = true, desc = "Operator line", exit = true },
        },
        ----------------------------------------------------------
        -- local core = { "o", "g", "<cr>" }

        K = {
            function()
                require("substitute").eol()
            end,
            { nowait = true, desc = "Operator eol", exit = true },
        },

        k = {
            function()
                require("substitute.exchange").operator()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },

        ----------------------------------------------------------
        s = {
            function()
                require("ssr").open()
            end,

            { nowait = true, desc = "SSR Rep", exit = true },
        },
        -----------------------------------------------------------
        j = {
            cmd("GrugFar"),
            { exit = true, nowait = true, silent = true, desc = "GrugFar Open" },
        },
        J = {
            function()
                require("grug-far").grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
            end,
            { exit = true, nowait = true, silent = true, desc = "Grugfar Current", mode = { "v", "n" } },
        },
        c = {
            function()
                require("grug-far").grug_far({ prefills = { flags = vim.fn.expand("%") } })
            end,
            { exit = true, nowait = true, silent = true, desc = "Grugfar Limit to file", mode = { "v", "n" } },
        },

        --
        -----------------------------

        w = {
            ":S /" .. vim.fn.expand("<cword>") .. "//g<Left><Left>",

            { nowait = true, desc = "Rep All", exit = true },
        },
        W = {
            [[:%S /<C-R><C-W>//gI<left><left><left>]],

            { nowait = true, desc = "Rep Word[C]", exit = true },
        },

        E = {
            [[:S ///g<Left><Left><Left>]],

            { nowait = true, desc = "Rep Word", exit = false },
        },
        m = {
            function()
                vim.cmd("MurenToggle")
            end,
            { desc = "Toggle UI", exit = true },
        },
        M = {
            function()
                vim.cmd("MurenOpen")
            end,
            { desc = "Open UI", exit = true },
        },
        C = {
            function()
                vim.cmd("MurenClose")
            end,
            { desc = "Close UI", exit = true },
        },

        F = {
            function()
                vim.cmd("MurenFresh")
            end,
            { desc = "Open Fresh UI", exit = true },
        },
        u = {
            function()
                vim.cmd("MurenUnique")
            end,
            { desc = "Open Unique UI", exit = true },
        },

        -- "MCstart",
        -- "MCvisual",
        -- "MCpattern",
        -- "MCvisualPattern",
        -- "MCunderCursor",
        -- "MCclear",

        ["<leader>"] = {
            "<cmd>MCstart<cr>",
            { desc = "Start" },
        },
        V = {
            "<cmd>MCvisual<cr>",
            { desc = "Start", mode = "v" },
        },
        ["<cr>"] = {
            function()
                local commands = {
                    "MCpattern",
                    "MCvisualPattern",
                    "MCunderCursor",
                    "MCclear",
                }

                -- vim.ui.select(commands, {
                --     prompt = "MultiMC Util",
                --     },
                --     on_select = function(selected)
                --         vim.cmd(selected)
                --     end)

                vim.ui.select(commands, {
                    prompt = "MultiMc Util",
                }, function(inner_item)
                    if vim.tbl_contains(commands, inner_item) then
                        vim.defer_fn(function()
                            vim.cmd(inner_item)
                        end, 100)
                    end
                end)
            end,
            { desc = "MultiMC Util", mode = { "v", "n", "x" }, exit = true },
        },
    },
}

local bracket = { "<leader>", "<cr>", "V", "s", "W", "w", "E" }
local Muren = { "m", "M", "C", "F", "u" }
local eol = { "L", "l", "K", "k" }
local spectre = { "j", "J", "c" }
local other = { "q", "n", "r", "R", "I", "H", "U", "v", ";", "p" }

return {
    config,
    "Sad",
    { spectre, Muren, eol, other },
    bracket,
    6,
    3,
    1,
}
