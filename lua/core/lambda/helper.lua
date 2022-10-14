-- https://github.com/akinsho/dotfiles/blob/nightly/.config/nvim/lua/as/globals.lua
local fn = vim.fn
local api = vim.api
local fmt = string.format
local l = vim.log.levels

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
----------------------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------------------

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T?
---@return T
function lambda.fold(callback, list, accum)
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
function lambda.map(callback, list)
    return lambda.fold(function(accum, v, k)
        accum[#accum + 1] = callback(v, k, accum)
        return accum
    end, list, {})
end

---@generic T : table
---@param callback fun(T, key: string | number): T
---@param list T[]
function lambda.foreach(callback, list)
    for k, v in pairs(list) do
        callback(v, k)
    end
end

--- Check if the target matches  any item in the list.
---@param target string
---@param list string[]
---@return boolean
function lambda.any(target, list)
    for _, item in ipairs(list) do
        if target:match(item) then
            return true
        end
    end
    return false
end

---Find an item in a list
---@generic T
---@param matcher fun(arg: T):boolean
---@param haystack T[]
---@return T
function lambda.find(matcher, haystack)
    local found
    for _, needle in ipairs(haystack) do
        if matcher(needle) then
            found = needle
            break
        end
    end
    return found
end

lambda.list_installed_plugins = (function()
    local plugins
    return function()
        if plugins then
            return plugins
        end
        local data_dir = fn.stdpath("data")
        local start = fn.expand(data_dir .. "/site/pack/packer/start/*", true, true)
        local opt = fn.expand(data_dir .. "/site/pack/packer/opt/*", true, true)
        plugins = vim.list_extend(start, opt)
        return plugins
    end
end)()

---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function lambda.plugin_installed(plugin_name)
    for _, path in ipairs(lambda.list_installed_plugins()) do
        if vim.endswith(path, plugin_name) then
            return true
        end
    end
    return false
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function lambda.plugin_loaded(plugin_name)
    local plugins = packer_plugins or {}
    return plugins[plugin_name] and plugins[plugin_name].loaded
end

---Check whether or not the location or quickfix list is open
---@return boolean
function lambda.is_vim_list_open()
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        local location_list = fn.getloclist(0, { filewinid = 0 })
        local is_loc_list = location_list.filewinid > 0
        if vim.bo[buf].filetype == "qf" or is_loc_list then
            return true
        end
    end
    return false
end

---------------------------------------------------------------------------------
-- Toggle list
---------------------------------------------------------------------------------
--- Utility function to toggle the location or the quickfix list
---@param list_type '"quickfix"' | '"location"'
---@return string?
local function toggle_list(list_type)
    local is_location_target = list_type == "location"
    local cmd = is_location_target and { "lclose", "lopen" } or { "cclose", "copen" }
    local is_open = lambda.is_vim_list_open()
    if is_open then
        return vim.cmd[cmd[1]]()
    end
    local list = is_location_target and fn.getloclist(0) or fn.getqflist()
    if vim.tbl_isempty(list) then
        local msg_prefix = (is_location_target and "Location" or "QuickFix")
        return vim.notify(msg_prefix .. " List is Empty.", vim.log.levels.WARN)
    end

    local winnr = fn.winnr()
    vim.cmd[cmd[2]]()
    if fn.winnr() ~= winnr then
        vim.cmd.wincmd("p")
    end
end

function lambda.toggle_qf_list()
    toggle_list("quickfix")
end
function lambda.toggle_loc_list()
    toggle_list("location")
end

---@param str string
---@param max_len integer
---@return string
function lambda.truncate(str, max_len)
    assert(str and max_len, "string and max_len must be provided")
    return api.nvim_strwidth(str) > max_len and str:sub(1, max_len) .. lambda.style.icons.misc.ellipsis or str
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function lambda.empty(item)
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

---Require a module using `pcall` and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function lambda.require(module, opts)
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
        vim.schedule(function()
            vim.notify(msg, l.ERROR, { title = "ERROR" })
        end)
    end, unpack(args))
end

