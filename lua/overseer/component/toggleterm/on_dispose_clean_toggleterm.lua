return {
    desc = "Clean up toggleterm terminal after the task is disposed",
    editable = false,
    serializable = true,
    constructor = function()
        return {
            on_start = function(self, task)
                task.toggleterm:shutdown()
                local bufnr = task.strategy.bufnr
                task.toggleterm = Terminal:new({ bufnr = bufnr, jobname = task.name })
                task.toggleterm:toggle()
                task.toggleterm:__resurrect()
                task.toggleterm:toggle()
            end,
            on_restart = function(_, task)
                task.toggleterm:shutdown()
            end,
            on_dispose = function(_, task)
                task.toggleterm:shutdown()
            end,
        }
    end,
}
