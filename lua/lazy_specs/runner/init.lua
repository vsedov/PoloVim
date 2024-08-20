return {
    {
        "overseer.nvim",
        event = "DeferredUIEnter",
        after = function()
            local overseer = require("overseer")
            local component = require("overseer.component")
            local constants = require("overseer.constants")
            local form = require("overseer.form")
            local task_bundle = require("overseer.task_bundle")
            local task_editor = require("overseer.task_editor")
            local task_list = require("overseer.task_list")
            local STATUS = constants.STATUS
            local Border = lambda.style.border.type_0

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
                },
                templates = { "cargo", "just", "make", "npm", "shell", "tox", "vscode", "mix", "rake", "task", "user" },
            })

            vim.api.nvim_set_hl(0, "OverseerTaskBorder", { link = "Normal" })
            require("modules.runner.overseer.binds")
        end,
    },
    { -- This plugin
        "compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        after = function()
            require("compiler").setup({})
        end,
    },

    {
        "compiler-explorer.nvim",
        cmd = {
            "CECompile",
            "CECompileLive",
            "CEFormat",
            "CEAddLibrary",
            "CELoadExample",
            "CEOpenWebsite",
            "CEDeleteCache",
            "CEShowTooltip",
            "CEGotoLabel",
        },
    },
    {
        "officer.nvim",
        event = "DeferredUIEnter",
        after = function()
            require("officer").setup({})
        end,
    },
}
