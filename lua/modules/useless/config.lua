local config = {}

function config.launch_duck()
    require("duck").setup({
        winblend = 100, -- 0 to 100
        speed = 1, -- optimal: 1 to 99
        width = 10,
    })
    add_cmd("DuckStart", function()
        require("duck").hatch("🐼")
    end, { force = true })
    add_cmd("DuckKill", function()
        require("duck").cook("🐼")
    end, { force = true })
end

return config
