local conf = require("modules.latex.config")
local latex = require("core.pack").package
local filetype = { "latex", "tex" }
latex({
    "lervag/vimtex",
    lazy = true,
    ft = filetype,
    init = conf.vimtex,
})

latex({
    "jakewvincent/texmagic.nvim",
    ft = filetype,
    config = function()
        -- Run setup and specify two custom build engines
        require("texmagic").setup({
            engines = {
                pdflatex = { -- This has the same name as a default engine but would
                    -- be preferred over the same-name default if defined
                    executable = "latexmk",
                    args = {
                        "-pdflatex",
                        "-interaction=nonstopmode",
                        "-synctex=1",
                        "-outdir=.build",
                        "-pv",
                        "%f",
                    },
                    isContinuous = false,
                },
                lualatex = { -- This is *not* one of the defaults, but it can be
                    -- called via magic comment if defined here
                    executable = "latexmk",
                    args = {
                        "-pdflua",
                        "-interaction=nonstopmode",
                        "-synctex=1",
                        "-pv",
                        "%f",
                    },
                    isContinuous = false,
                },
            },
        })
    end,
})
