require("core")
require("modules.lsp.lsp.config.handlers").setup()

function insert_idle_check()
    vim.defer_fn(function()
        local timer = vim.loop.new_timer()
        timer:start(vim.schedule_wrap(function()
            if vim.fn.mode() == "i" then
                print("insert")
            else
                timer:stop()
                timer:close()
            end
        end))
    end, 1000)
end

lambda.augroup("test", {
    {
        event = "InsertEnter",
        pattern = "*",
        command = function() end,
    },
})
