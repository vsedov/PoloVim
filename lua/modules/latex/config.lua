local config = {}
function config.vimtex()
    vim.g.vimtex_view_method = "sioyek" -- sioyek
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
            "-f",
            "-pdf",
            "-shell-escape",
            "-pdflatex",
            "-interaction=nonstopmode",
            "-synctex=1",
            "-outdir=.build",
            "-pvc",
        },
    }
    vim.g.vimtex_imaps_enabled = true
    -- TOC settings
    vim.g.vimtex_toc_config = {
        name = "TOC",
        layers = "['content', 'todo']",
        resize = 1,
        split_width = 50,
        todo_sorted = 0,
        show_help = 1,
        show_numbers = 1,
        mode = 2,
    }

    -- Ignore undesired errors and warnings
    vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "undefined references",
        "(re)run Biber",
        "Unused global option(s)",
    }

    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtext_quickfix_mode = 1
    -- QuickFix is just annoying
    vim.g.vimtex_quickfix_enabled = 0
end
function config.texmagic()
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
                isContinuous = true,
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
    local lspconfig = require("lspconfig")
    local enhance_attach = require("modules.lsp.lsp.config").enhance_attach
    local latex_setup = {
        texlab = function()
            lspconfig.texlab.setup(enhance_attach(require("modules.lsp.lsp.providers.latex.texlab")))
        end,
        ltex = function()
            lspconfig.ltex.setup(enhance_attach(require("modules.lsp.lsp.providers.latex.ltex").config))
        end,
    }
    latex_setup[lambda.config.lsp.latex]()
end
function config.papis()
    require("papis").setup({
        -- These are configuration options of the `papis` program relevant to papis.nvim.
        -- Papis.nvim can get them automatically from papis, but this is very slow. It is
        -- recommended to copy the relevant settings from your papis configuration file.
        papis_python = {
            dir = "/home/viv/Documents/papers/",
            info_name = "info.yaml", -- (when setting papis options `-` is replaced with `_`
            -- in the keys names)
            notes_name = [[notes.norg]],
        },
        enable_keymaps = true,
    })
end
return config
