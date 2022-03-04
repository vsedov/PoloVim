local user = {}
local conf = require("modules.user.config")

user["NarutoXY/ytmmusic.lua"] = {
    after = "telescope.nvim",
    cmd = { "YtNotifyPrevious", "YtNotifyNext", "YtNotifyCurrent", "YtVolumeControl" },
    branch = "fix-auth",
    require = { "rcarriga/nvim-notify", "nvim-lua/plenary.nvim" },
    config = function()
        require("ytmmusic")
        require("telescope").load_extension("ytmmusic")
    end,
}

user["~/GitHub/Generatorg"] = {
    ft = "python",
    opt = true,
    config = function()
        require("generatorg")
    end,
}
-- your plugin config
return user

-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, rhs, options) 93
-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, value, {}) 95