---@alias Plug table<(string | number), string>

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
--- TODO: find out if it's possible to annotate the plugin as a module
---@param name string | Plug
---@param callback fun(module: table)
function lambda.ftplugin_conf(name, callback)
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

---Reload lua modules
---@param path string
---@param recursive boolean
function lambda.invalidate(path, recursive)
    if recursive then
        for key, value in pairs(package.loaded) do
            if key ~= "_G" and value and fn.match(key, path) ~= -1 then
                package.loaded[key] = nil
                require(key)
            end
        end
    else
        package.loaded[path] = nil
        require(path)
    end
end

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

---Check that the current nvim version is greater than or equal to the given version
---@param major number
---@param minor number
---@param _ number patch
---@return unknown
function lambda.version(major, minor, _)
    assert(major and minor, "major and minor must be provided")
    local v = vim.version()
    return major >= v.major and minor >= v.minor
end

P = vim.pretty_print

--- Validate the keys passed to lambda.augroup are valid
---@param name string
---@param cmd Autocommand
local function validate_autocmd(name, cmd)
    local keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }
    local incorrect = lambda.fold(function(accum, _, key)
        if not vim.tbl_contains(keys, key) then
            table.insert(accum, key)
        end
        return accum
    end, cmd, {})
    if #incorrect == 0 then
        return
    end
    vim.schedule(function()
        vim.notify("Incorrect keys: " .. table.concat(incorrect, ", "), "error", {
            title = fmt("Autocmd: %s", name),
        })
    end)
end

---@class AutocmdArgs
---@field id number
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] list of autocommand events
---@field pattern string | string[] list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function lambda.augroup(name, commands)
    assert(name ~= "User", "The name of an augroup CANNOT be User")
    assert(#commands > 0, fmt("You must specify at least one autocommand for %s", name))
    local id = api.nvim_create_augroup(name, { clear = true })
    for _, autocmd in ipairs(commands) do
        validate_autocmd(name, autocmd)
        local is_callback = type(autocmd.command) == "function"
        api.nvim_create_autocmd(autocmd.event, {
            group = name,
            pattern = autocmd.pattern,
            desc = autocmd.desc,
            callback = is_callback and autocmd.command or nil,
            command = not is_callback and autocmd.command or nil,
            once = autocmd.once,
            nested = autocmd.nested,
            buffer = autocmd.buffer,
        })
    end
    return id
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
function lambda.command(name, rhs, opts)
    opts = opts or {}
    api.nvim_create_user_command(name, rhs, opts)
end

---Check if a cmd is executable
---@param e string
---@return boolean
function lambda.executable(e)
    return fn.executable(e) > 0
end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return string
function lambda.replace_termcodes(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function lambda.has(feature)
    return vim.fn.has(feature) > 0
end

function lambda.lazy_load(event, plugin_name, condition)
    if type(condition) == "function" then
        condition = condition()
    end
    if type(plugin_name) == "function" then
        plugin_name = plugin_name()
    end
    vim.api.nvim_create_autocmd(event, {
        pattern = "*",
        callback = function()
            if condition then
                require("packer").loader(plugin_name)
            end
        end,
        once = true,
    })
end

function lambda.lazy_load(tb)
    for i, v in pairs(tb) do
        if type(v) == "function" then
            tb[i] = v()
        end
    end
    api.nvim_create_autocmd(tb.events, {
        group = api.nvim_create_augroup(tb.augroup_name, {}),
        callback = function()
            if tb.condition then
                vim.api.nvim_del_augroup_by_name(tb.augroup_name)
                if tb.plugin ~= "nvim-treesitter" then
                    vim.defer_fn(function()
                        require("packer").loader(tb.plugin)
                    end, 0)
                else
                    require("packer").loader(tb.plugin)
                end
            end
        end,
        once = true,
    })
end
function lambda.clever_tcd()
    local root = require("lspconfig").util.root_pattern("Project.toml", ".git")(vim.api.nvim_buf_get_name(0))
    if root == nil then
        root = " %:p:h"
    end
    vim.cmd("tcd " .. root)
    vim.cmd("pwd")
end
