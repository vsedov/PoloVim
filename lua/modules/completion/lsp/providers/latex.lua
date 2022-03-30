local tex_preview_settings = {}
local forward_search_executable = "zathura"
local sumatrapdf_args = {
    "-reuse-instance",
    "%p",
    "-forward-search",
    "%f",
    "%l",
}
local evince_args = { "-f", "%l", "%p", '"code -g %f:%l"' }
local okular_args = { "--unique", "file:%p#src:%l%f" }
local zathura_args = { "--synctex-forward", "%l:1:%f", "%p" }
local qpdfview_args = { "--unique", "%p#src:%f:%l:1" }
local skim_args = { "%l", "%p", "%f" }
tex_preview_settings = zathura_args

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
                args = tex_preview_settings,
                executable = forward_search_executable,
            },
            latexFormatter = "latexindent",
        },
    },
}
return settings
