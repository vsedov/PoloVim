local bracket = { "l", "h", "L", "H", "=", "+", "b", "B", "<cr>" }
local leader_key = "<leader>b"
local hbac = require("hbac")

local function buffer_move()
    vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
        idx = idx and tonumber(idx)
        if idx then
            require("three").move_buffer(idx)
        end
    end)
end

vim.api.nvim_create_user_command("ProjectDelete", function()
    require("three").remove_project()
end, {})

local config = {
    Buffer = {
        color = "red",
        body = leader_key,
        mode = { "n" },

        b = {
            function()
                vim.cmd("Telescope buffers")
            end,
            { desc = "Buffers", exit = true },
        },
        l = {
            function()
                vim.cmd("BufferLineCycleNext")
            end,

            { desc = "Next Buffers", exit = false },
        },
        h = {
            function()
                vim.cmd("BufferLineCyclePrev")
            end,

            { desc = "Prev Buffers", exit = false },
        },

        L = {
            function()
                require("three").next()
            end,

            { desc = "[G]oto next [B]uffer", exit = false },
        },
        H = {
            function()
                require("three").prev()
            end,

            { desc = "[G]oto Prev [B]uffer", exit = false },
        },

        B = {
            function()
                vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
                    idx = idx and tonumber(idx)
                    if idx then
                        require("three").move_buffer(idx)
                    end
                end)
            end,
            { desc = "Jump to Buf", exit = true },
        },
        q = {
            function()
                require("three").smart_close()
            end,
            { desc = "[C]lose Smart", exit = true },
        },
        Q = {
            function()
                require("three").close_buffer()
            end,
            { desc = "[B]uffer [C]lose", exit = true },
        },
        M = {
            function()
                require("three").hide_buffer()
            end,
            { desc = "[B]uffer [H]ide", exit = true },
        },

        P = {
            function()
                require("three").open_project()
            end,
            { desc = "Three Project", exit = true },
        },

        c = {
            function()
                vim.cmd("BufferLinePick")
            end,
            { desc = "Pick buffer" },
        },
        ["+"] = {
            function()
                vim.cmd("BufferLineMoveNext")
            end,
            { desc = "Move Next", exit = false },
        },
        ["="] = {
            function()
                vim.cmd("BufferLineMovePrev")
            end,
            { desc = "Move Prev", exit = false },
        },
        D = {
            function()
                vim.cmd("BufferLinePickClose")
            end,
            { desc = "Close Buf", exit = false },
        },
        p = {
            function()
                vim.cmd("BufferLineTogglePin")
            end,
            { desc = "Pin Buf" },
        },

        ["1"] = {
            function()
                vim.cmd("BufferLineSortByTabs")
            end,
            { desc = "Sort Tabs" },
        },
        ["2"] = {
            function()
                vim.cmd("BufferLineSortByDirectory")
            end,
            { desc = "Sort Dir" },
            -- { desc = "Sort dir", exit = true },
        },
        ["3"] = {
            function()
                vim.cmd("BufferLineSortByRelativeDirectory")
            end,
            { desc = "Sort RDir" },
        },

        e = {
            function()
                vim.ui.input({ prompt = "Split H, V or Leave empty", default = "" }, function(value)
                    value = value:lower()
                    if value == "h" then
                        vim.cmd("BufExplorerHorizontalSplit")
                    elseif value == "v" then
                        vim.cmd("BufExplorerVerticalSplit")
                    else
                        vim.cmd("ToggleBufExplorer")
                    end
                end)
            end,
            { desc = "BufExplorer", exit = true },
        },

        [">"] = {
            function()
                vim.cmd("BufExplorerVerticalSplit")
            end,

            { desc = "Explore Vertical", exit = true },
        },

        ["<"] = {
            function()
                vim.cmd("BufExplorerHorizontalSplit")
            end,

            { desc = "Explore Horizontal", exit = true },
        },

        d = {
            function()
                require("bufdelete").bufdelete(0, true)
            end,
            { desc = "Killthis", exit = true },
        },
        ["<cr>"] = {
            function()
                vim.cmd("BufOnly")
                -- Bdelete -- you could use this too,
            end,
            { desc = "Buf Wipe", exit = true },
        },

        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        ["<c-a>"] = {
            function()
                hbac.toggle_pin()
            end,
            { desc = "Hbac-Toggle Buf", exit = false },
        },
        ["<c-x>"] = {
            function()
                hbac.close_unpinned()
            end,
            { desc = "Hbac-Close Upin [C]", exit = false },
        },
        ["<c-p>"] = {
            function()
                hbac.pin_all()
            end,
            { desc = "Hbac-Pin All", exit = false },
        },
        ["<c-u>"] = {
            function()
                hbac.unpin_all()
            end,
            { desc = "Hbac-Unpin All", exit = false },
        },
        ["<c-t>"] = {
            function()
                hbac.toggle_autoclose()
            end,
            { desc = "Hbac AutoClose T", exit = false },
        },
    },
}

return {
    config,
    "Buffer",
    {
        { "P", "q", "Q", "M" },
        { "e", ">", "<", "p", "c" },
        { "D", "d" },
        { "1", "2", "3" },
        { "<c-a>", "<c-x>", "<c-p>", "<c-u>", "<c-t>" },
    },
    bracket,
    6,
    4,
}
