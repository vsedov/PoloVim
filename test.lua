local called_func_2 = false
local timer_2 = nil
local space_used_camel
local function camelCase_toSnake_case(s)
    -- create function to convert any camelcase to snake_case
    if timer_2 then
        vim.loop.timer_stop(timer_2)
        vim.loop.close(timer_2)
        timer_2 = nil
    end
    if called_func_2 then
        return
    end
    if s then
        if timer_2 then
            vim.loop.timer_stop(timer_2)
            vim.loop.close(timer_2)
            timer_2 = nil
        end
        return
    end
    if vim.v.char and vim.v.char ~= " " then
        space_used_camel = false
        return
    end
    if vim.fn.mode() ~= "i" then
        return
    end

    if space_used_camel then
        return
    end

    space_used_camel = true

    timer_2 = vim.defer_fn(function()
        called_func_2 = true
        if s == nil then
            s = vim.fn.expand("<cword>")
        end
        lprint("replace: ", s)
        local n = s
            :gsub("%f[^%l]%u", "_%1")
            :gsub("%f[^%a]%d", "_%1")
            :gsub("%f[^%d]%a", "_%1")
            :gsub("(%u)(%u%l)", "%1_%2")
            :lower()
        vim.fn.setreg("s", n)
        vim.cmd([[exe "norm! ciw\<C-R>s"]])
        lprint("newstr", n)
    end, 150)
end
