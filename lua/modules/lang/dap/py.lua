local dap = require("dap")
dap.configurations.python = dap.configurations.python or {}

table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "launch with options",
    program = "${file}",
    python = function() end,
    pythonPath = function()
        local path
        for _, server in pairs(vim.lsp.buf_get_clients()) do
            path = vim.tbl_get(server, "config", "settings", "python", "pythonPath")
            if path then
                break
            end
        end
        path = vim.fn.input("Python path: ", path or "", "file")
        return path ~= "" and vim.fn.expand(path) or nil
    end,
    args = function()
        local args = {}
        local i = 1
        while true do
            local arg = vim.fn.input("Argument [" .. i .. "]: ")
            if arg == "" then
                break
            end
            args[i] = arg
            i = i + 1
        end
        return args
    end,
    justMyCode = function()
        return vim.fn.input("justMyCode? [y/n]: ") == "y"
    end,
    stopOnEntry = function()
        return vim.fn.input("justMyCode? [y/n]: ") == "y"
    end,
    console = "integratedTerminal",
})
