-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
local fn = vim.fn
local path = require("mason-core.path")
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
    sqls = {
        root_dir = require("lspconfig").util.root_pattern(".git"),
        single_file_support = false,
        on_new_config = function(new_config, new_rootdir)
            table.insert(new_config.cmd, "-config")
            table.insert(new_config.cmd, new_rootdir .. "/.config.yaml")
        end,
    },
    sourcery = false, -- no clue what this does
    buf = true,
    grammarly = true,
    zls = true,
    ruff_lsp = true,
    lua_ls = {
        settings = {
            Lua = {
                codeLens = { enable = true },
                hint = {
                    enable = true,
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
    -- texlab = true,
    texlab = require("modules.lsp.lsp.providers.latex.texlab"),
    -- ltex = require("modules.lsp.lsp.providers.latex.ltex"),
}

-- local latex_providers = {
-- }
-- vim.tbl_extend("force", servers, latex_providers[lambda.config.lsp.latex])

local lsp_provider = {
    jedi = "modules.lsp.lsp.providers.python.jedi_lang",
    pyright = "modules.lsp.lsp.providers.python.pyright",
}

local config = lambda.config.lsp.python.lsp
local python_lang = nil
if config ~= "pylance" then
    python_lang = require(lsp_provider[config])
    require("lspconfig").jedi_language_server.setup(python_lang)
else
    require("lspconfig").pylance.setup(require("modules.lsp.lsp.providers.python.pylance"))
    python_lang = nil
end

if python_lang ~= nil then
    vim.tbl_extend("force", servers, python_lang)
end

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
