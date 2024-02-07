local loader = require("lazy").load

local lazy_timer = 30

vim.defer_fn(function()
    vim.api.nvim_create_user_command("Gram", function()
        require("modules.tools.config").grammcheck()
    end, { force = true })

    loader({ plugins = { "presence.nvim" } })
end, lazy_timer + 60)

vim.defer_fn(function()
    loader({ plugins = { "telescope.nvim", "telescope-zoxide", "nvim-neoclip.lua" } })
end, lazy_timer + 80)

vim.defer_fn(function()
    if lambda.config.record_your_self then
        loader({ plugins = { "vim-wakatime" } })
    end
end, 120)

vim.defer_fn(function()
    if lambda.config.movement.movement_type == "leap" then
        loader({ plugins = { "leap.nvim" } })
        require("modules.movement.leap").highlight()
    end
    require("vscripts")
end, 150)
