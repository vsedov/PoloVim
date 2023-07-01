local leader = ";e"
local options = {
    NR = ": Open the selected region in a new narrowed window",
    NW = ": Open the current visual window in a new narrowed window",
    WR = ": (In the narrowed window) write the changes back to the original buffer.",
    NRV = ": Open the narrowed window for the region that was last visually selected.",
    NUD = ": (In a unified diff) open the selected diff in 2 Narrowed windows",
    NRP = ": Mark a region for a Multi narrowed window",
    NRM = ": Create a new Multi narrowed window (after :NRP) - experimental!",
    NRS = ": Enable Syncing the buffer content back (default on)",
    NRN = ": Disable Syncing the buffer content back",
    NRL = ": Reselect the last selected region and open it again in a narrowed window",
}

local config = {
    Nrrwrgn = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        ["<cr>"] = {
            function()
                vim.ui.select(vim.tbl_keys(options), {
                    prompt = "Select an option: ",
                    format_item = function(entry, _)
                        return string.format("%s: %s", entry, options[entry])
                    end,
                }, function(selected)
                    if selected == nil then
                        return
                    end
                    vim.cmd(selected)
                end)
            end,
            { nowait = true, silent = true, desc = "Narrow[N] Window", exit = true },
        },
        w = {
            function()
                vim.api.nvim_feedkeys(lambda.replace_termcodes("<ESC>gv:NR<CR>"), "n", true)
            end,
            { desc = "Range Window", exit = true, mode = { "n", "v" } },
        },

        W = {
            function()
                vim.cmd([[NW]])
            end,
            { nowait = true, silent = true, desc = "Current Window", exit = true, mode = { "n", "v" } },
        },

        [";"] = {
            function()
                vim.cmd([[NRV]])
            end,
            { nowait = true, silent = true, desc = "Narrow[V]Win Last", exit = true },
        },

        u = {
            function()
                vim.cmd([[NUD]])
            end,
            { nowait = true, silent = true, desc = "Unique Diff", exit = false },
        },

        m = {
            function()
                vim.api.nvim_feedkeys(lambda.replace_termcodes("<ESC>gv:NRP<CR>"), "n", true)
            end,
            { nowait = true, silent = true, desc = "Mark region", exit = false, mode = { "n", "v" } },
        },

        M = {
            function()
                vim.cmd([[NRM]])
            end,
            { nowait = true, silent = true, desc = "[M]Win After :NRP", exit = false },
        },

        S = {
            function()
                vim.cmd([[NRS]])
            end,
            { nowait = true, silent = true, desc = "Sync Back to Buffer", exit = false },
        },

        s = {
            function()
                vim.cmd([[WR]])
            end,
            { nowait = true, silent = true, desc = "In Window Save", exit = false },
        },

        d = {
            function()
                vim.cmd([[NRN]])
            end,
            { nowait = true, silent = true, desc = "Disable Sync", exit = false },
        },

        l = {
            function()
                vim.cmd([[NRL]])
            end,
            { nowait = true, silent = true, desc = "Reselect Last Area", exit = false },
        },
    },
}

-- 0. Config core config defining binds and modes
-- 1. config name
-- 2. Bind order, you have to state what order you want to view your binds.
-- 3. The binds to be at the very top
-- 4. Extra placement on the borders for the binds
return {
    config,
    "Nrrwrgn",
    { { ";", "l" }, { "s", "S", "d", "u" } },
    { "<cr>", "w", "W", "m", "M" },
    6,
    3,
}
