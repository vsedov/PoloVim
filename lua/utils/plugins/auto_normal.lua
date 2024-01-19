local M = {}
local function auto_normal(ms)
    local timer = vim.loop.new_timer()
    local function on_key()
        timer:stop()
        timer = vim.defer_fn(function()
            if vim.api.nvim_get_mode().mode ~= "i" then
                return
            end

            vim.schedule(vim.cmd.stopinsert)
        end, ms)
    end

    vim.on_key(on_key, vim.api.nvim_create_namespace("auto_normal"))
end
M.setup = function(opt)
    opt = opt or 30000

    auto_normal(opt)
end

return M
