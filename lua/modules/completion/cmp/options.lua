return {
    use_tabnine = {
        enable = lambda.config.cmp.tabnine.use_tabnine,
        options = {
            name = "cmp_tabnine",
            keyword_length = 0,
            priority = lambda.config.cmp.tabnine.tabnine_priority, -- Make tabnine have the same priority as lsp
        },
    },
    use_rg = {
        enable = lambda.config.cmp.use_rg,
        options = {
            name = "rg",
            keyword_length = 4,
            max_item_count = 10,
            option = { additional_arguments = "--max-depth 8" },
        },
    },
    use_neorg = {
        enable = true,
        options = {
            name = "neorg",
            priority = 6,
        },
    },
    use_path = {
        enable = true,
        options = {
            name = "path",
        },
    },
    use_overseer = {
        enable = false,
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
