local files = require("overseer.files")

return {
    generator = function(_, cb)
        local ret = {}
        local priority = 60
        local pr = function()
            priority = priority + 1
            return priority
        end

        table.insert(ret, {
            name = "Open " .. vim.fn.expand("%:t:r") .. " REPL",
            builder = function()
                local cmd = require("haskell-tools").repl.mk_repl_cmd(vim.api.nvim_buf_get_name(0))
                return {
                    name = vim.fn.expand("%:t:r") .. " REPL",
                    cmd = cmd,
                    components = { "default", "unique" },
                }
            end,
            condition = {
                filetype = "haskell",
            },
            priority = pr(),
        })

        cb(ret)
    end,
}
