vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
vim.defer_fn(function()
    require("core.cmd_line")
end, 5000)
