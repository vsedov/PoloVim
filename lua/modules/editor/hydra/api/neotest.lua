local leader = ";q"
local docs = { "<cr>", "l", "W", "r", "S", "J", "K" }
local analyse = { "s", "o", "O", "a" }
local summary = { "M", "R", "C" }
local python = { "q", "t", "e" }
local another_test = { "f", "v" }

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

local binds = {
    { "jump next", "J", { exit = false } },
    { "jump prev", "K", { exit = false } },
    { "output-panel toggle", "O" },
    { "stop", "S" },

    { "run file", "W" },
    { "run last", "l" },
    { "Sum toggle", "s" },

    { "Sum mark toggle", "M" },
    { "Sum mark run", "R" },
    { "Sum mark clear", "C" },
}

local config = {
    {
        Neotest = {
            color = "pink",
            position = "bottom-right",
            body = leader,
            -- on_enter = function()
            --     if require("dap").session() == nil then
            --         require("dapui").open()
            --     end
            -- end,

            ["<ESC>"] = { nil, { exit = true } },

            r = {
                function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                { nowait = false, exit = false, desc = "Run Dap" },
            },
            ["<cr>"] = {
                function()
                    require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
                end,
                { nowait = false, exit = false, desc = "Run File Dap" },
            },
            o = {
                function()
                    require("neotest").output.open({ short = true })
                end,
                { nowait = false, exit = false, desc = "Test Output" },
            },

            --
            a = {
                function()
                    for _, adapter_id in ipairs(require("neotest").run.adapters()) do
                        require("neotest").run.run({ suite = true, adapter = adapter_id })
                    end
                end,
                { nowait = false, exit = false, desc = "Test Rune Adapters" },
            },

            f = {
                function()
                    vim.cmd([[TestFile]])
                end,
                { nowait = false, exit = true, desc = "TestFile" },
            },
            v = {
                function()
                    vim.cmd([[TestVisit]])
                end,
                { nowait = false, exit = true, desc = "TestVisit" },
            },

            t = {
                function()
                    test_method()
                end,
                { nowait = false, exit = false, desc = "Python TestMethod" },
            },

            q = {
                function()
                    test_class()
                end,
                { nowait = false, exit = false, desc = "Python TestClass" },
            },
            e = {
                function()
                    debug_selection()
                end,
                { nowait = false, exit = false, desc = "Python Selection" },
            },
        },
    },
    "Neotest",
    { docs, analyse, summary, python },
    another_test,
    6,
    4,
    2,
}

for _, bind in ipairs(binds) do
    local cmd = bind[1]
    local key = bind[2]
    local options = bind[3] or {}
    if options.exit == nil then
        options.exit = true
    end
    config[1].Neotest[key] = {
        function()
            require("neotest").run.run({ strategy = "dap", cmd = cmd })
        end,
        { nowait = false, exit = options.exit, desc = cmd },
    }
end

return config
