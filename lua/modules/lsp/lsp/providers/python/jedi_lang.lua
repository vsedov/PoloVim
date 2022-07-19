return {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    init_options = {
        jediSettings = {
            autoImportModules = { "pydantic", "torch", "discord.py", "numpy" },
        },
    },
}
