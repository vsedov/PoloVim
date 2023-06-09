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
    pylance = true,
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
    sqls = {
        root_dir = require("lspconfig").util.root_pattern(".git"),
        single_file_support = false,
        on_new_config = function(new_config, new_rootdir)
            table.insert(new_config.cmd, "-config")
            table.insert(new_config.cmd, new_rootdir .. "/.config.yaml")
        end,
    },
    jedi_language_server = require("modules.lsp.lsp.providers.python.jedi_lang"),
    sourcery = false, -- no clue what this does
    buf = true,
    grammarly = true,
    zls = true,
    ruff_lsp = {}, -- this breaks nvimnavbudy
    lua_ls = {
        settings = {
            Lua = {
                codeLens = { enable = true },
                hint = {
                    enable = true,
                    arrayIndex = "Disable",
                    setType = false,
                    paramName = "Disable",
                    paramType = true,
                },
                format = { enable = false },
                diagnostics = {
                    globals = {
                        "vim",
                        "P",
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "packer_plugins",
                        "pending",
                    },
                },
                completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
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
