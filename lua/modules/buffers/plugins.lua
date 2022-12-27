local buffer = require("core.pack").package
local conf = require("modules.buffers.config")

buffer({
    "akinsho/bufferline.nvim",
    config = conf.nvim_bufferline,
    lazy = true,
})

buffer({
    "toppair/reach.nvim",
    config = conf.reach,
    lazy = true,
    cmd = { "ReachOpen" },
})
buffer({
    "ghillb/cybu.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = conf.cybu,
    -- lazy = true,
    cmd = {
        "CybuNext",
        "CybuPrev",
        "CybuLastusedPrev",
        "CybuLastusedNext",
    },
})

buffer({
    "tiagovla/scope.nvim",
    lazy = true,
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
    lazy = true,
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
