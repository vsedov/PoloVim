local overseer = require("overseer")

return {
    desc = "Open in split on task start",
    editable = false,
    serializable = true,
    params = {
        goto_prev = {
            type = "boolean",
            desc = "to return or not to return",
            default = false,
            optional = true,
        },
        start_insert = {
            type = "boolean",
            desc = "Start in insert mode",
            default = false,
            optional = true,
        },
    },
    constructor = function(params)
        return {
            on_start = function(_, task)
                overseer.run_action(task, "open")
                if not params.goto_prev and params.start_insert then
                    vim.cmd.startinsert()
                else
                    require("edgy").goto_main()
                end
            end,
        }
    end,
}
