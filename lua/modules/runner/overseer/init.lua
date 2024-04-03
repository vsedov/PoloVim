local overseer = require("overseer")
local STATUS = require("overseer.constants").STATUS
local util = require("overseer.util")
local Border = lambda.style.border.type_0

local function close_task(bufnr)
    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(winnr) then
            local winbufnr = vim.api.nvim_win_get_buf(winnr)
            if vim.bo[winbufnr].filetype == "OverseerPanelTask" then
                local oldwin = vim.tbl_filter(function(t)
                    return (t.strategy.bufnr == bufnr)
                end, overseer.list_tasks())[1]
                if oldwin then
                    vim.api.nvim_win_close(winnr, true)
                end
            end
        end
    end
end

overseer.setup({
    strategy = "terminal",
    form = { border = Border, win_opts = { winblend = 0 } },
    task_editor = { border = Border, win_opts = { winblend = 0 } },
    task_win = { border = Border, win_opts = { winblend = 0 } },
    confirm = { border = Border, win_opts = { winblend = 0 } },
    dap = false,
    task_list = {
        separator = "────────────────────────────────────────────────────────────────────────────────",
    },
    component_aliases = {
        default_neotest = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            "on_exit_set_status",
            { "on_complete_notify", system = "unfocused" },
            "on_complete_dispose",
            "unique",
        },
        default = {
            "display_duration",
            "on_output_summarize",
            "on_exit_set_status",
            { "on_complete_notify", system = "unfocused" },
            "on_complete_dispose",
        },
        always_restart = { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } },
    },
    template_timeout = 5000,
    template_cache_threshold = 0,
    actions = {
        ["open vsplit"] = false,
        ["open hsplit"] = false,
        ["set loclist diagnostics"] = false,
        ["set as recive terminal"] = {
            desc = "set this task as the terminal to recive sent text and commands",
            run = function(task)
                SendID = task.strategy.chan_id
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
        ["unwatch"] = {
            desc = "stop from running on finish or file watch",
            run = function(task)
                for _, component in pairs({ "on_complete_restart", "on_complete_restart" }) do
                    if task:has_component(component) then
                        task:remove_components({ component })
                    end
                end
            end,
            condition = function(task)
                return task:has_component("on_complete_restart") or task:has_component("restart_on_save")
            end,
        },
        ["dump task"] = {
            desc = "save task table to DumpTask (for debugging)",
            run = function(task)
                DumpTask = task
            end,
        },
        ["open here"] = {
            desc = "open as bottom pannel",
            condition = function(task)
                local bufnr = task:get_bufnr()
                return bufnr and vim.api.nvim_buf_is_valid(bufnr)
            end,
            run = function(task)
                vim.cmd([[normal! m']])
                close_task(task.strategy.bufnr)
                vim.bo[task.strategy.bufnr].filetype = "OverseerTask"
                vim.api.nvim_win_set_buf(0, task:get_bufnr())
                vim.wo.statuscolumn = "%s"
                util.scroll_to_end(0)
            end,
        },
        ["open"] = {
            desc = "open as bottom pannel",
            condition = function(task)
                local bufnr = task:get_bufnr()
                return bufnr and vim.api.nvim_buf_is_valid(bufnr)
            end,
            run = function(task)
                vim.cmd([[normal! m']])
                close_task(task.strategy.bufnr)
                vim.bo[task.strategy.bufnr].filetype = "OverseerPanelTask"
                vim.cmd.vsplit()
                vim.api.nvim_win_set_buf(0, task:get_bufnr())
                util.scroll_to_end(0)
            end,
        },
    },
    templates = { "cargo", "just", "make", "npm", "shell", "tox", "vscode", "mix", "rake", "task", "user" },
})

vim.api.nvim_set_hl(0, "OverseerTaskBorder", { link = "Normal" })
require("modules.runner.overseer.binds")
