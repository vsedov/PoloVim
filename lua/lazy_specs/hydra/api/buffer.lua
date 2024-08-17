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

local bufferline_commands = {
    l = {
        function()
            vim.cmd("BufferLineCycleNext")
        end,

        { private = true, nowait = true, desc = "Next Buffers", exit = false },
    },
    h = {
        function()
            vim.cmd("BufferLineCyclePrev")
        end,

        { private = true, nowait = true, desc = "Prev Buffers", exit = false },
    },

    J = {
        function()
            --  TODO: (vsedov) (09:58:27 - 03/03/24): remove
            require("three").next()
        end,

        { private = true, nowait = true, desc = "[G]oto next [B]uffer", exit = false },
    },
    K = {
        function()
            --  TODO: (vsedov) (09:58:31 - 03/03/24): Remove
            require("three").prev()
        end,

        { private = true, nowait = true, desc = "[G]oto Prev [B]uffer", exit = false },
    },

    q = {
        function()
            --  TODO: (vsedov) (09:58:42 - 03/03/24): Remove
            require("three").smart_close()
        end,
        { private = true, nowait = true, desc = "[C]lose Smart", exit = true },
    },
    Q = {
        function()
            --  TODO: (vsedov) (09:58:49 - 03/03/24): Remove
            require("three").close_buffer()
        end,
        { private = true, nowait = true, desc = "[B]uffer [C]lose", exit = true },
    },
    M = {
        function()
            --  TODO: (vsedov) (09:58:52 - 03/03/24): Remove
            require("three").hide_buffer()
        end,
        { private = true, nowait = true, desc = "[B]uffer [H]ide", exit = true },
    },

    P = {
        function()
            --  TODO: (vsedov) (09:58:56 - 03/03/24): remove
            require("three").open_project()
        end,
        { private = true, nowait = true, desc = "Three Project", exit = true },
    },

    c = {
        function()
            vim.cmd("BufferLinePick")
        end,
        { private = true, nowait = true, desc = "Pick buffer" },
    },
    ["+"] = {
        function()
            vim.cmd("BufferLineMoveNext")
        end,
        { private = true, nowait = true, desc = "Move Next", exit = false },
    },
    ["="] = {
        function()
            vim.cmd("BufferLineMovePrev")
        end,
        { private = true, nowait = true, desc = "Move Prev", exit = false },
    },
    D = {
        function()
            vim.cmd("BufferLinePickClose")
        end,
        { private = true, nowait = true, desc = "Close Buf", exit = false },
    },
    p = {
        function()
            vim.cmd("BufferLineTogglePin")
        end,
        { private = true, nowait = true, desc = "Pin Buf" },
    },

    ["1"] = {
        function()
            vim.cmd("BufferLineSortByTabs")
        end,
        { private = true, nowait = true, desc = "Sort Tabs" },
    },
    ["2"] = {
        function()
            vim.cmd("BufferLineSortByDirectory")
        end,
        { private = true, nowait = true, desc = "Sort Dir" },
        -- { private = true, nowait = true, desc = "Sort dir", exit = true },
    },
    ["3"] = {
        function()
            vim.cmd("BufferLineSortByRelativeDirectory")
        end,
        { private = true, nowait = true, desc = "Sort RDir" },
    },
}

local tabline_commands = {
    h = {
        function()
            vim.cmd("BufferPrevious")
        end,
        { private = true, nowait = true, desc = "Move Prev", exit = false },
    },
    l = {
        function()
            vim.cmd("BufferNext")
        end,
        { private = true, nowait = true, desc = "Move Next", exit = false },
    },

    ["<leader>"] = {
        function()
            vim.cmd("BufferPick")
        end,
        { private = true, nowait = true, desc = "Pick buffer" },
    },
    c = {
        function()
            local list = {
                a = "All But Current",
                v = "All But Visible",
                p = "All But Pinned",
                c = "All But Current Or Pinned",
                l = "Buffers Left",
                r = "Buffers Right",
            }

            vim.ui.select(vim.tbl_keys(list), {
                prompt = "Close Buffers",
                format_item = function(item)
                    return "Bind: " .. item .. " - " .. list[item]
                end,
            }, function(choice)
                if choice == "a" then
                    vim.cmd("BufferCloseAllButCurrent")
                elseif choice == "v" then
                    vim.cmd("BufferCloseAllButVisible")
                elseif choice == "p" then
                    vim.cmd("BufferCloseAllButPinned")
                elseif choice == "c" then
                    vim.cmd("BufferCloseAllButCurrentOrPinned")
                elseif choice == "l" then
                    vim.cmd("BufferCloseBuffersLeft")
                elseif choice == "r" then
                    vim.cmd("BufferCloseBuffersRight")
                end
            end)
        end,
        { private = true, nowait = true, desc = "Close Buffers", exit = true },
    },
    r = {
        function()
            vim.cmd([[BufferRestore]])
        end,
        { private = true, nowait = true, desc = "Restore Buffer", exit = true },
    },

    K = {
        function()
            vim.cmd("BufferMoveNext")
        end,
        { private = true, nowait = true, desc = "Move Next", exit = false },
    },
    J = {
        function()
            vim.cmd("BufferMovePrevious")
        end,
        { private = true, nowait = true, desc = "Move Prev", exit = false },
    },

    D = {
        function()
            vim.cmd("BufferClose")
        end,
        { private = true, nowait = true, desc = "Close Buf", exit = false },
    },
    p = {
        function()
            vim.cmd("BufferPin")
        end,
        { private = true, nowait = true, desc = "Pin Buf" },
    },

    ["1"] = {
        function()
            vim.cmd("BufferOrderByBufferNumber")
        end,
        { private = true, nowait = true, desc = "Sort By Number" },
    },
    ["2"] = {
        function()
            vim.cmd("BufferOrderByDirectory")
        end,
        { private = true, nowait = true, desc = "Sort Dir" },
        -- { private = true, nowait = true, desc = "Sort dir", exit = true },
    },
    ["3"] = {
        function()
            vim.cmd("BufferOrderByLanguage")
        end,
        { private = true, nowait = true, desc = "Sort Lang" },
    },
}

