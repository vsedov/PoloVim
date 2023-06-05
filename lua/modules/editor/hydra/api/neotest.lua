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
                require("neotest").run.run({ vim.api.nvim_buf_get_name(0) })
            end,
            { nowait = true, exit = false, desc = "Test Current" },
        },

        s = {
            function()
                require("neotest").summary.toggle()
            end,
            { nowait = false, exit = false, desc = "Test Sum" },
        },
        o = {
            function()
                require("neotest").output.open({ short = true })
            end,
            { nowait = false, exit = false, desc = "Test Output" },
        },

        d = {
            function()
                require("neotest").run.run({ strategy = "dap" })
            end,
            { nowait = false, exit = false, desc = "Test dap" },
        },
        D = {
            function()
                require("neotest").run.run({ strategy = "integrated" })
            end,
            { nowait = false, exit = false, desc = "Test integrated" },
        },

        S = {
            function()
                require("neotest").run.stop()
            end,
            { nowait = false, exit = false, desc = "Test Stop" },
        },
        a = {
            function()
                for _, adapter_id in ipairs(require("neotest").run.adapters()) do
                    require("neotest").run.run({ suite = true, adapter = adapter_id })
                end
            end,
            { nowait = false, exit = false, desc = "Test Rune Adapters" },
        },

        r = {
            function()
                require("neotest").run.run()
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
                require("neotest").run.run_last()
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
    { { "d", "D", "S", "a" }, { "r", "f", "l", "v" }, { "w", "W", ";" } },
    bracket,
    6,
    3,
}
