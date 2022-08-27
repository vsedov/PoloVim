local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

hint = [[
^^^^                  Overseer                  ^^^^
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_w_: OverseerToggle          _r_: OverseerRun
_d_: OverseerQuickAction     _s_: TaskAction
_b_: OverseerBuild           _l_:  LoadBundle
              _<Enter>_: Runnner  
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
]]

Hydra({
    name = "Diagnostic",
    hint = hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            position = "bottom-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n", "x" },
    body = "<leader>W",
    heads = {
        { "w", cmd("OverseerToggle") },
        { "r", cmd("OverseerRun") },
        { "d", cmd("OverseerQuickAction") },
        { "s", cmd("OverseerTaskAction") },
        { "b", cmd("OverseerBuild") },
        { "l", cmd("OverseerLoadBundle") },
        {
            "<Enter>",
            function()
                local overseer = require("overseer")
                overseer.run_template({ name = "Runner" }, function(task)
                    if task then
                        overseer.run_action(task, "open float")
                        -- overseer.run_action(task, 'open hsplit')
                    end
                end)
            end,
        },

        { "<Esc>", nil, { exit = true, desc = false } },
    },
})
