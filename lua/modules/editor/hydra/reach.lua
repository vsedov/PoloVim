-- https://github.com/Reisen/vimless/blob/master/lua/plugins/hydra.lua
local cmd = require("hydra.keymap-util").cmd
local Hydra = require("hydra")

local reach_options = {
    handle = "dynamic",
    show_current = true,
    sort = function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end,
}

-- Function to swap to the last buffer for this window.
local function swap_to_last_buffer()
    local last_buffer = vim.fn.bufnr("#")
    if last_buffer ~= -1 then
        vim.cmd("buffer " .. last_buffer)
    end
end
local jump_hint = [[
^ Reach
^ _b_: Buffer
^ _m_: Marks
^ _t_: Tabs
^ _c_: Colorschemes ^
^ Navigation        ^
^ _l_: Last Buffer
^ _q_: Quit 
]]
Hydra({
    name = "Jump",
    mode = "n",
    body = ";;", -- Im not sure how this would feel.
    hint = jump_hint,
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    heads = {
        {
            "b",
            function()
                require("reach").buffers(reach_options)
            end,
            { exit = true },
        },
        { "m", cmd("ReachOpen marks"), { exit = true } },
        { "t", cmd("ReachOpen tabpages"), { exit = true } },
        { "c", cmd("ReachOpen colorschemes"), { exit = true } },
        { "l", swap_to_last_buffer, { exit = true } },
        { "q", nil, { exit = true } },
    },
})
