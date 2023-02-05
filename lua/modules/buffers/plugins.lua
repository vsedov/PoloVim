local buffer = require("core.pack").package
local conf = require("modules.buffers.config")
--  ╭────────────────────────────────────────────────────────────────────╮
--  │ very lazy                                                          │
--  ╰────────────────────────────────────────────────────────────────────╯
buffer({
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    config = conf.nvim_bufferline,
    dependencies = { { "stevearc/three.nvim", config = conf.three, lazy = true } },
    lazy = true,
})
--  ──────────────────────────────────────────────────────────────────────

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
    lazy = true,
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
    cmd = {
        "BufKillThis",
        "BufKillNameless",
        "BufKillHidden",
        "BufWipe",
    },
    keys = { "_q" },
    config = conf.close_buffers,
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
