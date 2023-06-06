local M = {}

local path = require("lspconfig.util").path

local function get_pipenv_dir()
    return vim.fn.trim(vim.fn.system("pipenv --venv"))
end

local function get_poetry_dir()
    return vim.fn.trim(vim.fn.system("poetry env info -p"))
end

local function get_pdm_package()
    return vim.fn.trim(vim.fn.system("pdm info --packages"))
end

local function get_python_dir(workspace)
    local poetry_match = vim.fn.glob(path.join(workspace, "poetry.lock"))
    if poetry_match ~= "" then
        return get_poetry_dir()
    end

    local pipenv_match = vim.fn.glob(path.join(workspace, "Pipfile.lock"))
    if pipenv_match ~= "" then
        return get_pipenv_dir()
    end

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({ "*", ".*" }) do
        local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
        if match ~= "" then
            return path.dirname(match)
        end
    end

    return ""
end

local _virtual_env = ""
local _package = ""

local function py_bin_dir()
    return path.join(_virtual_env, "bin:")
end

M.env = function(root_dir)
    if not vim.env.VIRTUAL_ENV or vim.env.VIRTUAL_ENV == "" then
        _virtual_env = get_python_dir(root_dir)
    end

    if _virtual_env ~= "" then
        vim.env.VIRTUAL_ENV = _virtual_env
        vim.env.PATH = py_bin_dir() .. vim.env.PATH
    end

    if _virtual_env ~= "" and vim.env.PYTHONHOME then
        vim.env.old_PYTHONHOME = vim.env.PYTHONHOME
        vim.env.PYTHONHOME = ""
    end

    return _virtual_env ~= "" and py_bin_dir() or ""
end

-- PEP 582 support
M.pep582 = function(root_dir)
    local pdm_match = vim.fn.glob(path.join(root_dir, "pdm.lock"))
    if pdm_match ~= "" then
        _package = get_pdm_package()
    end

    if _package ~= "" then
        return path.join(_package, "lib")
    end
end

M.conda = function(root_dir) end

return M
