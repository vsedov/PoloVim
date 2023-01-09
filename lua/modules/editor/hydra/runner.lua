local Hydra = require("hydra")
local match = lambda.lib.match
local when = lambda.lib.when
local cmd = require("hydra.keymap-util").cmd

local hint = [[
^ ^ _r_: Run Code   ^ ^
^ ^ _s_: Stop Code  ^ ^
^ ^ _p_: Pannel     ^ ^
]]
Hydra({
    name = "Runner",
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n" },
    body = "<localleader>r",
    heads = {
        { "r", cmd("Lab code run"), { exit = false } },
        { "s", cmd("Lab code stop"), { exit = false } },
        { "p", cmd("Lab code panel"), { exit = false } },
        { "<Esc>", nil, { exit = true, desc = false } },
    },
})
--- @usage : Run :cd or <leader>cd -> <leader>r
---@param debug Debug is idk , idk why i have this here tbh
local run_or_test = function(debug)
    local ft = vim.bo.filetype
    -- t([[<cmd>tcd %:p:h<cr><cmd>pwd<cr>]])
    if ft == "lua" then
        return ":RunCode<CR>"
    else
        local m = vim.fn.mode()
        if m == "n" or m == "i" then
            cmd("Lab code run")
        else
            require("sniprun").run("v")
        end
    end
end

hint = [[
^^^^                  Overseer                  ^^^^
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_w_: OverseerToggle          _e_: OverseerRun
_d_: OverseerQuickAction     _t_: TaskAction
_b_: OverseerBuild           _l_:  LoadBundle
              _<Enter>_: Runnner
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^

                 Code Runners

^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_r_: Run Code                 _F_: Adv RUn
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^

                 Lab Runners

^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_W_: Run Code                 _s_: Stop Code
                  _p_: Pannel
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^

                  SnipRun

^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_o_: SnipRun                 _v_: SnipRunV
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^


^^^^ _C_: Pydoc _c_: Doc        _<Esc>_: quit   ^^^^

]]

Hydra({
    name = "Runner",
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n", "v", "x" },
    body = ";r",
    heads = {
        { "w", cmd("OverseerToggle"), { exit = true } },
        { "e", cmd("OverseerRun") },
        { "d", cmd("OverseerQuickAction") },
        { "t", cmd("OverseerTaskAction") },
        { "b", cmd("OverseerBuild") },
        { "l", cmd("OverseerLoadBundle") },
        {
            "<Enter>",
            function()
                local overseer = require("overseer")
                overseer.run_template({ name = "Runner" }, function(task)
                    task = task or "Poetry run file"
                    if task then
                        overseer.run_action(task, "open float")
                    end
                end)
            end,
            { exit = true, desc = false },
        },

        { "<Esc>", nil, { exit = true, desc = false } },

        { "r", cmd("RunCode"), { exit = true } },
        { "F", run_or_test, { exit = true } },
        { "W", cmd("Lab code run"), { exit = true } },
        { "s", cmd("Lab code stop"), { exit = false } },
        { "p", cmd("Lab code panel"), { exit = false } },
        { "o", cmd([[lua require("sniprun").run()]]), { exit = true } },
        { "v", cmd([[lua require("sniprun").run('v')]]), { exit = false } },
        { "<Esc>", nil, { exit = true, desc = false } },
        {
            "c",
            cmd("PythonCopyReferenceDotted"),
            { desc = "Python Copy reference dot" },
        },
        {
            "C",
            cmd("PythonCopyReferencePytest"),
            { desc = "Python Copy reference Pytest" },
        },
    },
})
