return {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    init_options = {
        jediSettings = {
            autoImportModules = { "torchvision", "torch", "numpy" },
        },
    },
}
