local M = {}
local loader = require("lazy").load
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local fn, icons = vim.fn, lambda.style.icons

M.config = function()
    require("utils.ui.highlights").plugin("dap", {
        { DapBreakpoint = { foreground = lambda.style.palette.light_red } },
        { DapStopped = { foreground = lambda.style.palette.green } },
    })

    fn.sign_define({
        {
            name = "DapBreakpoint",
            text = icons.misc.bug,
            texthl = "DapBreakpoint",
            linehl = "",
            numhl = "",
        },
        {
            name = "DapStopped",
            text = icons.misc.bookmark,
            texthl = "DapStopped",
            linehl = "",
            numhl = "",
        },
    })
end

M.dapui = function()
    local dap, dapui = require("dap"), require("dapui")

    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
end

M.prepare = function()
    loader("nvim-dap")
    loader("nvim-dap-ui")
    loader("nvim-dap-python")
    require("dap-python").setup()
    require("dap-python").resolve_python = function()
        return vim.fn.system("which python")
    end
    require("dap-python").test_runner = "pytest"

    local function test_method()
        require("dap-python").test_method()
    end
    local function test_class()
        require("dap-python").test_class()
    end
    local function debug_selection()
        require("dap-python").debug_selection()
    end
    local wk = require("which-key")

    wk.register({
        D = {
            name = "+debugger",
            ff = { test_class, "python test class" },
            n = { test_method, "python test method" },
            s = { debug_selection, "python debug_selection" },
        },
    }, {
        prefix = ";",
    })

    vim.cmd([[command! BPToggle lua require"dap".toggle_breakpoint()]])
    vim.cmd([[command! Debug lua require"modules.lang.dap".StartDbg()]])
    vim.cmd([[command! StopDebug lua require"modules.lang.dap".StopDbg()]])
    require("dapui").open()
end

M.StartDbg = function()
    require("dap").continue()
end

M.StopDbg = function()
    require("dap").disconnect()
    require("dap").stop()
    require("dap").repl.close()
    require("dapui").close()
end

return M
