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
    lambda.command("StartDebug", function()
        require("dapui").open()
    end, {})
    lambda.command("DebugStop", function()
        M.StopDbg()
    end, {})
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
end

M.StopDbg = function()
    require("dap").close()
end

M.config = function()
    local dap = require("dap")
    require("mason-nvim-dap").setup({
        ensure_installed = { "stylua", "jq" },
        handlers = {
            function(config)
                -- all sources with no handler get passed here

                -- Keep original functionality
                require("mason-nvim-dap").default_setup(config)
            end,
            python = function(config)
                config.adapters = {
                    type = "executable",
                    -- command = "/usr/bin/python3",
                    command = vim.fn.exepath("python"),
                    args = {
                        "-m",
                        "debugpy.adapter",
                    },
                }
                require("mason-nvim-dap").default_setup(config) -- don't forget this!
            end,
        },
    })
    M.keymaps()
    M.commands()
    M.prepare()
    local dap_python = require("dap-python")
    dap_python.setup("python", {
        -- So if configured correctly, this will open up new terminal.
        --    Could probably get this to target a particular terminal
        --    and/or add a tab to kitty or something like that as well.
        console = "externalTerminal",

        include_configs = true,
    })

    dap_python.test_runner = "pytest"
end

return M
