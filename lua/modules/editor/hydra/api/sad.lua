local leader = ";S"
-- local hydra = require("hydra")

-- ["n|<leader><leader>Sr"] = map_cmd(":%s/<C-R><C-W>//gI<left><left><left>", "Replace word under cursor")
-- Replace word under cursor on Line (case-sensitive)
-- nmap <leader>sl :s/<C-R><C-W>//gI<left><left><left>
-- ["n|<leader><leader>Sl"] = map_cmd("
-- ["n|<leader><leader>Sc"] = map_cmd(
-- --
--
-- vim.keymap.set("n", "<leader>sl", function() end, { desc = "Replace current", expr = true })

--
-- vim.keymap.set({ "n" }, "<leader>sc", function() end, { desc = "Replace current", expr = true })
--
-- vim.keymap.set(
--     { "n", "x" },
--     "<leader>sw",
--     function() end,
--     { desc = "󱗘 :AltSubstitute word under cursor", expr = true }
-- )

local config = {
    Sad = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
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

        o = {
            function()
                require("substitute").eol()
            end,
            { nowait = true, desc = "Operator eol", exit = true },
        },
        ----------------------------------------------------------

        K = {
            function()
                require("substitute.range").operator({ motion1 = "iW" })
            end,
            { nowait = true, desc = "range Sub", exit = true },
        },

        k = {
            function()
                require("substitute.range").word()
            end,
            { nowait = true, desc = "range word", exit = true },
        },

        a = {
            function()
                require("substitute.range").operator({ motion1 = "iw", motion2 = "ap" })
            end,
            { nowait = true, desc = "range word", exit = true },
        },

        ----------------------------------------------------------
        Q = {
            function()
                require("substitute.exchange").operator()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },

        q = {
            function()
                require("substitute.exchange").word()
            end,
            { nowait = true, desc = "Exchange Sub", exit = true },
        },

        C = {
            function()
                require("substitute.exchange").cancel()
            end,
            { desc = "Exchange Sub", nowait = true, exit = true },
        },

        ----------------------------------------------------------
        s = {
            function()
                require("ssr").open()
            end,

            { nowait = true, desc = "SSR Rep", exit = true },
        },
        S = {
            function()
                vim.cmd([[Sad]])
            end,

            { nowait = true, desc = "Sad SSR", exit = true },
        },

        -----------------------------------------------------------
        O = {
            function()
                require("spectre").open()
            end,

            { nowait = true, desc = "Spectre Open", exit = true },
        },
        V = {
            function()
                if vim.fn.mode() == "v" then
                    require("spectre").open_visual({ select_word = true })
                else
                    require("spectre").open_visual()
                end
            end,

            { nowait = true, desc = "Specre Word", exit = true },
        },
        X = {
            function()
                if vim.fn.mode() == "v" then
                    require("spectre").open_visual({ select_word = true })
                else
                    require("spectre").open_file_search()
                end
            end,

            { nowait = true, desc = "Spectre V", exit = true },
        },

        F = {
            function()
                require("spectre").open_file_search()
            end,
            { nowait = true, desc = "Spectre FS", exit = true },
        },

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
    },
}

bracket = { "s", "W", "w", "S", "E" }
range = { "a", "k", "K" }
eol = { "L", "l", "o" }
sub = { "C", "Q", "q" }
core = { "O", "F", "V", "X" }
return {
    config,
    "Sad",
    { range, eol, sub, core },
    bracket,
    6,
    3,
}
