-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
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
    buf = true,
    grammarly = true,
    zls = true,
    luau_lsp = function()
        require("luau-lsp").setup({
            sourcemap = {
                enabled = true,
                autogenerate = true, -- automatic generation when the server is attached
                rojo_project_file = "default.project.json",
            },
            types = {
                roblox = true,
                roblox_security_level = "PluginSecurity",
            },
        })
    end,
    lua_ls = {
        settings = {
            Lua = {
                IntelliSense = {
                    traceLocalSet = true,
                },
                codeLens = { enable = false },
                hint = {
                    enable = false,
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
    ruff_ls = true,
    semgrep = true,
}

local con = lambda.config.lsp.python.lsp
local function isPythonServerFileReadable(server)
    local serverFilePath = "~/.config/nvim/lua/modules/lsp/lsp/providers/python/" .. server .. ".lua"
    return vim.fn.filereadable(vim.fn.expand(serverFilePath)) ~= 0
end

local function addServerWithSettings(server, settings)
    servers[server] = { settings = settings }
end

local function addServerByRequire(server)
    servers[server] = require("modules.lsp.lsp.providers.python." .. server)
end

local function addPythonServer(server)
    if server == "pylance" then
        -- It looks like you want to print a message for "pylance",
        -- but it's not clear what should happen here.
        print("NEed to add this")
        return
    end

    -- If the server file is not readable, handle special server cases
    if not isPythonServerFileReadable(server) then
        if server == "basedpyright" then
            addServerWithSettings(server, { basedpyright = { typeCheckingMode = "standard" } })
            return
        elseif server == "sourcery" and lambda.config.lsp.python.use_sourcery then
            addServerByRequire(server)
            return
        end
        return
    end

    -- Default case for adding a server
    addServerByRequire(server)
end

for _, server in ipairs(con) do
    addPythonServer(server)
end

if lambda.config.lsp.latex == "texlab" then
    servers["texlab"] = require("modules.lsp.lsp.providers.latex.texlab")
else
    require("lspconfig").ltex.setup({})
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
