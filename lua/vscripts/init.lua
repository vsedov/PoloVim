local cmd = vim.fn.expand("$HOME") .. "/.config/nvim/scripts/"
for _, v in ipairs(vim.fn.globpath(cmd, "*.vim", false, true)) do
    vim.cmd("source " .. v)
end
