return {
    {
        name = "Python run",
        builder = function(params)
            return {
                cmd = { "python" },
                args = {},
                name = "python run",
                cwd = "",
                env = {},
            }
        end,
        params = {},
        priority = 50,
        condition = {
            filetype = { "python" },
        },
    },
}