local bufferline = {}
if lambda.config.buffer.use_bufferline then
    bufferline = { "l", "h", "J", "K", "q", "Q", "M", "P", "c", "+", "=", "D", "p", "1", "2", "3" }
else
    bufferline = {

        { "h", "l", "J", "K" },
        { "r", "p", "c", "D" },
        { "1", "2", "3", "<leader>" },
    }
end

local config = {
    Buffer = {
        color = "red",
        body = leader_key,
        mode = { "n" },

        m = {
            function()
                cmd("ReachOpen marks")
            end,
            { exit = true, private = true, nowait = true, desc = "Reach Marks" },
        },
        W = {
            function()
                cmd("ReachOpen tabpages")
            end,
            { exit = true, private = true, nowait = true, desc = "Reach TabPage" },
        },
        C = {
            function()
                cmd("ReachOpen colorschemes")
            end,
            { exit = true, private = true, nowait = true, desc = "Reach Colour" },
        },
        L = {
            function()
                swap_to_last_buffer()
            end,
            { exit = true, private = true, nowait = true, desc = "Swap Last Buffer" },
        },

        n = {
            function()
                cmd("CybuNext")
            end,
            { exit = false, private = true, nowait = true, desc = "CybuNext" },
        },
        N = {
            function()
                cmd("CybuPrev")
            end,
            { exit = false, private = true, nowait = true, desc = "CybuPrev" },
        },

        w = {
            function()
                require("reach").buffers(reach_options)
            end,
            { exit = false, private = true, nowait = true, desc = "Reach" },
        },

        b = {
            function()
                require("utils.telescope").buffers()
            end,
            { private = true, nowait = true, desc = "Buffers", exit = true },
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
            { private = true, nowait = true, desc = "BufExplorer", exit = true },
        },

        [">"] = {
            function()
                vim.cmd("BufExplorerVerticalSplit")
            end,

            { private = true, nowait = true, desc = "Explore Vertical", exit = true },
        },

        ["<"] = {
            function()
                vim.cmd("BufExplorerHorizontalSplit")
            end,

            { private = true, nowait = true, desc = "Explore Horizontal", exit = true },
        },

        d = {
            function()
                require("bufdelete").bufdelete(0, true)
            end,
            { private = true, nowait = true, desc = "Killthis", exit = true },
        },
        ["<cr>"] = {
            function()
                vim.cmd("BufOnly")
            end,
            { private = true, nowait = true, desc = "Buf Wipe", exit = true },
        },

        ["<ESC>"] = { nil, { private = true, nowait = true, desc = "Exit", exit = true } },
    },
}

if lambda.config.buffer.use_bufferline then
    for k, v in pairs(bufferline_commands) do
        config.Buffer[k] = v
    end
else
    for k, v in pairs(tabline_commands) do
        config.Buffer[k] = v
    end
end
local tables = {
    { "w", "m", "C", "W", "L", "d", "b", "<cr>" },
    -- vim.tbl_flatten(bufferline),
    -- add each table inside buffelirne here so {{x}, {y}} tables x and y are added we are not
    -- adding the item x y but the table of x and y
    bufferline[1],
    bufferline[2],
    bufferline[3],

    { "q", "Q", "M" }, -- 4
    { "e", ">", "<" },
}

return {
    config,
    "Buffer",
    tables,
    { "n", "N" },
    6,
    4,
    1,
}
