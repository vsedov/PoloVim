local leader = "<leader>d"
local docs = { "<cr>", "l", "W", "r", "S" }
local bracket = { "d", "L", ";", "i", "p", "D" }
local jump = { "J", "K" }
local analyse = { "s", "o", "O", "a" }
local summary = { "M", "R", "C" }
local python = { "q", "w", "e" }
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
    { "summary toggle", "s" },

    { "summary mark toggle", "M" },
    { "summary mark run", "R" },
    { "summary mark clear", "C" },
}
local config = {
    Test = {
        color = "pink",
        body = leader,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        -- Neogen stuff
        d = {
            function()
                require("neogen").generate()
            end,
            { nowait = true, silent = true, desc = "Gen Doc ", exit = true },
        },
        L = {
            function()
                require("neogen").generate({ type = "class" })
            end,
            { nowait = true, silent = true, desc = "Gen class ", exit = true },
        },
        [";"] = {
            function()
                require("neogen").generate({ type = "type" })
            end,
            { nowait = true, silent = true, desc = "Gen type ", exit = false },
        },

        -- Reference Stuff
        i = {
            function()
                vim.cmd("RefCopy")
            end,
            { nowait = true, silent = true, desc = "refCopy ", exit = true },
        },
        p = {

            function()
                vim.cmd("RefGo")
            end,
            { nowait = true, silent = true, desc = "RefGo ", exit = true },
        },
        -- Documentation types ?
        D = {
            function()
                vim.cmd("DocsViewToggle")
            end,
            { nowait = true, silent = true, desc = "Live Docs ", exit = true },
        },

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

        w = {
            function()
                test_method()
            end,
            { nowait = false, exit = true, desc = "Python TestMethod" },
        },

        q = {
            function()
                test_class()
            end,
            { nowait = false, exit = true, desc = "Python TestClass" },
        },
        e = {
            function()
                debug_selection()
            end,
            { nowait = false, exit = true, desc = "Python Selection" },
        },
    },
}
--

for _, bind in ipairs(binds) do
    local cmd = bind[1]
    local key = bind[2]
    local options = bind[3] or {}
    if options.exit == nil then
        options.exit = true
    end
    config.Test[key] = {
        function()
            vim.cmd("Neotest " .. cmd)
        end,
        { nowait = false, exit = options.exit, desc = cmd },
    }
end

return {
    config,
    "Test",
    { docs, analyse, jump, summary, another_test, python },
    bracket,
    6,
    4,
}
