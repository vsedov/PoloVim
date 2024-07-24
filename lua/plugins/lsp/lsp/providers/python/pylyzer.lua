local py = require("modules.lsp.lsp.providers.python.utils.python_help")
local path = require("mason-core.path")
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then
    return
end
local caps = vim.lsp.protocol.make_client_capabilities()
caps = cmp_nvim_lsp.default_capabilities(caps)
caps.textDocument.completion.completionItem.snippetSupport = true

local util = require("lspconfig").util
return {
    -- filetypes = { "python" },
    -- root_dir = function(fname)
    --     local root_files = {
    --         "setup.py",
    --         "tox.ini",
    --         "requirements.txt",
    --         "Pipfile",
    --         "pyproject.toml",
    --     }
    --     return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    -- end,
    -- settings = {
    --     python = {
    --         diagnostics = false,
    --         inlayHints = true,
    --         smartCompletion = false,
    --         checkOnType = false,
    --     },
    -- },
    -- capabilities = caps,
    -- on_init = function(client)
    --     client.config.settings.python.pythonPath = (function(workspace)
    --         if vim.env.VIRTUAL_ENV then
    --             return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    --         end
    --         if vim.fn.filereadable(path.concat({ workspace, "poetry.lock" })) then
    --             local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    --             return path.concat({ venv, "bin", "python" })
    --         end
    --         local pep582 = py.pep582(client)
    --         if pep582 ~= nil then
    --             client.config.settings.python.analysis.extraPaths = { pep582 }
    --         end
    --         return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
    --     end)(client.config.root_dir)
    -- end,
    -- before_init = function(_, config)
    --     config.settings.python.analysis.stubPath = path.concat({
    --         vim.fn.stdpath("data"),
    --         "lazy",
    --         "python-type-stubs",
    --     })
    -- end,
}
