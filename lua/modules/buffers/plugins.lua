local conf = require("modules.buffers.config")
local buffer = require("core.pack").package

buffer({
    "akinsho/bufferline.nvim",
    config = conf.nvim_bufferline,
    opt = true,
})

buffer({
    "nanozuki/tabby.nvim",
    config = conf.tabby,
    opt = true,
})

buffer({
    "toppair/reach.nvim",
    config = conf.reach,
    opt = true,
    cmd = { "ReachOpen" },
})
buffer({
    "ghillb/cybu.nvim",
    requires = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = conf.cybu,
    -- opt = true,
    cmd = {
        "CybuNext",
        "CybuPrev",
        "CybuLastusedPrev",
        "CybuLastusedNext",
    },
})

buffer({
    "tiagovla/scope.nvim",
    opt = true,
    config = conf.scope,
})

buffer({ "jlanzarotta/bufexplorer", cmd = "BufExplorer" })

buffer({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

buffer({
    "kazhala/close-buffers.nvim",
    cmd = { "Kwbd", "BDelete", "BWipeout" },
    module = "close-buffers",
    config = conf.buffers_close,
})

buffer({
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
    keys = { "_q" },
    config = conf.bbye,
})

buffer({
    "stevearc/stickybuf.nvim",
    opt = true,
    cmd = { "PinBuffer", "PinBuftype", "PinBuftype", "UnpinBuffer" },
    config = conf.sticky_buf,
})

buffer({
    "nyngwang/NeoZoom.lua",
    branch = "neo-zoom-original", -- UNCOMMENT THIS, if you prefer the old one
    cmd = { "NeoZoomToggle" },
})
buffer({
    "nyngwang/NeoNoName.lua",
    cmd = { "NeoNoName" },
})
