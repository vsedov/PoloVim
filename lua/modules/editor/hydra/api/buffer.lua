local leader_key = "<leader>b"

local function buffer_move()
    vim.ui.input({ prompt = "Move buffer to:" }, function(idx)
        idx = idx and tonumber(idx)
        if idx then
            require("three").move_buffer(idx)
        end
    end)
end
local cmd = vim.cmd

local reach_options = {
    handle = "dynamic",
    show_current = true,
    sort = function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end,
}

-- Function to swap to the last buffer for this window.
local function swap_to_last_buffer()
    local last_buffer = vim.fn.bufnr("#")
    if last_buffer ~= -1 then
        vim.cmd("buffer " .. last_buffer)
    end
end

vim.api.nvim_create_user_command("ProjectDelete", function()
    require("three").remove_project()
end, {})

local config = {
    Buffer = {
        color = "red",
        body = leader_key,
        mode = { "n" },

        m = {
            function()
                cmd("ReachOpen marks")
            end,
            { nowait = true, exit = true, desc = "Reach Marks" },
        },
        W = {
            function()
                cmd("ReachOpen tabpages")
            end,
            { nowait = true, exit = true, desc = "Reach TabPage" },
        },
        C = {
            function()
                cmd("ReachOpen colorschemes")
            end,
            { nowait = true, exit = true, desc = "Reach Colour" },
        },
        L = {
            function()
                swap_to_last_buffer()
            end,
            { nowait = true, exit = true, desc = "Swap Last Buffer" },
        },

        n = {
            function()
                cmd("CybuNext")
            end,
            { nowait = true, exit = false, desc = "CybuNext" },
        },
        N = {
            function()
                cmd("CybuPrev")
            end,
            { nowait = true, exit = false, desc = "CybuPrev" },
        },

        k = {
            function()
                cmd("CybuLastusedPrev")
            end,
            { nowait = true, exit = false, desc = "CybuLastusedPrev" },
        },
        j = {
            function()
                cmd("CybuLastusedNext")
            end,
            { nowait = true, exit = false, desc = "CybuLastusedNext" },
        },
        w = {
            function()
                require("reach").buffers(reach_options)
            end,
            { nowait = true, exit = false, desc = "Reach" },
        },

        b = {
            function()
                require("utils.telescope").buffers()
            end,
            { desc = "Buffers", exit = true },
        },
        l = {
            function()
                if lambda.config.buffer.use_bufferline then
                    vim.cmd("BufferLineCycleNext")
                end
            end,

            { desc = "Next Buffers", exit = false },
        },
        h = {
            function()
                if lambda.config.buffer.use_bufferline then
                    vim.cmd("BufferLineCyclePrev")
                end
            end,

            { desc = "Prev Buffers", exit = false },
        },

        J = {
            function()
                --  TODO: (vsedov) (09:58:27 - 03/03/24): remove
                require("three").next()
            end,

            { desc = "[G]oto next [B]uffer", exit = false },
        },
        K = {
            function()
                --  TODO: (vsedov) (09:58:31 - 03/03/24): Remove
                require("three").prev()
            end,

            { desc = "[G]oto Prev [B]uffer", exit = false },
        },

        q = {
            function()
                --  TODO: (vsedov) (09:58:42 - 03/03/24): Remove
                require("three").smart_close()
            end,
            { desc = "[C]lose Smart", exit = true },
        },
        Q = {
            function()
                --  TODO: (vsedov) (09:58:49 - 03/03/24): Remove
                require("three").close_buffer()
            end,
            { desc = "[B]uffer [C]lose", exit = true },
        },
        M = {
            function()
                --  TODO: (vsedov) (09:58:52 - 03/03/24): Remove
                require("three").hide_buffer()
            end,
            { desc = "[B]uffer [H]ide", exit = true },
        },

        P = {
            function()
                --  TODO: (vsedov) (09:58:56 - 03/03/24): remove
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
            end,
            { desc = "Buf Wipe", exit = true },
        },

        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        a = {
            function()
                -- require("hbac").toggle_pin()
                local options = {
                    t = function()
                        require("hbac").toggle_pin()
                    end,
                    c = function()
                        require("hbac").close_unpinned()
                    end,
                    P = function()
                        require("hbac").pin_all()
                    end,
                    U = function()
                        require("hbac").unpin_all()
                    end,
                    T = function()
                        require("hbac").toggle_autoclose()
                    end,
                }

                -- require("hbac").toggle_pin()
                local list = {
                    t = "Toggle Pin",
                    c = "Close Unpinned",
                    P = "Pin All",
                    U = "Unpin All",
                    T = "Toggle Autoclose",
                }

                vim.ui.select(vim.tbl_keys(list), {
                    prompt = "Hbac",
                    format_item = function(item)
                        return "Bind: " .. item .. " - " .. list[item]
                    end,
                }, function(choice)
                    -- options[choice]()

                    if options[choice] then
                        options[choice]()
                    end
                end)
            end,
            { desc = "Hbac binds ", exit = true },
        },
    },
}

return {
    config,
    "Buffer",
    {
        { "w", "m", "C", "W", "L" },
        { "l", "h", "J", "K", "=", "+", "b", "<cr>" }, -- 9
        { "P", "q", "Q", "M" }, -- 4
        { "e", ">", "<" },
        { "p", "c", "D", "d" }, -- 2
        { "1", "2", "3", "a" }, -- 4
    },
    { "j", "k", "n", "N" },
    6,
    4,
    1,
}
