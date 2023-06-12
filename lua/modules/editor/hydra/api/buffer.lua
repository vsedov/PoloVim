local bracket = { "l", "h", "L", "H", "=", "+", "b", "B", "<cr>" }
local leader_key = "<leader>b"

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

        ["["] = {
            function()
                require("three").next_tab()
            end,
            { desc = "[G]oto next [T]ab", exit = false },
        },
        ["]"] = {
            function()
                require("three").prev_tab()
            end,
            { desc = "[G]oto prev [T]ab", exit = false },
        },

        B = {
            function()
                vim.ui.input({ prompt = "enter the buffer you want to jump to" }, function(value)
                    require("three").wrap(require("three").jump_to, value)
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
        m = {
            function()
                buffer_move()
            end,
            { desc = "[B]uffer [M]ove", exit = true },
        },

        n = {
            function()
                vim.cmd("$tabnew<CR>")
            end,
            { desc = "Tab New", exit = false },
        },
        C = {
            function()
                vim.cmd("$tabclose<cr>")
            end,
            { desc = "Tab close" },
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
    },
}

return {
    config,
    "Buffer",
    {
        { "n", "C", "[", "]", "P" },
        { "q", "Q", "M", "m" },
        { "e", ">", "<", "p", "c" },
        { "D", "d" },
        { "1", "2", "3" },
    },
    bracket,
    6,
    4,
}
