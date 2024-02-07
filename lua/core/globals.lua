_G = _G or {}
_G.lambda = {}
require("core.lambda")

_G.map = vim.keymap.set
_G.P = vim.print
_G.__remote_op_opfunc = function(motion)
    vim.notify("hi " .. motion)
end

P = vim.pretty_print

_G.dump = function(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    if #objects == 0 then
        -- print("nil")
    end
    print(unpack(objects))
    return ...
end

---Reloads a module
---@param module string Name of the module
_G.RELOAD = function(module)
    return require("plenary.reload").reload_module(module)
end

_G.lprint = require("utils.logs.log").lprint

local function merge_table(a)
    return function(t)
        return vim.g.personal_module.add_table_string(t, a)
    end
end

local buf_lookup = {}
local function check_buf(bufid, f)
    return vim.api.nvim_buf_is_loaded(bufid) and vim.api.nvim_buf_get_name(bufid) == f
end

local function go_to_buf(filepath, new_tab)
    if new_tab then
        vim.cmd.tabedit(filepath)
        return
    end
    if vim.api.nvim_buf_get_name(0) == filepath then
        buf_lookup[filepath] = vim.api.nvim_get_current_buf()
        return
    end
    if buf_lookup[filepath] and check_buf(buf_lookup[filepath], filepath) then
        vim.api.nvim_set_current_buf(buf_lookup[filepath])
        return
    end
    for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
        if check_buf(bufid, filepath) then
            vim.api.nvim_set_current_buf(bufid)
            buf_lookup[filepath] = bufid
            return
        end
    end
    vim.cmd.edit(filepath)
end

vim.g.personal_module = {
    ---Check if path exists in filesystem
    ---@param path string: path to check
    ---@param is_config boolean?: if true, path is treated in a lua require format
    ---@return boolean
    exists = function(path, is_config)
        if is_config then
            path = vim.fn.stdpath("config") .. "/lua/" .. path:gsub("%.", "/") .. ".lua"
        end
        local st = vim.loop.fs_stat(path)
        return st and true or false
    end,
    ---Add multiple lists without overwriting any table
    ---@vararg string[] | nil: tables to merge together
    ---@return string[]: single table merged together
    add_table_string = function(...)
        local res = {} ---@type string[]
        for _, t in pairs({ ... }) do
            for _, v in ipairs(t) do
                res[#res + 1] = v
            end
        end
        return res
    end,
    md = merge_table({ "markdown", "html", "NeogitCommitMessage", "gitcommit", "octo" }),
    ---Open buf of filepath if exists, and new if not
    ---@param filepath string? absolute path to filename
    ---@param check_exists boolean? check if filename exists beforehand
    ---@param cursor_pos { line: integer?, col: integer? }? set cursor position if not nil, values default to 0
    ---@param new_tab boolean? open file in new tab
    move_to_buf_pos = function(filepath, check_exists, cursor_pos, new_tab)
        if check_exists and filepath and not vim.g.personal_module.exists(filepath, false) then
            return
        end
        if filepath then
            go_to_buf(filepath, new_tab)
        end
        if cursor_pos then
            vim.api.nvim_win_set_cursor(0, { cursor_pos.line or 0, cursor_pos.col or 0 })
        end
    end,
    ---Register new null-ls source
    ---@param names table<string | integer, table | string> # name like `fmt.prettier` that points to sources
    ---@param disable_others boolean? # whether to disable other sources with same filetype
    null_register = function(names, disable_others)
        if vim.g.did_very_lazy then
            require("lsp-config.null-helper").null_register(names, disable_others)
        else
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                once = true,
                callback = function()
                    require("lsp-config.null-helper").null_register(names, disable_others)
                end,
            })
        end
    end,
}

-- -- neovim specific options
-- vim.opt.completeopt = "menuone,noselect"
-- vim.opt.cmdheight = 0
vim.opt.exrc = true
-- vim.opt.signcolumn = "yes:1"
-- vim.opt.spelloptions = "camel,noplainbuffer"
--
-- -- global status line
-- vim.opt.laststatus = 3
-- vim.opt.fillchars = "vert:┃,horiz:━,verthoriz:╋,horizup:┻,horizdown:┳,vertleft:┫,vertright:┣,eob: " -- more obvious separator
