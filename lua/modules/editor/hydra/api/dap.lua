local function run(method, args)
    return function()
        local dap = require("dap")
        if dap[method] then
            dap[method](args)
        end
    end
end

local function dap_uirun(method, args)
    return function()
        local dapui = require("dapui") --
        if dapui[method] then
            dapui[method](args)
        end
    end
end

local config = {
    Dap = {
        color = "red",
        mode = { "n", "x" },
        body = "<localleader>b",
        ["<ESC>"] = { nil, { exit = true } },

        b = {
            function()
                require("dap").toggle_breakpoint()
                require("persistent-breakpoints.api").store_breakpoints(false)
            end,
            { silent = true, desc = "Toggle BP" },
        },
        B = {
            function()
                require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
                require("persistent-breakpoints.api").store_breakpoints(false)
            end,
            { silent = true, desc = "Set BP with Cond" },
        },
        l = {
            function()
                require("dap").clear_breakpoints()
                require("persistent-breakpoints.api").store_breakpoints(true)
            end,
            { silent = true, desc = "Clear all BP" },
        },
        C = {
            function()
                run("continue")()
            end,
            { silent = true, desc = "Continue" },
        },
        c = {
            function()
                run("function() run_to_cursor")()
            end,
            { silent = true, desc = "Run to Cursor" },
        },
        --
        n = {
            function()
                run("step_over")()
            end,
            { silent = true, desc = "Step over" },
        },
        i = {
            function()
                run("step_into")()
            end,
            { silent = true, desc = "Step into" },
        },
        o = {
            function()
                run("step_out")()
            end,
            { silent = true, desc = "Step Out" },
        },
        x = {
            function()
                run("disconnect", { terminateDebuggee = false })()
            end,
            { exit = true, silent = true, desc = "Leave" },
        },
        X = {
            function()
                run("close")()
            end,
            { silent = true, desc = "Close" },
        },

        F = {
            function()
                require("dapui").close()
                vim.cmd([[DapVirtualTextForceRefresh]])
            end,
            { silent = true, desc = "Close UI" },
        },

        k = {
            function()
                require("dap.ui.widgets").hover()
            end,
            { silent = true, desc = "Hover" },
        },

        K = {
            dap_uirun("eval"),
            { silent = true, desc = "Evaluate" },
        },
        z = {
            function()
                dap_uirun("float_element", "breakpoints")()
            end,
            { silent = true, desc = "Float Break " },
        },
        a = {
            function()
                dap_uirun("float_element", "scopes")()
            end,
            { silent = true, desc = "Float Scope" },
        },
        f = {
            function()
                dap_uirun("float_element", "stacks")()
            end,
            { silent = true, desc = "Float Stack" },
        },
        w = {
            function()
                dap_uirun("float_element", "watches")()
            end,
            { silent = true, desc = "Float Watches" },
        },
        r = {
            function()
                dap_uirun("float_element", "repl")()
            end,
            { silent = true, desc = "Float repl" },
        },
    },
}
return {
    config,
    "Dap",
    { { "k", "K", "F" }, { "n", "i", "o", "x", "X" }, { "z", "a", "f", "w", "r" } },
    { "b", "B", "l", "C", "c" },
    6,
    3,
}
