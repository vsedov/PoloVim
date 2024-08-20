M = {}

local function subcmd_alias(_)
    vim.api.nvim_create_user_command(
        "Metadata",
        "Neorg update-metadata",
        { desc = "Neorg: update-metadata", bar = true }
    )
    local days = { "Yesterday", "Today", "Tomorrow" }
    for _, cmd in ipairs(days) do
        vim.api.nvim_create_user_command(cmd, function()
            lambda.pcall(vim.cmd, [[Neorg journal ]] .. cmd:lower()) ---@diagnostic disable-line
            vim.schedule(function()
                vim.cmd([[Metadata | w]])
                vim.cmd([[normal ]h]h]]) -- move down to {** Daily Review}
                lambda.pcall(vim.cmd, [[Neorg templates load journal]]) ---@diagnostic disable-line
            end)
        end, { desc = "Neorg: open " .. cmd .. "'s journal", force = true })
    end
end

M.setup = function(opts)
    subcmd_alias(opts)
end

return M
