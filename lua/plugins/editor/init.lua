local conf = require("plugins.editor.config")
conf.hydra()

vim.g.smartq_q_buftypes = {
    "quickfix",
    "nofile",
    "acwrite",
}
local smart_close_filetypes = {
    "diff",
    "git",
    "qf",
    "log",
    "help",
    "query",
    "dbui",
    "lspinfo",
    "git.*",
    "Neogit.*",
    "neotest.*",
    "fugitive.*",
    "copilot.*",
    "tsplayground",
    "startuptime",
}
vim.g.smartq_q_filetypes = smart_close_filetypes
