
local previous_cmd = ""

vim.api.nvim_create_user_command("T", function(param)
    param = param or "python %"
    vim.cmd("OverseerOpen!")
    vim.cmd("OverseerRunCmd " .. param.args)
    previous_cmd = param.args
end, { nargs = "?", force = true })

vim.keymap.set("n", "_W", "<Cmd>OverseerToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "_w", function()
    if previous_cmd == "" then
        vim.cmd([[T]])
    end
    vim.cmd("OverseerOpen")
    vim.cmd("OverseerRunCmd " .. previous_cmd)
end, { noremap = true, silent = true })

vim.api.nvim_create_user_command("Tp", function(param)
    vim.cmd("OverseerOpen")
    vim.cmd("OverseerRunCmd python %")
    previous_cmd = "python %"
end, { nargs = "?", force = true })