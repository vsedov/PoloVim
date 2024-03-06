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

        { desc = "Next Buffers", exit = false },
    },
    h = {
        function()
            vim.cmd("BufferLineCyclePrev")
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
}

local tabline_commands = {
    h = {
        function()
            vim.cmd("BufferNext")
        end,
        { desc = "Move Next", exit = false },
    },
    l = {
        function()
            vim.cmd("BufferPrevious")
        end,
        { desc = "Move Prev", exit = false },
    },

    ["<leader>"] = {
        function()
            vim.cmd("BufferPick")
        end,
        { desc = "Pick buffer" },
    },
    c = {
        function()
            list = {
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
        { desc = "Close Buffers", exit = true },
    },
    r = {
        function()
            vim.cmd([[BufferRestore]])
        end,
        { desc = "Restore Buffer", exit = true },
    },

    K = {
        function()
            vim.cmd("BufferMoveNext")
        end,
        { desc = "Move Next", exit = false },
    },
    J = {
        function()
            vim.cmd("BufferMovePrevious")
        end,
        { desc = "Move Prev", exit = false },
    },

    D = {
        function()
            vim.cmd("BufferClose")
        end,
        { desc = "Close Buf", exit = false },
    },
    p = {
        function()
            vim.cmd("BufferPin")
        end,
        { desc = "Pin Buf" },
    },

    ["1"] = {
        function()
            vim.cmd("BufferOrderByBufferNumber")
        end,
        { desc = "Sort By Number" },
    },
    ["2"] = {
        function()
            vim.cmd("BufferOrderByDirectory")
        end,
        { desc = "Sort Dir" },
        -- { desc = "Sort dir", exit = true },
    },
    ["3"] = {
        function()
            vim.cmd("BufferOrderByLanguage")
        end,
        { desc = "Sort Lang" },
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
        ["<tab>"] = {
            function() end,
            { desc = "Tab", exit = true },
        },
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
    { "e", ">", "<", "a" },
}
local Tab = {
    {
        Tab = {
            color = "blue",
            mode = { "n" },
            n = {
                function()
                    vim.cmd("tabnew")
                end,
                { desc = "New tab", exit = true },
            },
            c = {
                function()
                    vim.cmd("tabclose")
                end,
                { desc = "Close tab", exit = true },
            },
            C = {
                function()
                    vim.ui.input({ prompt = "Close tab:", default = "1" }, function(idx)
                        idx = idx and tonumber(idx)
                        if idx then
                            vim.cmd("tabclose " .. idx)
                        end
                    end)
                end,
                { desc = "Close tab", exit = true },
            },
            l = {
                function()
                    vim.cmd("tabnext")
                end,
                { desc = "Next tab", exit = false },
            },
            h = {
                function()
                    vim.cmd("tabprev")
                end,
                { desc = "Previous tab", exit = false },
            },
            f = {
                function()
                    vim.cmd("tabfirst")
                end,
                { desc = "First tab", exit = false },
            },
            L = {
                function()
                    vim.cmd("tablast")
                end,
                { desc = "Last tab", exit = false },
            },
            m = {
                function()
                    vim.ui.input({ prompt = "Move tab to:" }, function(idx)
                        idx = idx and tonumber(idx)
                        if idx then
                            vim.cmd("tabmove " .. idx)
                        end
                    end)
                end,
                { desc = "Move tab", exit = true },
            },
            ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        },
    },

    "Tab",
    {
        { "f", "L", "m" },
    },
    { "n", "C", "c", "l", "h" },
    6,
    3,
}

return {
    config,
    "Buffer",
    tables,
    { "j", "k", "n", "N" },
    6,
    4,
    1,
    { Tab },
}
