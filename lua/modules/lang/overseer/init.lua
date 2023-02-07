local overseer = require("overseer")
local STATUS = require("overseer.constants").STATUS
overseer.setup({
    auto_detect_success_color = true,
    dap = true,
    task_list = {
        bindings = {
            ["?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["O"] = "Open",
            ["<C-v>"] = "OpenVsplit",
            ["<C-s>"] = "OpenSplit",
            ["<C-f>"] = "OpenFloat",
            ["p"] = "TogglePreview",
            ["<C-l>"] = "IncreaseDetail",
            ["<C-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "DecreaseWidth",
            ["]"] = "IncreaseWidth",
            ["{"] = "PrevTask",
            ["}"] = "NextTask",
        },
    },

    component_aliases = {
        default_neotest = {
            "on_output_summarize",
            "on_exit_set_status",
            { "on_complete_notify", system = "unfocused" },
            "on_complete_dispose",
            "unique",
            "display_duration",
        },
        default = {
            "on_output_summarize",
            "on_exit_set_status",
            { "on_complete_notify", system = "unfocused" },
            "on_complete_dispose",
            "display_duration",
        },
        always_restart = { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } },
    },
    actions = {

        ["keep runnning"] = {
            desc = "restart the task even if it succeeds",
            run = function(task)
                task:add_components({ { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } } })
                if task.status == STATUS.FAILURE or task.status == STATUS.SUCCESS then
                    task:restart()
                end
            end,
        },
        ["don't dispose"] = {
            desc = "keep the task until manually disposed",
            run = function(task)
                task:remove_components({ "on_complete_dispose" })
            end,
        },
    },

    templates = { "builtin", "users" },
})

vim.api.nvim_create_user_command(
    "OverseerDebugParser",
    'lua require("overseer.parser.debug").start_debug_session()',
    {}
)

require("modules.lang.overseer.binds")
