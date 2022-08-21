-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
local fn = vim.fn
local enhance_attach = require("modules.lsp.lsp.config").enhance_attach

local servers = {
    tsserver = true,
    graphql = true,
    jsonls = true,
    bashls = true,
    terraformls = true,
    marksman = true,
    gopls = {
        settings = {
            gopls = {
                gofumpt = true,
                codelenses = {
                    generate = true,
                    gc_details = false,
                    test = true,
                    tidy = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    unusedparams = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-node_modules" },
            },
        },
    },
    yamlls = {
        settings = {
            yaml = {
                customTags = {
                    "!reference sequence", -- necessary for gitlab-ci.yaml files
                },
            },
        },
    },
    sqls = function()
        return {
            root_dir = require("lspconfig").util.root_pattern(".git"),
            single_file_support = false,
            on_new_config = function(new_config, new_rootdir)
                table.insert(new_config.cmd, "-config")
                table.insert(new_config.cmd, new_rootdir .. "/.config.yaml")
            end,
        }
    end,
    sourcery = false, -- no clue what this does
}

return function(name)
    local config = servers[name]
    if not config then
        return
    end
    local t = type(config)
    if t == "boolean" then
        config = enhance_attach({})
    end
    if t == "function" then
        config = config()
    end
    return enhance_attach(config)
end
