-- local fn = vim.fn
local api = vim.api
local fmt = string.format
_G = _G or {}
_G.lambda = {}

--
lambda.config = {
    border = {
        type_0 = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
        type_1 = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        type_2 = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        type_3 = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        type_4 = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" },
    },
    colourscheme = {
        change_kitty_bg = false,
        --- @usage "main"' | '"moon"
        rose = "main",
        --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
        catppuccin_flavour = "mocha",
        -- @usage theme_name : percentage chance
        themes = {
            dark = {
                { "kanagawa.nvim", 0.2 },
                { "rose", 0.5 },
                { "catppuccin", 0.2 },
                { "doom-one.nvim", 0.1 },
            },
            light = {},
        },
    },
    loaded_confirm_quit = true,
    save_clipboard_on_exit = true,
    cmp_theme = "border", -- no-border , border
    abbrev = {
        enable = true,
        coding_support = true, -- system wide
        globals = { -- dictionaries that ive defined to be global, you may not want this idk .
            ["spelling_support"] = true,
            ["month_date"] = true,
        },
        languages = {
            "python", -- current support is python.
        },
    },
    tabby_or_bufferline = true, -- false: Bufferline , true for tabby
    sell_your_soul = false, -- set to true to sell your soul to microsoft
    use_tabnine = true, -- load tabnine
    use_dashboard = false, -- set to false to not see this
    use_session = true, -- set to false to disable session
    use_clock = false, -- set to true to  see timer for config
    use_saga_diagnostic_jump = false, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_guess_indent = true,
    use_gitsigns = true,
    lsp = {
        -- this seems to cause lag, though im not sure about that. Will have to see if that is the
        -- case or not
        use_semantic_token = false,
        latex = "texlab", -- texlab | ltex
        python = {
            lint = "flake8", -- pylint, pyflake, and other linters
            -- lsp = "jedi", -- jedi pylsp and pyright pylance
            lsp = "pylance",
            pylance = {
                -- i really cannot tell which one is faster atm
                use_inlay_hints = true,
            },
            format = "yapf", -- black
        },
    },
    neorg_auto_commit = true,
}

----------------------------------------------------------------------------------------------------
-- Global namespace
----------------------------------------------------------------------------------------------------
P = vim.pretty_print

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

-- plugin_folder()
return {
    init = function()
        _G.plugin_folder = function()
            if Plugin_folder then
                return Plugin_folder
            end
            local host = os.getenv("HOST_NAME")
            if host and host:find("vsedov") then
                Plugin_folder = [[~/GitHub/neovim]] -- vim.fn.expand("$HOME") .. '/github/'
            else
                Plugin_folder = [[vsedov/]]
            end
            return Plugin_folder
        end

        _G.plugin_debug = function()
            if Plugin_debug ~= nil then
                return Plugin_debug
            end
            local host = os.getenv("HOST_NAME")
            if host and host:find("vsedov") then
                Plugin_debug = true -- enable debug here, will be slow
            else
                Plugin_debug = false
            end
            return Plugin_debug
        end

        _G.dump = function(...)
            local objects = vim.tbl_map(vim.inspect, { ... })
            if #objects == 0 then
                print("nil")
            end
            print(unpack(objects))
            return ...
        end
    end,
}
