local Hydra = require("hydra")

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

local hint = [[
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                    BreakPoints                     ^^^^
  ^^^^                                                    ^^^^
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  _b_: Toggle BP                    _Bc_: cond set BP
  _BC_: clear BP                     _z_: float BP
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                      Debug                         ^^^^
  ^^^^                                                    ^^^^
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  _C_: Continue                         _c_: run to cursor

  _n_: step over                        _x_: exit debug
  _i_: step into                        _X_: Close
  _o_: step out                         _F_: Close Refresh
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  ^^^^                      Hover                         ^^^^
  ^^^^                                                    ^^^^
  ^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
  _K_: widget hover                     _w_: float watches
  _d_: dap eval                         _f_: float stacks
  _a_: float scope                      _r_: float repl

  _q_ exit

]]
-- automatically load breakpoints when a file is loaded into the buffer.
local dap_hydra = Hydra({
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = "rounded",
        },
    },
    name = "dap",
    mode = { "n", "x" },
    body = "<localleader>b",
    heads = {
        {
            "b",
            "<cmd>lua require('dap').toggle_breakpoint(); require('persistent-breakpoints.api').store_breakpoints(false)<cr>",
            { silent = true },
        },
        {
            "Bc",
            "<cmd>lua require('dap').set_breakpoint(vim.fn.input '[Condition] > '); require('persistent-breakpoints.api').store_breakpoints(false)<cr>",
            { silent = true },
        },
        {
            "BC",
            "<cmd>lua require('dap').clear_breakpoints(); require('persistent-breakpoints.api').store_breakpoints(true)<cr>",
            { silent = true },
        },

        { "C", run("continue"), { silent = true } },
        { "c", run("run_to_cursor"), { silent = true } },
        { "n", run("step_over"), { silent = true } },
        { "i", run("step_into"), { silent = true } },
        { "o", run("step_out"), { silent = true } },
        { "x", run("disconnect", { terminateDebuggee = false }), { exit = true, silent = true } },
        { "X", run("close"), { silent = true } },
        {
            "F",
            ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>",
            { silent = true },
        },
        { "K", ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },

        {
            "d",
            dap_uirun("eval"),
            { silent = true },
        },
        { "z", dap_uirun("float_element", "breakpoints"), { silent = true } },
        { "a", dap_uirun("float_element", "scopes"), { silent = true } },
        { "f", dap_uirun("float_element", "stacks"), { silent = true } },
        { "w", dap_uirun("float_element", "watches"), { silent = true } },
        { "r", dap_uirun("float_element", "repl"), { silent = true } },

        { "<Esc>", nil, { nowait = true, exit = true, desc = false } },
        { "q", nil, { exit = true, nowait = true } },
    },
})

lambda.augroup("HydraDap", {
    {
        event = "User",
        pattern = "DapStarted",
        command = function()
            vim.schedule(function()
                dap_hydra:activate()
            end)
        end,
    },
})
