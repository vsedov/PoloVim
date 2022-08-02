local M = {}

function M.use_local(name, path)
    return os.getenv("HOME") .. "/GitHub/neovim/" .. path .. "/" .. name
end

return M
