local useless = {}
local conf = require("modules.useless.config")
-- This needs to be loaded

-- True emotional Support
useless["rtakasuke/vim-neko"] = {
    cmd = "Neko",
    opt = true,
}
useless["kwakzalver/duckytype.nvim"] = {
    cmd = { "DuckType" },
    opt = true,
    config = conf.duck_type,
}
-- Call :DuckStart then to stop the duck Call DuckKill
useless["tamton-aquib/duck.nvim"] = {
    cmd = { "DuckStart", "DuckKill" },
    opt = true,
    config = conf.launch_duck,
}

useless["tamton-aquib/zone.nvim"] = {
    cmd = { "Zone" }, -- return {'treadmill', 'dvd', 'vanish'} Zone dvd
    opt = true,
    config = function()
        require("zone").setup({
            style = "treadmill",
            after = 30, -- Idle timeout
            -- More options to come later

            treadmill = {
                direction = "left",
                -- Opts for Treadmill style
            },
            dvd = {
                -- Opts for Dvd style
            },
            -- etc
        })
    end,
}

-- makes an error but eh, screw it good enough
useless["ryoppippi/bad-apple.vim"] = {
    cmd = "BadApple",
    requires = { "vim-denops/denops.vim", after = "bad-apple.vim", opt = true },
    opt = true,
}

-- your plugin config
return useless
