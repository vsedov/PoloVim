local overseer = require("overseer")
local STATUS = require("overseer.constants").STATUS
local TAG = require("overseer.constants").STATUS

-- M.STATUS = Enum.new({ "PENDING", "RUNNING", "CANCELED", "SUCCESS", "FAILURE", "DISPOSED" })
-- ---@alias overseer.Tag "BUILD"|"TEST"|"CLEAN"
-- M.TAG = Enum.new({ "BUILD", "TEST", "CLEAN" })
overseer.setup({
    form = { win_opts = { winblend = 0 } },
    task_editor = { win_opts = { winblend = 0 } },
    task_win = { win_opts = { winblend = 0 } },
    confirm = { win_opts = { winblend = 0 } },
    pre_task_hook = function(task_defn)
        local env = require("utils.set_env").env
        if env then
            task_defn.env = env
            dump(task_defn)
        end
    end,

    task_list = {
        bindings = {
            ["?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "<cmd>OverseerQuickAction open in toggleterm<cr>",
            ["p"] = "TogglePreview",
            ["<C-l>"] = "IncreaseDetail",
            ["<C-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "PrevTask",
            ["]"] = "NextTask",
            ["{"] = nil,
            ["}"] = nil,
            ["<C-v>"] = nil,
            ["<C-f>"] = nil,
        },
    },
    component_aliases = {
        default_neotest = {
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            "on_complete_dispose",
        },
        default = {
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            "on_complete_dispose",
        },
    },
    actions = {
        ["open"] = false,
        ["open vsplit"] = false,
        ["open hsplit"] = false,
        ["set loclist diagnostics"] = false,
        ["keep running"] = {
            desc = "restart the task even if it succeeds",
            run = function(task)
                task:add_components({ { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } } })
                if task.status == STATUS.FAILURE or task.status == STATUS.SUCCESS then
                    task:restart()
                end
            end,
        },
    },
    templates = { "builtin", "tox", "shell", "cargo" },
})
vim.api.nvim_create_user_command(
    "OverseerDebugParser",
    'lua require("overseer.parser.debug").start_debug_session()',
    {}
)
-- Binds need to be loaded last
require("modules.lang.overseer.templates")

require("modules.lang.overseer.binds")
