return {
    use_codeium = {
        enable = true,
        options = {
            name = "codeium",
            priority = 7,
        },
    },
    use_tabnine = {
        enable = lambda.config.cmp.tabnine.use_tabnine,
        options = {
            name = "cmp_tabnine",
            priority = lambda.config.cmp.tabnine.tabnine_priority, -- Make tabnine have the same priority as lsp
        },
    },
    use_rg = {
        enable = lambda.config.cmp.use_rg,
        options = {
            name = "rg",
            options = {
                keyword_length = 3,
                option = {
                    additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/utils/abbreviations/dictionary.lua",
                },
            },
        },
    },
    use_path = {
        enable = true,
        options = {
            name = "path",
        },
    },
    use_overseer = {
        enable = true,
        options = {
            name = "cmp_overseer",
        },
    },
    use_lab = {
        enable = false,
        options = {
            name = "lab.quick_data",
            keyword_length = 4,
        },
    },
}
