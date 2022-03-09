local callbackdefs = {
    callback = {
        {
            "VimEnter",
            "*",
            function()
                if vim.fn.bufname("%") ~= "" then
                    return
                end
                local byte = vim.fn.line2byte(vim.fn.line("$") + 1)
                if byte ~= -1 or byte > 1 then
                    return
                end
                vim.bo.buftype = "nofile"
                vim.bo.swapfile = false
                vim.bo.fileformat = "unix"
            end,
        },
        {
            "BufWritePost",
            "*",
            function()
                if vim.fn.getline(1) == "^#!" then
                    if vim.fn.getline(1) == "/bin/" then
                        vim.cmd([[chmod a+x <afile>]])
                    end
                end
            end,
            false,
        },
        {
            "BufWritePre",
            "*",
            function()
                function auto_mkdir(dir, force)
                    if
                        vim.fn.empty(dir) == 1
                        or string.match(dir, "^%w%+://")
                        or vim.fn.isdirectory(dir) == 1
                        or string.match(dir, "^suda:")
                    then
                        return
                    end
                    if not force then
                        vim.fn.inputsave()
                        local result = vim.fn.input(string.format('"%s" does not exist. Create? [y/N]', dir), "")
                        if vim.fn.empty(result) == 1 then
                            print("Canceled")
                            return
                        end
                        vim.fn.inputrestore()
                    end
                    vim.fn.mkdir(dir, "p")
                end
                auto_mkdir(vim.fn.expand("<afile>:p:h"), vim.v.cmdbang)
            end,
            false,
        },
    },
}
local function test(defs)
    for group_name, definition in pairs(defs) do
        vim.api.nvim_create_augroup(group_name, { clear = true })
        for _, def in ipairs(definition) do
            event = def[1]
            -- Check if def[3] is a function or a string
            local cmd
            if type(def[3]) == "string" then
                cmd = def[3]
            end
            local call
            if type(def[3]) == "function" then
                call = def[3]
            end
            -- make args depending if cmd is null or not
            local arg = {
                group = group_name,
                pattern = def[2],
                command = cmd,
                callback = call,
                nested = def[4],
            }

            vim.api.nvim_create_autocmd(event, arg)
        end
    end
end
test(callbackdefs)
