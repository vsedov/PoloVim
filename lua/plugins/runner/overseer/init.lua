local overseer = require("overseer")
local component = require("overseer.component")
local constants = require("overseer.constants")
local form = require("overseer.form")
local task_bundle = require("overseer.task_bundle")
local task_editor = require("overseer.task_editor")
local task_list = require("overseer.task_list")
local util = require("overseer.util")
local STATUS = constants.STATUS
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
    -- strategy = "terminal",
    strategy = { "jobstart" },
    form = { border = Border, win_opts = { winblend = 0 } },
    task_editor = { border = Border, win_opts = { winblend = 0 } },
    task_win = { border = Border, win_opts = { winblend = 0 } },
    confirm = { border = Border, win_opts = { winblend = 0 } },
    dap = false,
    task_list = {
        separator = "────────────────────────────────────────────────────────────────────────────────",
    },
    -- component_aliases = {
    --     default_neotest = {
    --         { "display_duration", detail_level = 2 },
    --         "on_output_summarize",
    --         "on_exit_set_status",
    --         { "on_complete_notify", system = "unfocused" },
    --         "on_complete_dispose",
    --         "unique",
    --     },
    --     default = {
    --         "display_duration",
    --         "on_output_summarize",
    --         "on_exit_set_status",
    --         { "on_complete_notify", system = "unfocused" },
    --         "on_complete_dispose",
    --     },
    --     always_restart = { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } },
    -- },
    component_aliases = {
        -- Most tasks are initialized with the default components
        default = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
        },
        -- Tasks from tasks.json use these components
        default_vscode = {
            "default",
            "on_result_diagnostics",
        },
    },
    template_timeout = 5000,
    template_cache_threshold = 0,
    actions = {
        start = {
            condition = function(task)
                return task.status == STATUS.PENDING
            end,
            run = function(task)
                task:start()
            end,
        },
        stop = {
            condition = function(task)
                return task.status == STATUS.RUNNING
            end,
            run = function(task)
                task:stop()
            end,
        },
        save = {
            desc = "save the task to a bundle file",
            run = function(task)
                task_bundle.save_task_bundle(nil, { task })
            end,
        },
        restart = {
            condition = function(task)
                return task.status ~= STATUS.PENDING
            end,
            run = function(task)
                task:restart(true)
            end,
        },
        dispose = {
            run = function(task)
                task:dispose(true)
            end,
        },
        edit = {
            run = function(task)
                task_editor.open(task, function(t)
                    if t then
                        task_list.update(t)
                    end
                end)
            end,
        },
        retain = {
            desc = "Don't automatically dispose this task after complete",
            condition = function(task)
                return task:has_component("on_complete_dispose")
            end,
            run = function(task)
                task:remove_component("on_complete_dispose")
            end,
        },
        ensure = {
            desc = "restart the task if it fails",
            condition = function(task)
                return not task:has_component("on_complete_restart")
            end,
            run = function(task)
                task:add_components({ "on_complete_restart" })
                if task.status == STATUS.FAILURE then
                    task:restart()
                end
            end,
        },
        watch = {
            desc = "restart the task when you save a file",
            condition = function(task)
                return not task:has_component("restart_on_save")
            end,
            run = function(task)
                local comp = assert(component.get("restart_on_save"))
                local schema = vim.deepcopy(assert(comp.params))
                form.open("Restart task when files are written", schema, {
                    paths = { vim.fn.getcwd() },
                }, function(params)
                    if not params then
                        return
                    end
                    params[1] = "restart_on_save"
                    task:set_component(params)
                    task_list.update(task)
                end)
            end,
        },
        unwatch = {
            desc = "Remove the file watcher",
            condition = function(task)
                return task:has_component("restart_on_save")
            end,
            run = function(task)
                task:remove_component("restart_on_save")
            end,
        },
        ["open float"] = {
            desc = "open terminal in a floating window",
            condition = function(task)
                return task:get_bufnr()
            end,
            run = function(task)
                task:open_output("float")
            end,
        },
        open = {
            desc = "open terminal in the current window",
            condition = function(task)
                return task:get_bufnr()
            end,
            run = function(task)
                task:open_output()
            end,
        },
        ["open hsplit"] = {
            desc = "open terminal in a horizontal split",
            condition = function(task)
                return task:get_bufnr()
            end,
            run = function(task)
                task:open_output("horizontal")
            end,
        },
        ["open vsplit"] = {
            desc = "open terminal in a vertical split",
            condition = function(task)
                return task:get_bufnr()
            end,
            run = function(task)
                task:open_output("vertical")
            end,
        },
        ["open tab"] = {
            desc = "open terminal in a new tab",
            condition = function(task)
                return task:get_bufnr()
            end,
            run = function(task)
                task:open_output("tab")
            end,
        },
        ["set quickfix diagnostics"] = {
            desc = "put the diagnostics results into quickfix",
            condition = function(task)
                return task.result and task.result.diagnostics and not vim.tbl_isempty(task.result.diagnostics)
            end,
            run = function(task)
                vim.fn.setqflist(task.result.diagnostics)
            end,
        },
        ["set loclist diagnostics"] = {
            desc = "put the diagnostics results into loclist",
            condition = function(task)
                return task.result and task.result.diagnostics and not vim.tbl_isempty(task.result.diagnostics)
            end,
            run = function(task)
                local winid = util.find_code_window()
                vim.fn.setloclist(winid, task.result.diagnostics)
            end,
        },
        ["open output in quickfix"] = {
            desc = "open the entire task output in quickfix",
            condition = function(task)
                local bufnr = task:get_bufnr()
                return task:is_complete()
                    and bufnr
                    and vim.api.nvim_buf_is_valid(bufnr)
                    and vim.api.nvim_buf_is_loaded(bufnr)
            end,
            run = function(task)
                local lines = vim.api.nvim_buf_get_lines(task:get_bufnr(), 0, -1, true)
                vim.fn.setqflist({}, " ", {
                    title = task.name,
                    context = task.name,
                    lines = lines,
                    -- Peep into the default component params to fetch the errorformat
                    efm = task.default_component_params.errorformat,
                })
                vim.cmd("botright copen")
            end,
        },
        -- ["open vsplit"] = true,
        -- ["open hsplit"] = true,
        -- ["set loclist diagnostics"] = true,
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
    },
    templates = { "cargo", "just", "make", "npm", "shell", "tox", "vscode", "mix", "rake", "task", "user" },
})

vim.api.nvim_set_hl(0, "OverseerTaskBorder", { link = "Normal" })
require("modules.runner.overseer.binds")
