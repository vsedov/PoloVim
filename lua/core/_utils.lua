local utils = {}

--- Get absolute path to the calling module
--
---@return string
utils.get_current_module_directory = function()
    -- get the abs path to current module
    local path = debug.getinfo(2, "S").source

    -- remove the "@" character at the beginning if it's there
    if path:sub(1, 1) == "@" then
        path = path:sub(2)
    end

    -- get the directory part of the path
    return vim.fn.fnamemodify(path, ":h")
end

--- Get list of files in a directory
--
---@param dir string
---@return table? list of files if dir exists else nil
utils.get_files_in_directory = function(dir)
    local files = {}
    local p = io.popen('ls "' .. dir .. '"')
    if p then
        for file in p:lines() do
            table.insert(files, file)
        end
        p:close()
    else
        vim.notify("unable to open directory " .. dir, vim.log.levels.ERROR)
        return nil
    end
    return files
end
return utils
