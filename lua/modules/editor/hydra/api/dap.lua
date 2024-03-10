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
        body = "<leader>D",
        ["<ESC>"] = { nil, { exit = true } },
        on_enter = function()
            if require("dap").session() == nil then
                require("dapui").open()
            end
        end,
        ["<tab>"] = {
            function()
                require("dapui").toggle()
            end,
            { exit = false, silent = true, desc = "Toggle DAPUI" },
        },

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
            {
                exit = false,
                private = true,
                silent = true,
                desc = "Float Break ",
            },
        },

        C = {
            function()
                require("persistent-breakpoints.api").set_conditional_breakpoint()
            end,
            {
                exit = false,
                private = true,
                silent = true,
                desc = "Set BP with Cond",
            },
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
            {
                exit = true,
                private = true,
                silent = true,
                desc = "Continue",
            },
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
            {
                exit = false,
                private = true,
                silent = true,
                desc = "Step into",
            },
        },
        O = {
            function()
                run("step_out")()
            end,
            {
                exit = false,
                private = true,
                silent = true,
                desc = "Step Out",
            },
        },
        X = {
            function()
                run("disconnect", { terminateDebuggee = false })()
            end,
            { exit = true, silent = true, desc = "Leave" },
        },
        x = {
            function()
                require("dap").close()
                require("dap").close()
                require("dapui").close()
                vim.cmd([[DapVirtualTextForceRefresh]])
            end,
            { exit = true, silent = true, desc = "Close" },
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
        L = {
            function()
                local filetype = vim.api.nvim_buf_get_option(0, "filetype")
                local dap = require("dap")
                if filetype == "" then
                    filetype = "nil"
                end
                if dap and dap.launch_server and dap.launch_server[filetype] then
                    dap.launch_server[filetype]()
                else
                    vim.notify(
                        string.format("No DAP Launch server configured for filetype %s", filetype),
                        vim.log.levels.WARN
                    )
                end
            end,
            {
                desc = "Launch DAP server",
                exit = false,
                private = true,
                silent = true,
            },
        },
    },
}

return {
    config,
    "Dap",
    {
        { "k", "K", "x", "X" }, -- 4
        { "o", "i", "O", "L" }, -- 3
        { "S", "s", "w", "r" }, -- 4
    },
    { "<tab>", "b", "B", "C", "l", "<cr>", "c" }, -- 8
    6,
    6,
    1,
}
