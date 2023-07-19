local files = require("overseer.files")

return {
    generator = function(opts, cb)
        local priority = 200
        local scripts = vim.tbl_filter(function(filename)
            return filename:match("%.sh$")
        end, files.list_files(opts.dir))
        local ret = {}
        for _, filename in ipairs(scripts) do
            table.insert(ret, {
                name = filename,
                params = {
                    args = { optional = true, type = "list", delimiter = " " },
                },
                priority = priority,
                builder = function(params)
                    return {
                        cmd = { files.join(opts.dir, filename) },
                        args = params.args,
                    }
                end,
            })
            priority = priority + 1
        end

        if files.exists(files.join(opts.dir, "bin")) then
            local bins = vim.tbl_filter(function(filename)
                return vim.fn.executable(filename)
            end, files.list_files(files.join(opts.dir, "bin")))
            for _, filename in ipairs(bins) do
                table.insert(ret, {
                    name = filename,
                    params = {
                        args = { optional = true, type = "list", delimiter = " " },
                    },
                    priority = priority,
                    builder = function(params)
                        return {
                            cmd = { files.join(opts.dir, "bin", filename) },
                            args = params.args,
                        }
                    end,
                })
                priority = priority + 1
            end
        end

        cb(ret)
    end,
}
