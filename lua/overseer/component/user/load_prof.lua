return {
    desc = "Load profile data",
    constructor = function()
        return {
            on_complete = function(_, _, status)
                if status == "SUCCESS" then
                    -- Jul_perf_flat()
                end
            end,
        }
    end,
}
