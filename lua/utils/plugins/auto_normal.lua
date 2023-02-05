local M = {}
local function auto_normal(ms)
    vim.on_key(
        (function()
            local timer = vim.loop.new_timer()
            return function()
                timer:stop()
                timer = vim.defer_fn(vim.cmd[vim.api.nvim_get_mode().mode == "i" and "stopinsert" or "#!"], ms)
            end
        end)(),
        vim.api.nvim_create_namespace("auto_normal")
    )
end
M.setup = function(time)
    time = time or 10000
    auto_normal(time)
end

return M
