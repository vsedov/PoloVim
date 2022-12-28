Terminal = require("toggleterm.terminal").Terminal
Harp_Term_1 = Terminal:new({ id = 1001, jobname = "Terminal 1" })
Harp_Term_2 = Terminal:new({ id = 1002, jobname = "Terminal 2" })

function Terminal:set_harp(term_num)
    if term_num == 1 then
        if Harp_Term_1 ~= self then
            if Harp_Term_1:is_open() then
                Harp_Term_1:close()
            end
            Harp_Term_1 = self
        end
    elseif term_num == 2 then
        if Harp_Term_2 ~= self then
            Harp_Term_2 = self
        end
    end
end

local function anyTermOpen()
    local term_list = require("toggleterm.terminal").get_all()
    local open
    for _, term in pairs(term_list) do
        if term:is_open() then
            open = true
            break
        end
    end
    return open
end

return {
    desc = "Clean up toggleterm terminal after the task is disposed",
    editable = false,
    serializable = true,
    params = {
        goto_bottom = {
            desc = "If the terminal should jump to the bottom",
            type = "boolean",
            defualt = true,
            optional = true,
        },
    },
    constructor = function(opts)
        return {
            on_init = function() end,
            on_start = function(_, task)
                Task = task
                if task.toggleterm then
                    task.toggleterm:shutdown()
                end
                local bufnr = task.strategy.bufnr
                local name = task.test_name or task.name

                local open = anyTermOpen()
                task.toggleterm = Terminal:new({ bufnr = bufnr, jobname = name })
                task.toggleterm:toggle()
                task.toggleterm:__resurrect()

                if opts.goto_bottom then
                    require("toggleterm.ui").scroll_to_bottom()
                end

                require("toggleterm.ui").goto_previous()

                task.toggleterm:set_harp(2)
                if not open then
                    task.toggleterm:close()
                end
            end,
            on_restart = function(_, task)
                task.toggleterm:shutdown()
            end,
            on_dispose = function(_, task)
                task.toggleterm:shutdown()

                local task_list = require("overseer.task_list").list_tasks()
                local prev_task = task_list[#task_list - 1]
                prev_task.toggleterm:set_harp(2)
            end,
        }
    end,
}
