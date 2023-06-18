local function readable_number()
    local curr = vim.fn.expand("<cword>")

    if tonumber(curr) then
        if #curr < 3 then
            return
        end
        local formatted = ""
        for i = #curr, 1, -3 do
            if i - 3 <= 0 then
                formatted = curr:sub(1, i) .. formatted
                break
            end
            formatted = "_" .. curr:sub(i - 2, i) .. formatted
        end
        vim.api.nvim_set_current_line(vim.fn.substitute(vim.fn.getline("."), curr, formatted, ""))
    end
end

local M = {}

function M.setup()
    lambda.command("ReadNumber", readable_number, { force = true, range = true })
end
return M
