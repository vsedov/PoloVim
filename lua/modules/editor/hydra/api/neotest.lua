local leader = "<leader>u"

local bracket = { "<cr>", "s", "o" }

local function test_method()
    if vim.bo.filetype == "python" then
        require("dap-python").test_method()
    end
end
local function test_class()
    if vim.bo.filetype == "python" then
        require("dap-python").test_class()
    end
end
local function debug_selection()
    if vim.bo.filetype == "python" then
        require("dap-python").debug_selection()
    end
end

local exit = { nil, { exit = true, desc = "EXIT" } }

local config = {
    Test = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        ["<cr>"] = {
            function()
                vim.cmd([[TestCurrent]])
            end,
            { nowait = true, exit = false, desc = "Test Current" },
        },

        s = {
            function()
                vim.cmd([[TestSummary]])
            end,
            { nowait = false, exit = false, desc = "Test Sum" },
        },
        o = {
            function()
                vim.cmd([[TestOutput]])
            end,
            { nowait = false, exit = false, desc = "Test Output" },
        },
        d = {
            function()
                vim.cmd([[TestStrat dap]])
            end,
            { nowait = false, exit = false, desc = "Test dap" },
        },
        D = {
            function()
                vim.cmd([[TestStrat integrated]])
            end,
            { nowait = false, exit = false, desc = "Test integrated" },
        },

        S = {
            function()
                vim.cmd([[TestStop]])
            end,
            { nowait = false, exit = false, desc = "Test Stop" },
        },
        a = {
            function()
                vim.cmd([[TestAttach]])
            end,
            { nowait = false, exit = false, desc = "Test Attach" },
        },
        n = {
            function()
                vim.cmd([[TestNearest]])
            end,
            { nowait = false, exit = true, desc = "TestNearest" },
        },
        f = {
            function()
                vim.cmd([[TestFile]])
            end,
            { nowait = false, exit = true, desc = "TestFile" },
        },
        l = {
            function()
                vim.cmd([[TestLast]])
            end,
            { nowait = false, exit = true, desc = "TestLast" },
        },
        v = {
            function()
                vim.cmd([[TestVisit]])
            end,
            { nowait = false, exit = true, desc = "TestVisit" },
        },

        w = {
            function()
                test_method()
            end,
            { nowait = false, exit = true, desc = "TestMethod" },
        },

        W = {
            function()
                test_class()
            end,
            { nowait = false, exit = true, desc = "TestClass" },
        },
        [";"] = {
            function()
                debug_selection()
            end,
            { nowait = false, exit = true, desc = "Selection" },
        },
    },
}

return {
    config,
    "Test",
    { { "d", "D", "S", "a" }, { "n", "f", "l", "v" }, { "w", "W", ";" } },
    bracket,
    6,
    3,
}
