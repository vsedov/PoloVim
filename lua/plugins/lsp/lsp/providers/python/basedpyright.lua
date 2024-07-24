local M = {}

M.attach_config = function(client, bufnr) end
M.config = {
    settings = {
        pyright = {
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                ignore = { "*" },
            },
        },
    },
}
return M
