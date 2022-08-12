-- Quick Note: I think this is a great language server that provides almost everything you would
-- need thoughthere are a few isseus that are a bit annoying, and i hope that they get resolved
-- soon
return {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    init_options = {
        jediSettings = {
            autoImportModules = { "torch", "torchvision", "numpy", "matplotlib", "os", "PIL" },
        },
        -- completion = {
        --     resolveEagerly = true
        -- }
    },
}
