local M = {}
local fn, icons = vim.fn, lambda.style.icons

M.keymaps = function()
    vim.keymap.set("n", "]d", require("goto-breakpoints").next, {})
    vim.keymap.set("n", "[d", require("goto-breakpoints").prev, {})

    vim.keymap.set("n", "<localleader>duc", function()
        require("dapui").close()
    end, { desc = "dap-ui: close" })

    vim.keymap.set("n", "<localleader>dut", function()
        require("dapui").toggle()
    end, { desc = "dap-ui: toggle" })
end
M.commands = function()
    vim.cmd([[command! BPToggle lua require"dap".toggle_breakpoint()]])
    vim.cmd([[command! StopDebug lua require"modules.lang.dap".StopDbg()]])
end

M.prepare = function()
    lambda.debug = { layout = { ft = { python = 2 } } }
    local dap = require("dap")
    local ui_ok, dapui = pcall(require, "dapui")

    fn.sign_define({
        { name = "DapBreakpoint", texthl = "DapBreakpoint", text = icons.misc.bug, linehl = "", numhl = "" },
        { name = "DapStopped", texthl = "DapStopped", text = icons.misc.bookmark, linehl = "", numhl = "" },
    })
    if not ui_ok then
        return
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open(lambda.debug.layout.ft[vim.bo.ft])
    end
    require("dapui").open()
end

M.StopDbg = function()
    require("dap").disconnect()
    require("dap").stop()
    require("dap").repl.close()
    require("dapui").close()
end

M.config = function()
    require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve" },
        automatic_installation = true,
        automatic_setup = true,
    })
    M.keymaps()
    M.commands()
end

return M
