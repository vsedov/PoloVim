-- Quick Note: I think this is a great language server that provides almost everything you would
-- need thoughthere are a few isseus that are a bit annoying, and i hope that they get resolved
-- soon
return {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    init_options = {
        jediSettings = {
            case_insensitive_completion = true,
            add_bracket_after_function = true,
            dynamic_params = true,
            -- Allot of machine learning models that are set from default.
            autoImportModules = { "torch" },
        },
    },
}
