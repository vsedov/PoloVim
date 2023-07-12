return {
    desc = "Attach a toggleterm to the task",
    editable = false,
    serializable = true,
    params = {
        send_on_open = {
            type = "string",
            desc = "What text to send to task once it has started",
            default = nil,
            optional = true,
        },
    },
    constructor = function(params)
        return {
            on_start = function(_, task)
                if params.send_on_open then
                    vim.fn.chansend(task.strategy.chan_id, params.send_on_open)
                end
            end,
        }
    end,
}
