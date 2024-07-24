-- env = vim
-- SOURCERY
return {
    init_options = {
        token = os.getenv("SOURCERY"),
        extension_version = "vim.lsp",
        editor_version = "vim",
    },
}
