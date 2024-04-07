local tpope = require("core.pack").package

tpope({
    "tpope/vim-eunuch",
    cmd = {
        "Delete",
        "Unlink",
        "Move",
        "Rename",
        "Chmod",
        "Mkdir",
        "Cfind",
        "Clocate",
        "Lfind",
        "Wall",
    },
})
tpope({
    "tpope/vim-repeat",
    lazy = true,
    event = lambda.event.default,
})
