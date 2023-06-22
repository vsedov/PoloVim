-- https://github.com/akinsho/dotfiles/blob/nightly/.config/nvim/lua/as/globals.lua
local fn = vim.fn
local api = vim.api
local fmt = string.format
local l = vim.log.levels
P = vim.pretty_print

_G.lprint = require("utils.logs.log").lprint
lambda.use_local = function(name, path)
    return os.getenv("HOME") .. "/GitHub/neovim/" .. path .. "/" .. name
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

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@param ... any
---@return boolean, any
---@overload fun(func: function, ...): boolean, any
function lambda.pcall(msg, func, ...)
    local args = { ... }
    if type(msg) == "function" then
        local arg = func --[[@as any]]
        args, func, msg = { arg, unpack(args) }, msg, nil
    end
    return xpcall(func, function(err)
        msg = debug.traceback(msg and fmt("%s:\n%s\n%s", msg, vim.inspect(args), err) or err)
        vim.schedule(function()
            vim.notify(msg, l.ERROR, { title = "ERROR" })
        end)
    end, unpack(args))
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

--- Autosize horizontal split to match its minimum content
--- https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
---@param min_height number
---@param max_height number
function lambda.adjust_split_height(min_height, max_height)
    api.nvim_win_set_height(0, math.max(math.min(fn.line("$"), max_height), min_height))
end

---------------------------------------------------------------------------------
-- Quickfix and Location List
---------------------------------------------------------------------------------

lambda.list = { qf = {}, loc = {} }

---@param list_type "loclist" | "quickfix"
---@return boolean
local function is_list_open(list_type)
    return vim.iter(fn.getwininfo()):find(function(win)
        return not lambda.falsy(win[list_type])
    end) ~= nil
end

local silence = { mods = { silent = true, emsg_silent = true } }

---@param callback fun(...)
local function preserve_window(callback, ...)
    local win = api.nvim_get_current_win()
    callback(...)
    if win ~= api.nvim_get_current_win() then
        cmd.wincmd("p")
    end
end

function lambda.list.qf.toggle()
    if is_list_open("quickfix") then
        cmd.cclose(silence)
    elseif #fn.getqflist() > 0 then
        preserve_window(cmd.copen, silence)
    end
end

function lambda.list.loc.toggle()
    if is_list_open("loclist") then
        cmd.lclose(silence)
    elseif #fn.getloclist(0) > 0 then
        preserve_window(cmd.lopen, silence)
    end
end

-- @see: https://vi.stackexchange.com/a/21255
-- using range-aware function
-- @see: https://vi.stackexchange.com/a/21255
-- using range-aware function
function lambda.list.qf.delete(buf)
    buf = buf or api.nvim_get_current_buf()
    local list = fn.getqflist()
    local line = api.nvim_win_get_cursor(0)[1]
    if api.nvim_get_mode().mode:match("[vV]") then
        local first_line = fn.getpos("'<")[2]
        local last_line = fn.getpos("'>")[2]
        list = vim.iter(ipairs(list)):filter(function(i)
            return i < first_line or i > last_line
        end)
    else
        table.remove(list, line)
    end
    -- replace items in the current list, do not make a new copy of it; this also preserves the list title
    fn.setqflist({}, "r", { items = list })
    fn.setpos(".", { buf, line, 1, 0 }) -- restore current line
end

---------------------------------------------------------------------------------

function lambda.installed_plugins()
    local ok, lazy = pcall(require, "lazy")
    if not ok then
        return 0
    end
    return lazy.stats().count
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

----------------------------------------------------------------------------------------------------
--  FILETYPE HELPERS
----------------------------------------------------------------------------------------------------

---@class FiletypeSettings
---@field g table<string, any>
---@field bo vim.bo
---@field wo vim.wo
---@field opt vim.opt
---@field plugins {[string]: fun(module: table)}

