local task_history = {}
local tasks = {}

function register_task(task)
    tasks[task.id] = task
    table.insert(task_history, task.id)
end

function get_last_task()
    return tasks[task_history[#task_history]]
end

function restart_last_task()
    local task = get_last_task()
    if task then
        require("overseer").run_action(task, "restart")
    end
end

function unregister_task(task_id)
    tasks[task_id] = nil
    if task_history[#task_history] == task_id then
        task_history[#task_history] = nil
    end
end

return {
    desc = "Track files in a history so that the most recent can be restarted",
    constructor = function()
        return {
            on_start = function(_, task)
                register_task(task)
            end,
            on_dispose = function(_, task)
                unregister_task(task.id)
            end,
        }
    end,
}
