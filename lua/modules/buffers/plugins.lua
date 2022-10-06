local conf = require("modules.buffers.config")
local buffer = require("core.pack").package

buffer({ "jlanzarotta/bufexplorer", cmd = "BufExplorer" })

buffer({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

buffer({
    "toppair/reach.nvim",
    config = conf.reach,
    opt = true,
    cmd = { "ReachOpen" },
})

buffer({
    "tiagovla/scope.nvim",
    opt = true,
    setup = conf.scope_setup,
    config = conf.scope,
})

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
