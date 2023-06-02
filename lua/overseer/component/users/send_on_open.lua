return {
    desc = "Dispose of the task as it is made",
    editable = false,
    serializable = true,
    params = {},
    constructor = function()
        return {
            on_pre_start = function(_, task)
                if task then
                    task:dispose()
                end
                return false
            end,
        }
    end,
}
