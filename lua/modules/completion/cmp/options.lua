return {
    use_tabnine = {
        enable = true,
        options = {
            name = "cmp_tabnine",
            priority = 5,
        },
    },
    use_rg = {
        enable = false,
        options = {
            name = "rg",
            additional_arguments = "--max-depth 8",
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
}
