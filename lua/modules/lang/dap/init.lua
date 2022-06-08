local api = vim.api
local M = {}
local HOME = os.getenv("HOME")
local loader = require("packer").loader

local bind = require("keymap.bind")
local map_cr = bind.map_cr

M.setup = function()
    local fn = vim.fn
    local function repl_toggle()
        require("dap").repl.toggle(nil, "botright split")
    end
    local function continue()
        require("dap").continue()
    end
    local function step_out()
        require("dap").step_out()
    end
    local function step_into()
        require("dap").step_into()
    end
    local function step_over()
        require("dap").step_over()
    end
    local function run_last()
        require("dap").run_last()
    end
    local function toggle_breakpoint()
        require("dap").toggle_breakpoint()
    end
    local function set_breakpoint()
        require("dap").set_breakpoint(fn.input("Breakpoint condition: "))
    end
    require("which-key").register({
        d = {
            name = "+debugger",
            b = { toggle_breakpoint, "dap: toggle breakpoint" },
            B = { set_breakpoint, "dap: set breakpoint" },
            c = { continue, "dap: continue or start debugging" },
            e = { step_out, "dap: step out" },
            i = { step_into, "dap: step into" },
            o = { step_over, "dap: step over" },
            l = { run_last, "dap REPL: run last" },
            t = { repl_toggle, "dap REPL: toggle" },
        },
    }, {
        prefix = "<localleader>",
    })
end

M.config = function()
    local dap = require("dap")
end

M.dapui = function()
    require("dapui").setup()

    vim.keymap.set("n", "<localleader>duc", function()
        require("dapui").close()
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<localleader>dut", function()
        require("dapui").toggle()
    end, { noremap = true, silent = true })

    local dap = require("dap")
    dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
    end
end

M.prepare = function()
    local ft = vim.bo.filetype

    loader("nvim-dap")
    loader("telescope-dap.nvim")
    loader("nvim-dap-ui")
    loader("nvim-dap-virtual-text")

    require("telescope").load_extension("dap")
    local ft_call = {
        ["python"] = function()
            loader("nvim-dap-python")
            require("dap-python").setup("/bin/python")
            require("dap-python").test_runner = "pytest"

            vim.keymap.set("n", "<localleader>dn", function()
                require("dap-python").test_method()
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<localleader>df", function()
                require("dap-python").test_class()
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<localleader>ds", function()
                require("dap-python").debug_selection()
            end, { noremap = true, silent = true })
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
