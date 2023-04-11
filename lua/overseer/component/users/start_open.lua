local overseer = require("overseer")

local get_win_id = function(bufnr)
    winids = {}
    if bufnr then
        for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
            for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
                local winbufnr = vim.api.nvim_win_get_buf(winid)
                local winvalid = vim.api.nvim_win_is_valid(winid)

                if winvalid and winbufnr == bufnr then
                    table.insert(winids, winid)
                end
            end
        end
    end
    return winids
end

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
        }
    },
    constructor = function(params)
        return {
            on_start = function(_, task)
                local bufnr = OpenTaskBufnr[task.name]
                local winids = get_win_id(bufnr)
                if #winids > 0 then
                    for _, winid in ipairs(winids) do
                        vim.api.nvim_win_set_buf(winid, task.strategy.bufnr)
                    end
                else
                    overseer.run_action(task, "open")
                end

                if params.goto_prev then
                    vim.cmd.wincmd({ args = { "p" } })
                elseif #winids > 0 then
                    vim.api.nvim_set_current_win(winids[1])
                end

                if params.start_insert then
                    vim.cmd.startinsert()
                end
                OpenTaskBufnr[task.name] = task.strategy.bufnr
            end,
        }
    end
}
