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
user["~/GitHub/Generatorg"] = {
    ft = "python",
    opt = true,
}

-- test: see how it goes
user["simrat39/desktop-notify.nvim"] = {
    opt = true,

}

-- your plugin config
return user
