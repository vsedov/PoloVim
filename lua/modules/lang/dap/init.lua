local M = {}
local fn, icons = vim.fn, lambda.style.icons

M.config = function()
    require("dap")
    require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve" },
        automatic_installation = true,
        automatic_setup = true,
    })
    require("mason-nvim-dap")
    require("nvim-dap-virtual-text").setup()
    require("nvim-dap-repl-highlights").setup()
    M.keymaps()
    M.commands()
end

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
    vim.cmd([[command! Debug lua require"modules.lang.dap".StartDbg()]])
    vim.cmd([[command! StopDebug lua require"modules.lang.dap".StopDbg()]])
end

M.prepare = function()
    local loader = require("lazy").load

    loader({ plugins = { "nvim-dap", "nvim-dap-ui" } }) -- "nvim-dap-python"
    local dap = require("dap")

    require("dapui").setup({
        windows = { indent = 2 },
        floating = {
            border = lambda.style.border.type_0,
        },
    })

    local exclusions = { "dart" }
    dap.listeners.after.event_initialized["dapui_config"] = function()
        if vim.tbl_contains(exclusions, vim.bo.filetype) then
            return
        end
        require("dapui").open()
        vim.api.nvim_exec_autocmds("User", { pattern = "DapStarted" })
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
    end
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
