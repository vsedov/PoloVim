local api = vim.api
local M = {}
local HOME = os.getenv("HOME")
local loader = require("packer").loader

local bind = require("keymap.bind")
local map_cr = bind.map_cr
local wk = require("which-key")
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

    local function up()
        require("dap").up()
    end
    local function down()
        require("dap").down()
    end

    local function run_to_cursor()
        require("dap").run_to_cursor()
    end

    wk.register({
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
            c = { run_to_cursor, "dap: To cursor" },
            uu = { up, "dap Up: up" },
            ud = { down, "dap down: down" },
        },
    }, {
        prefix = "<localleader>",
    })
end

M.config = function()
    local dap = require("dap")

    vim.fn.sign_define("DapBreakpoint", { text = "⧐", texthl = "Error", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "⧐", texthl = "Success", linehl = "", numhl = "" })
end

M.dapui = function()
    require("dapui").setup()

    local function eval()
        require("dapui").eval()
    end

    local function dap_ui_toggle()
        require("dapui").toggle()
    end

    local function dap_ui_close()
        require("dapui").close()
    end

    local function float_element()
        require("dapui").eval()
    end
    local function float_breakpoint()
        require("dapui").float_element("breakpoints")
    end
    local function float_repl()
        require("dapui").float_element("repl")
    end
    local function float_scopes()
        require("dapui").float_element("scopes")
    end
    local function float_stacks()
        require("dapui").float_element("stacks")
    end
    local function float_watches()
        require("dapui").float_element("watches")
    end
    wk.register({
        d = {
            name = "+debugger",
            d = { float_element, "dap ui: evaluate item" },
            z = { float_breakpoint, "dap ui: float breakpoint" },
            r = { float_repl, "dap ui: float repl" },
            a = { float_scopes, "dap ui: float scopes" },
            f = { float_stacks, "dap ui: float stacks" },
            w = { float_watches, "dap ui: float watches" },
            ut = { dap_ui_close, "dap ui: ui close" },
            ux = { dap_ui_toggle, "dap ui: ui toggle" },
        },
    }, {
        prefix = "<localleader>",
    })

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

M.prepare = function()
    loader("nvim-dap")
    loader("nvim-dap-ui")
    local ft_call = {
        ["python"] = function()
            loader("nvim-dap-python")
            require("dap-python").setup("/bin/python3")
            -- require("dap-python").setup("/home/viv/.cache/pypoetry/virtualenvs/neorgbot-aidSKrkk-py3.10/bin/python")

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
