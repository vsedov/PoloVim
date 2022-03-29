local user = {}
local conf = require("modules.user.config")

user["NarutoXY/ytmmusic.lua"] = {
    after = "telescope.nvim",
    cmd = { "YtNotifyPrevious", "YtNotifyNext", "YtNotifyCurrent", "YtVolumeControl" },
    branch = "fix-auth",
    requires = { "rcarriga/nvim-notify", "nvim-lua/plenary.nvim" },
    config = function()
        require("ytmmusic")
        require("telescope").load_extension("ytmmusic")
    end,
}

-- holy jesus this makes this thing laggy
user["~/GitHub/vim-autocorrect/opt/vim-abbrev"] = {
    opt = true,
    setup = function()
        vim.g.abbrev_file = "/home/viv/GitHub/vim-autocorrect/opt/vim-abbrev/plugin/abbrev"
    end,
}
-- user["~/GitHub/Generatorg"] = {
--     ft = "python",
--     opt = true,
--     config = function()
--         require("generatorg")
--     end,
-- }

-- your plugin config
return user

-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, rhs, options) 93
-- vim.api.nvim_set_keymap(mode:sub(i, i), keymap, value, {}) 95
