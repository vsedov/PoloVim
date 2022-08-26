local overseer = require("overseer")
return {
    {
        name = "Runner",
        builder = function(params)
            return {
                cmd = {
                    vim.api.nvim_buf_get_name(0),
                },
            }
        end,
        tags = overseer.TAG.BUILD,
        params = {},
        priority = 4,
        condition = {
            filetype = { "py", "sh", "lua" },
        },
    },
}
