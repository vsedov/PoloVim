local M = {}

M.attach_config = function(client, bufnr)
    require("ltex_extra").setup({
        load_langs = { "en-GB" }, -- table <string> : languages for witch dictionaries will be loaded
        init_check = false, -- boolean : whether to load dictionaries on startup
        path = nil, -- string : path to store dictionaries. Relative path uses current working directory
        log_level = "none", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
    })
end

M.config = {
    filetypes = {
        "NeogitCommitMessage",
        "bib",
        "gitcommit",
        "markdown",
        "norg",
        "org",
        "plaintex",
        "rnoweb",
        "rst",
        "tex",
    },
    settings = {
        ltex = {
            language = "en-GB",
            additionalRules = {
                enablePickyRules = false,
            },
            checkFrequency = "save",
        },
    },
}

return M
