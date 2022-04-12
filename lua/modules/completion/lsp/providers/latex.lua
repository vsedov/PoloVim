local forward_search_executable = "zathura"
local zathura_args = { "--synctex-forward", "%l:1:%f", "%p" }

local settings = {
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
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "%f",
                },
                on_save = false,
                forward_search_after = false,
            },
            chktex = {
                on_open_and_save = false,
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
                signs = true,
                underline = true,
            },
            linters = { "chktex" },
            auto_save = false,
            ignore_errors = {},
            diagnosticsDelay = 300,
            formatterLineLength = 120,
            forwardSearch = {
                args = zathura_args,
                executable = forward_search_executable,
            },
            latexFormatter = "latexindent",
        },
    },
}
return settings
