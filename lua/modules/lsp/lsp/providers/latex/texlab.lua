local forward_search_executable = "zathura"
local zathura_args = { "--synctex-forward", "%l:1:%f", "%p" }

local sioyk_search_executable = "sioyek"
local sioyk_args = {
    "--reuse-window",
    "--inverse-search",
    [[nvim-texlabconfig -file %1 -line %2]],
    "--forward-search-file",
    "%f",
    "--forward-search-line",
    "%l",
    "%p",
}

return {
    cmd = { "texlab" },
    filetypes = { "tex", "bib" },
    settings = {
        texlab = {
            auxDirectory = nil,
            bibtexFormatter = "texlab",
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-shell-escape",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "%f",
                },
                on_save = true,
                forward_search_after = false,
            },
            chktex = {
                on_open_and_save = true,
                on_edit = false,
            },
            forward_search = {
                executable = nil,
                args = {},
            },
            latexindent = {
                ["local"] = nil,
                modify_line_breaks = false,
            },
            diagnostics = {
                virtual_text = { spacing = 0, prefix = "" },
                signs = false,
                underline = true,
            },
            linters = { "chktex" },
            auto_save = true,
            ignore_errors = {},
            diagnosticsDelay = 500,
            formatterLineLength = 300,
            forwardSearch = {
                args = sioyk_args,
                executable = sioyk_search_executable,
            },
            latexFormatter = "latexindent",
        },
    },
}
