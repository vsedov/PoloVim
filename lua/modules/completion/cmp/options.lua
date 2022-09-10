return {
    use_tabnine = {
        enable = lambda.config.cmp.use_tabnine,
        options = {
            name = "cmp_tabnine",
            priority = 7,
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
        enable = true,
        options = {
            name = "cmp_overseer",
        },
    },
    use_lab = {
        enable = true,
        options = {
            name = "lab.quick_data",
            keyword_length = 4,
        },
    },
}
