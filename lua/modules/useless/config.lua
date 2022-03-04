local config = {}

function config.launch_duck()
    local loader = require("packer").loader
    loader("duck.nvim")
    require("duck").setup({
        winblend = 100, -- 0 to 100
        speed = 1, -- optimal: 1 to 99
        width = 2,
    })

    -- Starts teh duck
    vim.cmd([[lua require("duck").hatch("🐼")]])

    -- Call function DuckKilil to kill it
    vim.cmd([[command! -nargs=*  DuckKill lua require("duck").cook("🐼")]])
end

return config
