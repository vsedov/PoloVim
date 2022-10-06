local Hydra = require("hydra")
local neotest
local hint = [[
 _t_: test nearest    _a_: attach nearest    _o_: summary
 _f_: test file       _x_: stop nearest      _d_: debug nearest
 ^ ^
 ^ ^                  _Esc_: exit
]]

local test_hydra = Hydra({
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "rounded",
        },
    },
    on_enter = function()
        vim.cmd([[packadd neotest]])
        neotest = require("neotest")
    end,
    name = "test",
    mode = { "n", "x" },
    body = "<leader>u",
    heads = {
        {
            "t",
            function()
                neotest.run.run()
            end,
            { silent = true },
        },
        {
            "x",
            function()
                neotest.run.stop()
            end,
            { silent = true },
        },
        {
            "f",
            function()
                neotest.run.run(vim.fn.expand("%"))
            end,
            { silent = true },
        },
        {
            "d",
            function()
                neotest.run.run({ strategy = "dap" })
            end,
            { silent = true },
        },
        {
            "a",
            function()
                neotest.run.attach()
            end,
            { silent = true },
        },
        {
            "o",
            function()
                neotest.summary.toggle()
            end,
            { silent = true },
        },
        { "<Esc>", nil, { exit = true, desc = false } },
    },
})

Hydra.spawn = function(head)
    if head == "test-hydra" then
        test_hydra:activate()
    end
end
