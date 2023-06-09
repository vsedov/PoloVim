local leader = "<leader>D"
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
        body = leader,
        ["<ESC>"] = { nil, { exit = true } },
        b = {
            function()
                require("persistent-breakpoints.api").toggle_breakpoint()
            end,
            { exit = false, silent = true, desc = "Toggle BP" },
        },
        B = {
            function()
                dap_uirun("float_element", "breakpoints")()
            end,
            { exit = false, silent = true, desc = "Float Break " },
        },

        C = {
            function()
                require("persistent-breakpoints.api").set_conditional_breakpoint()
            end,
            { exit = false, silent = true, desc = "Set BP with Cond" },
        },
        l = {
            function()
                require("persistent-breakpoints.api").clear_all_breakpoints()
            end,
            { exit = false, silent = true, desc = "Clear all BP" },
        },
        ["<cr>"] = {
            function()
                run("continue")()
            end,
            { exit = false, silent = true, desc = "Continue" },
        },
        c = {
            function()
                run("run_to_cursor")()
            end,
            { exit = false, silent = true, desc = "Run to Cursor" },
        },
        --
        o = {
            function()
                run("step_over")()
            end,
            { exit = false, silent = true, desc = "Step over" },
        },
        i = {
            function()
                run("step_into")()
            end,
            { exit = false, silent = true, desc = "Step into" },
        },
        O = {
            function()
                run("step_out")()
            end,
            { exit = false, silent = true, desc = "Step Out" },
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
            { exit = true, silent = true, desc = "Close" },
        },

        F = {
            function()
                require("dapui").close()
                vim.cmd([[DapVirtualTextForceRefresh]])
            end,
            { exit = true, silent = true, desc = "Close UI" },
        },

        k = {
            function()
                require("dap.ui.widgets").hover()
            end,
            { exit = true, silent = true, desc = "Hover" },
        },

        K = {
            dap_uirun("eval"),
            { exit = true, silent = true, desc = "Evaluate" },
        },

        S = {
            function()
                dap_uirun("float_element", "scopes")()
            end,
            { exit = true, silent = true, desc = "Float Scope" },
        },
        s = {
            function()
                dap_uirun("float_element", "stacks")()
            end,
            { exit = true, silent = true, desc = "Float Stack" },
        },
        w = {
            function()
                dap_uirun("float_element", "watches")()
            end,
            { exit = true, silent = true, desc = "Float Watches" },
        },
        r = {
            function()
                dap_uirun("float_element", "repl")()
            end,
            { exit = false, silent = true, desc = "Float repl" },
        },
    },
}

return {
    config,
    "Dap",
    {
        { "k", "K", "F" },
        { "o", "i", "O", "x", "X" },
        { "S", "s", "w", "r" },
    },
    { "b", "B", "C", "l", "<cr>", "c" },
    6,
    3,
}
