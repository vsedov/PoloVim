-- local fn = vim.fn
local api = vim.api
local fmt = string.format

---@class Autocommand
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
lambda.augroup = function(name, commands)
    local id = api.nvim_create_augroup(name, { clear = true })
    for _, autocmd in ipairs(commands) do
        local is_callback = type(autocmd.command) == "function"
        api.nvim_create_autocmd(autocmd.event, {
            group = name,
            pattern = autocmd.pattern,
            desc = autocmd.description,
            callback = is_callback and autocmd.command or nil,
            command = not is_callback and autocmd.command or nil,
            once = autocmd.once,
            nested = autocmd.nested,
            buffer = autocmd.buffer,
        })
    end
    return id
end

lambda.foreach = function(callback, list)
    for k, v in pairs(list) do
        callback(v, k)
    end
end

lambda.use_local = function(name, path)
    return os.getenv("HOME") .. "/GitHub/neovim/" .. path .. "/" .. name
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
lambda.command = function(name, rhs, opts)
    opts = opts or {}
    api.nvim_create_user_command(name, rhs, opts)
end

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
lambda.source = function(path, prefix)
    if not prefix then
        vim.cmd(fmt("source %s", path))
    else
        vim.cmd(fmt("source %s/%s", vim.g.vim_dir, path))
    end
end

lambda.lib = require("utils.extended_lib.helpers")

-- https://www.reddit.com/r/neovim/comments/sg919r/diff_with_clipboard/
lambda.compare_to_clipboard = function()
    local ftype = vim.api.nvim_eval("&filetype")
    vim.cmd(string.format(
        [[
  vsplit
  enew
  normal! P
  setlocal buftype=nowrite
  set filetype=%s
  diffthis
  bprevious
  execute "normal! \<C-w>\<C-w>"
  diffthis
]],
        ftype
    ))
end
lambda.dump = function(...)
    print(vim.inspect(...))
end

lambda.preserve = function(cmd)
    cmd = string.format("keepjumps keeppatterns execute %q", cmd)
    local original_cursor = vim.fn.winsaveview()
    vim.api.nvim_command(cmd)
    vim.fn.winrestview(original_cursor)
end

lambda.PASTE = function(data)
    if not vim.tbl_islist(data) then
        if type(data) == type("") then
            data = vim.split(data, "\n")
        else
            data = vim.split(vim.inspect(data), "\n")
        end
    end
    vim.paste(data, -1)
end

lambda.p = function(...)
    local vars = vim.tbl_map(vim.inspect, { ... })
    P(unpack(vars))
    return { ... }
end
lambda.PERF = function(msg, ...)
    local args = { ... }
    vim.validate({ func = { args[1], "function" }, message = { msg, "string", true } })
    local func = args[1]
    table.remove(args, 1)
    -- local start = os.time()
    local start = os.clock()
    local data = func(unpack(args))
    msg = msg or "Func reference elpse time:"
    print(msg, ("%.2f s"):format(os.clock() - start))
    -- print(msg, ('%.2f s'):format(os.difftime(os.time(), start)))
    return data
end

-- reformat file by remove \n\t and pretty if it is json
lambda.Format = function(json)
    pcall(vim.cmd, [[%s/\\n/\r/g]])
    pcall(vim.cmd, [[%s/\\t/  /g]])
    pcall(vim.cmd, [[%s/\\"/"/g]])

    -- again
    vim.cmd([[nohl]])
    -- for json run

    if json then
        vim.cmd([[Jsonformat]]) -- :%!jq .
    end
end

lambda.unload = function(lib)
    package.loaded[lib] = nil
end

lambda.dynamic_unload = function(module_name, reload)
    reload = reload or false

    for module, _ in pairs(package.loaded) do
        if module:match(module_name) then
            if string.find(module, require("utils.helpers.helper").escape_pattern) then
                lambda.unload(module)
            end
            if reload then
                require(module)
            end
        end
    end
end

--- Check neovim version
---@param major Major release tag
---@param minor Minor release tag
---@param patch Patch tag
---@return {if all values are greater or qual , version}
lambda.check_version = function(major, minor, patch)
    major = major or 0
    minor = minor or 0
    patch = patch or 0
    local version = vim.version()
    return { version.major >= major and version.minor >= minor and patch >= version.patch, version }
end

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T
---@return T
function lambda.fold(callback, list, accum)
    for k, v in pairs(list) do
        accum = callback(accum, v, k)
        assert(accum ~= nil, "The accumulator must be returned on each iteration")
    end
    return accum
end
