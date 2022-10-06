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
            position = "bottom-right",
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
        -- return ":Jaq<CR>"
        local m = vim.fn.mode()
        if m == "n" or m == "i" then
            require("sniprun").run()
        else
            require("sniprun").run("v")
        end
    end
end

local hint = [[
^ ^ _r_: Run Code   ^ ^
^ ^ _f_: Adv RUn    ^ ^
^ ^ _w_: SnipRun    ^ ^
^ ^ _e_: SnipRunV   ^ ^
^ ^ _a_: Run Code   ^ ^
^ ^ _s_: Stop Code  ^ ^
^ ^ _d_: Pannel     ^ ^
]]
Hydra({
    name = "Runner",
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n", "i", "v" },
    body = ";r",
    heads = {
        { "r", cmd("Jaq float"), { exit = false } },
        { "f", run_or_test, { exit = false } },
        { "w", cmd([[luarequire("sniprun").run())]]), { exit = false } },
        { "e", cmd([[lua require("sniprun").run('v')]]), { exit = false } },

        { "a", cmd("Lab code run"), { exit = false } },
        { "s", cmd("Lab code stop"), { exit = false } },
        { "d", cmd("Lab code panel"), { exit = false } },

        { "<Esc>", nil, { exit = true, desc = false } },
    },
})