---@param args {[1]: string, [2]: string, [3]: string, [string]: boolean | integer}[]
---@param buf integer
local function apply_ft_mappings(args, buf)
    vim.iter(args):each(function(m)
        assert(#m == 3, "map args must be a table with at least 3 items")
        local opts = vim.iter(m):fold({ buffer = buf }, function(acc, key, item)
            if type(key) == "string" then
                acc[key] = item
            end
            return acc
        end)
        map(m[1], m[2], m[3], opts)
    end)
end

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
---@param configs table<string, fun(module: table)>
function lambda.ftplugin_conf(configs)
    if type(configs) ~= "table" then
        return
    end
    for name, callback in pairs(configs) do
        local ok, plugin = lambda.pcall(require, name)
        if ok then
            callback(plugin)
        end
    end
end
--- This function is an alternative API to using ftplugin files. It allows defining
--- filetype settings in a single place, then creating FileType autocommands from this definition
---
--- e.g.
--- ```lua
---   lambda.filetype_settings({
---     lua = {
---      opt = {foldmethod = 'expr' },
---      bo = { shiftwidth = 2 }
---     },
---    [{'c', 'cpp'}] = {
---      bo = { shiftwidth = 2 }
---    }
---   })
--- ```
---
---@param map {[string|string[]]: FiletypeSettings | {[integer]: fun(args: AutocmdArgs)}}
function lambda.filetype_settings(map)
    local commands = vim.iter(map):map(function(ft, settings)
        local name = type(ft) == "table" and table.concat(ft, ",") or ft
        return {
            pattern = ft,
            event = "FileType",
            desc = ("ft settings for %s"):format(name),
            command = function(args)
                vim.iter(settings):each(function(key, value)
                    if key == "opt" then
                        key = "opt_local"
                    end
                    if key == "mappings" then
                        return apply_ft_mappings(value, args.buf)
                    end
                    if key == "plugins" then
                        return lambda.ftplugin_conf(value)
                    end
                    if type(key) == "function" then
                        return lambda.pcall(key, args)
                    end
                    vim.iter(value):each(function(option, setting)
                        vim[key][option] = setting
                    end)
                end)
            end,
        }
    end)
    lambda.augroup("filetype-settings", { unpack(commands:totable()) })
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

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

local autocmd_keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }

--- Validate the keys passed to lambda.augroup are valid
---@param name string
---@param command Autocommand

local function validate_autocmd(name, command)
    local incorrect = vim.iter(command):map(function(key, _)
        if not vim.tbl_contains(autocmd_keys, key) then
            return key
        end
    end)
    if #incorrect > 0 then
        vim.schedule(function()
            local msg = ("Incorrect keys: %s"):format(table.concat(incorrect, ", "))
            vim.notify(msg, "error", { title = ("Autocmd: %s"):format(name) })
        end)
    end
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

------------------------------------------------------------------------------------------------------------------------
--  Lazy Requires
------------------------------------------------------------------------------------------------------------------------
--- source: https://github.com/tjdevries/lazy-require.nvim

--- Require on index.
---
--- Will only require the module after the first index of a module.
--- Only works for modules that export a table.
function lambda.reqidx(require_path)
    return setmetatable({}, {
        __index = function(_, key)
            return require(require_path)[key]
        end,
        __newindex = function(_, key, value)
            require(require_path)[key] = value
        end,
    })
end

--- Require when an exported method is called.
---
--- Creates a new function. Cannot be used to compare functions,
--- set new values, etc. Only useful for waiting to do the require until you actually
--- call the code.
---
--- ```lua
--- -- This is not loaded yet
--- local lazy_mod = lazy.require_on_exported_call('my_module')
--- local lazy_func = lazy_mod.exported_func
---
--- -- ... some time later
--- lazy_func(42)  -- <- Only loads the module now
---
--- ```
---@param require_path string
---@return table<string, fun(...): any>
function lambda.reqcall(require_path)
    return setmetatable({}, {
        __index = function(_, k)
            return function(...)
                return require(require_path)[k](...)
            end
        end,
    })
end

---@generic T
---Given a table return a new table which if the key is not found will search
---all the table's keys for a match using `string.match`
---@param map T
---@return T
function lambda.p_table(map)
    return setmetatable(map, {
        __index = function(tbl, key)
            if not key then
                return
            end
            for k, v in pairs(tbl) do
                if key:match(k) then
                    return v
                end
            end
        end,
    })
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
---Determine if a value of any type is empty
---@param item any
---@return boolean?
function lambda.falsy(item)
    if not item then
        return true
    end
    local item_type = type(item)
    if item_type == "boolean" then
        return not item
    end
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

function lambda.clever_tcd()
    local root = require("lspconfig").util.root_pattern("Project.toml", ".git")(vim.api.nvim_buf_get_name(0))
    if root == nil then
        root = " %:p:h"
    end

    vim.schedule_wrap(function()
        vim.cmd.tcd(root)
    end)()
end

function lambda.better_cd_tcd_lcd(option, root_or_current)
    local option = option or "tcd"
    local root_or_current = root_or_current or "root"
    local option_list = {
        ["tcd"] = "tcd",
        ["lcd"] = "lcd",
        ["cd"] = "cd",
    }

    local option = option_list[option]

    local function get_root_dir()
        local root_dir = require("lspconfig").util.root_pattern("Project.toml", ".git")(vim.api.nvim_buf_get_name(0))
        if root_dir == nil then
            root_dir = " %:p:h"
        end
        return root_dir
    end

    local function get_current_dir()
        return " %:p:h"
    end

    local function get_dir()
        local dir = {
            ["root"] = get_root_dir,
            ["current"] = get_current_dir,
        }
        return dir[root_or_current]()
    end

    vim.cmd(option .. " " .. get_dir())
    vim.cmd("pwd")
end
