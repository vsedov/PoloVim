local M = {}
local fn, icons = vim.fn, lambda.style.icons

M.config = function() end

M.prepare = function()
    local loader = require("lazy").load

    loader({ plugins = { "nvim-dap", "nvim-dap-ui", "nvim-dap-python" } })

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    require("dap-python").setup()
    require("dap-python").resolve_python = function()
        return vim.fn.system("which python")
    end

    require("dap-python").test_runner = "pytest"

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
