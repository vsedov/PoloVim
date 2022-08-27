local previous_cmd = ""

vim.api.nvim_create_user_command("T", function(param)
    vim.cmd("OverseerOpen!")
    vim.cmd("OverseerRunCmd " .. param.args)
    previous_cmd = param.args
end, { nargs = "?", force = true })

vim.keymap.set("n", "[make]m", "<Cmd>OverseerToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[make]q", "<Cmd>OverseerToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "[make]r", function()
    vim.cmd("OverseerOpen!")
    vim.cmd("OverseerRunCmd " .. previous_cmd)
end, { noremap = true, silent = true })
