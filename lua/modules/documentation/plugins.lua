local conf = require("modules.documentation.config")
local docs = require("core.pack").package

docs({ "danymat/neogen", lazy = true, dependencies = { "L3MON4D3/LuaSnip" }, config = conf.neogen })

docs({
    "ranelpadon/python-copy-reference.vim",
    lazy = true,
    ft = "python",
    cmd = {
        "PythonCopyReferenceDotted",
        "PythonCopyReferencePytest",
    },
})

docs({
    "prichrd/refgo.nvim",
    cmd = { "RefCopy", "RefGo" },
})

docs({
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = { "DocsViewToggle" },
    config = conf.nvim_doc_help,
})

docs({
    "KabbAmine/zeavim.vim",
    lazy = true,
    cmd = {
        "Zeavim",
        "ZeavimV",
        "Docset",
    },
})

docs({
    "romainl/vim-devdocs",
    cmd = { "DD" },
    lazy = true,
})

--  TODO: (vsedov) (06:07:10 - 28/10/22): Make hydra so this would be nice to use.
docs({
    "loganswartz/updoc.nvim",
    lazy = true,
    config = true,
})
