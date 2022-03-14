-- local leader = wincent.mappings.leader

local M = {}

local function should_mkview()
    return vim.bo.buftype == ""
        and vim.fn.getcmdwintype() == ""
        and M.mkview_filetype_blocklist[vim.bo.filetype] == nil
        and vim.fn.exists("$SUDO_USER") == 0 -- Don't create root-owned files.
end

function M.mkview()
    if should_mkview() then
        local success, err = pcall(function()
            if vim.fn.exists("*haslocaldir") and vim.fn.haslocaldir() then
                -- We never want to save an :lcd command, so hack around it...
                vim.api.nvim_command("cd -")
                vim.api.nvim_command("mkview")
                vim.api.nvim_command("lcd -")
            else
                vim.api.nvim_command("mkview")
            end
        end)
        if not success then
            if
                err:find("%f[%w]E186%f[%W]") == nil -- No previous directory: probably a `git` operation.
                and err:find("%f[%w]E190%f[%W]") == nil -- Could be name or path length exceeding NAME_MAX or PATH_MAX.
                and err:find("%f[%w]E5108%f[%W]") == nil
            then
                error(err)
            end
        end
    end
end

function M.loadview()
    if should_mkview() then
        vim.api.nvim_command("silent! loadview")
        vim.api.nvim_command("silent! " .. vim.fn.line(".") .. "foldopen!")
    end
end

function M.disable_heavy_plugins()
    if
        M.heavy_plugins_blocklist[vim.bo.filetype] ~= nil
        or vim.regex("\\.min\\..*$"):match_str(vim.fn.expand("%:t")) ~= nil
        or vim.fn.getfsize(vim.fn.expand("%")) > 200000
    then
        if vim.fn.exists(":ALEDisableBuffer") == 2 then
            vim.api.nvim_command(":ALEDisableBuffer")
        end
    end
end

return M
