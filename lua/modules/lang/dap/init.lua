local M = {}
local loader = require("packer").loader
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local wk = require("which-key")
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
end

M.prepare = function()
    loader("nvim-dap")
    loader("nvim-dap-ui")
    local ft_call = {
        ["python"] = function()
            loader("nvim-dap-python")
            require("dap-python").setup(vim.fn.system("which python"))

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
            wk.register({
                d = {
                    name = "+debugger",
                    ff = { test_class, "python test class" },
                    n = { test_method, "python test method" },
                    s = { debug_selection, "python debug_selection" },
                },
            }, {
                prefix = "<localleader>",
            })

            -- require("modules.lang.dap.py")
        end,

        ["lua"] = function()
            local keys = {
                ["n|<F5>"] = map_cr('<cmd>lua require"osv".launch()'):with_noremap():with_silent(),
                ["n|<F4>"] = map_cr('<cmd>lua require"dap".continue()'):with_noremap():with_silent(),
            }
            bind.nvim_load_mapping(keys)
            require("modules.lang.dap.lua")
        end,

        ["typescript"] = function()
            vim.notify("debug prepare for js")
            vim.cmd([[command! -nargs=*  DebugTest lua require"modules.lang.dap.jest".run(<f-args>)]])
            require("modules.lang.dap.js")
        end,

        ["rust"] = function()
            require("modules.lang.dap.rust")
        end,
    }

    local filetype = vim.bo.filetype
    ft_call[filetype]()

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
