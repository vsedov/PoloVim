local add_cmd = vim.api.nvim_create_user_command
add_cmd("MDRun", function()
    local current_file = vim.fn.expand("%:p")
    if vim.fn.expand("%:e") == "md" then
        vim.fn.system("inlyne " .. current_file)
    else
        vim.notify("This is not a Markdown file", vim.log.levels.WARN, {})
    end
end, {})

