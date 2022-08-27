local overseer = require("overseer")
local STATUS = require("overseer.constants").STATUS
overseer.setup({
    form = {
        border = lambda.style.border.type_0,

        win_opts = { winblend = 0 },
    },
    task_editor = { win_opts = { winblend = 0 } },
    task_win = { win_opts = { winblend = 0 } },
    confirm = { win_opts = { winblend = 0 } },

    auto_detect_success_color = true,
    dap = true,
    task_list = {
        bindings = {
            ["?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "<cmd>OverseerQuickAction open in toggleterm<cr>",
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
            "on_complete_notify",
            "on_complete_dispose",
            { "toggleterm.attach_toggleterm", goto_bottom = true },
        },
        default = {
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            "on_complete_dispose",
            "toggleterm.attach_toggleterm",
        },
    },
    actions = {
        ["open"] = false,
        ["open vsplit"] = false,
        ["open hsplit"] = false,
        ["set loclist diagnostics"] = true,
        ["open in toggleterm"] = {
            desc = "Attach this task to a toggleterm terminal",
            run = function(task)
                if task.toggleterm then
                    if task.toggleterm:is_open() then
                        task.toggleterm:close()
                        task.toggleterm:open()
                    else
                        task.toggleterm:open()
                    end
                else
                    local bufnr = task.strategy.bufnr
                    task.toggleterm = Terminal:new({ bufnr = bufnr, jobname = task.name })
                    task:add_components({ "toggleterm.on_dispose_clean_toggleterm" })
                    task.toggleterm:toggle()
                    task.toggleterm:__resurrect()
                end
                task.toggleterm:set_harp(2)
            end,
        },
        ["open hsplit, no focus"] = {
            desc = "open terminal in a horizontal split",
            condition = function(task)
                local bufnr = task:get_bufnr()
                return bufnr and vim.api.nvim_buf_is_valid(bufnr)
            end,
            run = function(task)
                vim.cmd([[split]])
                vim.api.nvim_win_set_buf(0, task:get_bufnr())
                vim.cmd([[wincmd k]])
            end,
        },
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
    templates = { "builtin", "julia", "python", "tox", "configs" },
})

vim.api.nvim_create_user_command(
    "OverseerDebugParser",
    'lua require("overseer.parser.debug").start_debug_session()',
    {}
)

require("modules.lang.overseer.binds")
require("modules.lang.overseer.template")
