local Hydra = require("hydra")
local match = lambda.lib.match
local when = lambda.lib.when
local loader = require("packer").loader
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
        return ":Jaq internal<CR>"
    else
        local m = vim.fn.mode()
        if m == "n" or m == "i" then
            cmd("Lab code run")
        else
            require("sniprun").run("v")
        end
    end
end

local core_runner_hint = [[
^ ^ _r_: Run Code   ^ ^
^ ^ _f_: Adv RUn    ^ ^

^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _w_: Run Code   ^ ^
^ ^ _s_: Stop Code  ^ ^
^ ^ _p_: Pannel     ^ ^

^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _o_: SnipRun    ^ ^
^ ^ _e_: SnipRunV   ^ ^

^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^
^ ^ _c_: PyRefDot   ^ ^
^ ^ _C_: PyRefTest  ^ ^

^ ^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^ ^

]]
Hydra({
    name = "Runner",
    hint = core_runner_hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n", "i", "v" },
    body = ";r",
    heads = {
        { "r", cmd("Jaq float"), { exit = false } },
        { "f", run_or_test, { exit = true } },
        { "w", cmd("Lab code run"), { exit = true } },
        { "s", cmd("Lab code stop"), { exit = false } },
        { "p", cmd("Lab code panel"), { exit = false } },
        { "o", cmd([[lua require("sniprun").run()]]), { exit = false } },
        { "e", cmd([[lua require("sniprun").run('v')]]), { exit = false } },
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
