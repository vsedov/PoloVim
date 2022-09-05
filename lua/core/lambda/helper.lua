local fn = vim.fn
local api = vim.api
local fmt = string.format
local l = vim.log.levels

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
            lambda.unload(module)
            vim.notify(module .. "Unloaded succesfully ")
            if reload then
                require(module)
            end
        end
    end
end
--- Check neovim version
---@param major integer Major release tag
---@param minor integer Minor release tag
---@param patch integer Patch tag
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
lambda.fold = function(callback, list, accum)
    accum = accum or {}
    for k, v in pairs(list) do
        accum = callback(accum, v, k)
        assert(accum ~= nil, "The accumulator must be returned on each iteration")
    end
    return accum
end

---@generic T : table
---@param callback fun(item: T, key: string | number, list: T[]): T
---@param list T[]
---@return T[]
lambda.map = function(callback, list)
    return lambda.fold(function(accum, v, k)
        accum[#accum + 1] = callback(v, k, accum)
        return accum
    end, list, {})
end

--- Search loaded packages
---@param package_name string If a package contains or has a certain string it
-- will returnvalue
lambda.is_loaded = function(package_name)
    return lambda.lib.when(package.loaded[package_name] ~= nil, function()
        return package.loaded[package_name]
    end, function()
        for i, v in pairs(package.loaded) do
            if string.find(i, package_name) then
                return true
            end
        end
        return false
    end)
end

---Find an item in a list
---@generic T
---@param matcher fun(arg: T):boolean
---@param haystack T[]
---@return T
lambda.find = function(matcher, haystack)
    local found
    for _, needle in ipairs(haystack) do
        if matcher(needle) then
            found = needle
            break
        end
    end
    return found
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@vararg any
---@return boolean, any
---@overload fun(fun: function, ...): boolean, any
function lambda.wrap_err(msg, func, ...)
    local args = { ... }
    if type(msg) == "function" then
        args, func, msg = { func, unpack(args) }, msg, nil
    end
    return xpcall(func, function(err)
        msg = msg and fmt("%s:\n%s", msg, err) or err
        local info = debug.getinfo(2, "S")
        local title = fmt("ERROR(%s:%d)", fn.fnamemodify(info.short_src, ":~:."), info.linedefined)
        vim.schedule(function()
            vim.notify(msg, l.ERROR, { title = title })
        end)
    end, unpack(args))
end
---Determine if a value of any type is empty
---@param item any
---@return boolean?
-- TODO(vsedov) (22:01:48 - 23/08/22): refactor using lambda.lib
lambda.empty = function(item)
    if not item then
        return true
    end
    local item_type = type(item)
    if item_type == "string" then
        return item == ""
    end
    if item_type == "number" then
        return item <= 0
    end
    if item_type == "table" then
        return vim.tbl_isempty(item)
    end
    return item ~= nil
end
lambda.execute_keys = function(feedkeys)
    local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
    vim.api.nvim_feedkeys(keys, "x", false)
end

---Require a module using `pcall` and report any errors
---@param module string
---@param opts table?
---@return boolean, any
lambda.require = function(module, opts)
    opts = opts or { silent = false }
    local ok, result = pcall(require, module)
    if not ok and not opts.silent then
        if opts.message then
            result = opts.message .. "\n" .. result
        end
        vim.notify(result, l.ERROR, { title = fmt("Error requiring: %s", module) })
    end
    return ok, result
end
---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
lambda.plugin_loaded = function(plugin_name)
    local plugins = packer_plugins or {}
    return plugins[plugin_name] and plugins[plugin_name].loaded
end
---@alias Plug table<(string | number), string>

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
--- TODO: find out if it's possible to annotate the plugin as a module
---@param name string | Plug
---@param callback fun(module: table)
lambda.ftplugin_conf = function(name, callback)
    local plugin_name = type(name) == "table" and name.plugin or nil
    if plugin_name and not lambda.plugin_loaded(plugin_name) then
        return
    end

    local module = type(name) == "table" and name[1] or name
    local info = debug.getinfo(1, "S")
    local ok, plugin = lambda.require(module, { message = fmt("In file: %s", info.source) })

    if ok then
        callback(plugin)
    end
end

--- Check if the target matches  any item in the list.
---@param target string
---@param list string[]
---@return boolean
lambda.any = function(target, list)
    for _, item in ipairs(list) do
        if target:match(item) then
            return true
        end
    end
    return false
end
