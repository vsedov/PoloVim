-- https://github.com/IndianBoy42/dot.nvim/blob/89d6d6e70fd9869c36fe4633f69345bd9dbcbe94/lua/editor/nav/lib.lua#L11
local do_op = function(state, win, pos, end_pos, using_visual_mode)
    local function restore()
        vim.schedule(function()
            if vim.api.nvim_get_mode().mode == "i" then
                vim.api.nvim_create_autocmd("InsertLeave", {
                    once = true,
                    callback = restore,
                })
            else
                vim.api.nvim_set_current_win(state.win)
                vim.fn.winrestview(state.view)
                if state.on_return then
                    state:on_return(win, pos, end_pos)
                end
            end
        end)
    end
    local function __do_op(start, finish)
        vim.go.operatorfunc = state.op_func
        if using_visual_mode then
            vim.api.nvim_win_set_cursor(0, start)
            vim.cmd("normal! v")
            vim.api.nvim_win_set_cursor(0, finish)
            vim.api.nvim_input('"' .. state.register .. state.operator)
        else
            vim.api.nvim_win_set_cursor(0, start)
            local k = '"' .. state.register .. state.operator
            k = k .. "v`]"
            vim.api.nvim_feedkeys(k, "ni", true)
            -- vim.api.nvim_win_set_cursor(0, { finish[1], finish[2] })
        end

        restore()
    end

    state.view = vim.fn.winsaveview()
    vim.api.nvim_set_current_win(win)

    if not end_pos or type(end_pos) ~= "table" then -- Use a op-pending to get a selction
        vim.api.nvim_win_set_cursor(win, pos)

        if type(end_pos) == "function" then
            end_pos() -- FIXME: doesn't work at all
            restore()
        else
            _G.__remote_op_opfunc = function()
                __do_op(vim.api.nvim_buf_get_mark(0, "["), vim.api.nvim_buf_get_mark(0, "]"))
            end
            vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
            vim.api.nvim_feedkeys("g@" .. (end_pos and end_pos or ""), "mi", true)
        end
    else
        __do_op(pos, end_pos)
    end
end
local swap_with = function(opts, ma, mb)
    local function helper(start, finish, op)
        vim.api.nvim_win_set_cursor(0, start)
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, finish)
        vim.api.nvim_feedkeys(op or "p", "ni", false)
    end

    local reg = vim.fn.getreg('"')
    vim.api.nvim_feedkeys("`" .. ma .. "v`" .. mb .. "y", "n", false)
    local start, finish = vim.api.nvim_buf_get_mark(0, ma), vim.api.nvim_buf_get_mark(0, mb)

    _G.__remote_op_opfunc = function()
        helper(vim.api.nvim_buf_get_mark(0, "["), vim.api.nvim_buf_get_mark(0, "]"))
    end
    vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
    vim.api.nvim_feedkeys("g@", "n", false)
    require("flash").remote(vim.tbl_deep_extend("force", {
        remote = {
            on_restore = vim.schedule_wrap(function()
                helper(start, finish)
                vim.fn.setreg('"', reg)
            end),
        },
    }, opts))
end
local function get_windows()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local curr_win = vim.api.nvim_get_current_win()
    local function check(win)
        local config = vim.api.nvim_win_get_config(win)
        return (config.focusable and (config.relative == "") and (win ~= curr_win))
    end
    return vim.tbl_filter(check, wins)
end

local M = {}
M.there_and_back = function(action, jump_back)
    return function(match, state)
        vim.api.nvim_win_call(match.win, function()
            vim.api.nvim_win_set_cursor(match.win, match.pos)
            action()
            if jump_back or jump_back == nil then
                vim.api.nvim_win_set_cursor(state.win, state.pos)
            end
        end)
    end
end
M.flash_diagnostics = function(opts)
    local action = opts and opts.action or vim.diagnostic.open_float
    if opts and opts.action then
        opts.action = nil
    end

    require("flash").jump(vim.tbl_deep_extend("force", {
        pattern = ".",
        matcher = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            ---@param diag Diagnostic
            return vim.tbl_map(function(diag)
                return {
                    pos = { diag.lnum + 1, diag.col },
                    end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                }
            end, vim.diagnostic.get(buf))
        end,
        action = M.there_and_back(action),
    }, opts or {}))
end

M.flash_references = function(opts)
    local params = vim.lsp.util.make_position_params()
    params.context = {
        includeDeclaration = true,
    }
    local first = true
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf_request(bufnr, "textDocument/references", params, function(_, result, ctx)
        if not vim.tbl_islist(result) then
            result = { result }
        end
        if first and result ~= nil and not vim.tbl_isempty(result) then
            first = false
        else
            return
        end
        require("flash").jump(vim.tbl_deep_extend("force", {
            pattern = ".", -- initialize pattern with any char
            mode = "references",
            matcher = function(win)
                local oe = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
                return vim.tbl_map(function(loc)
                    return {
                        pos = { loc.lnum, loc.col - 1 },
                        end_pos = { loc.end_lnum or loc.lnum, (loc.end_col or loc.col) - 1 },
                    }
                end, vim.lsp.util.locations_to_items(result, oe))
            end,
        }, opts or {}))
    end)
end

M.flash_lines = function(opts)
    -- require("flash").jump({ search = { mode = "search" }, highlight = { label = { after = { 0, 0 } } }, pattern = "^" })

    require("flash").jump(vim.tbl_deep_extend("force", {
        pattern = ".", -- initialize pattern with any char
        mode = "lines",
        matcher = function(win)
            local cur = vim.api.nvim_win_get_cursor(win)
            local wininfo = vim.api.nvim_win_call(win, function()
                return vim.fn.winsaveview()
            end)
            local top = wininfo.topline
            local h = vim.api.nvim_win_get_height(win)

            local res = {}
            for i = 1, h do
                local pos = { top + i, cur[2] }
                res[#res + 1] = {
                    pos = pos,
                    end_pos = pos,
                }
            end
            return res
        end,
    }, opts or {}))
end

M.mode_textcase = function(pat, modes)
    modes = modes
        or {
            "to_constant_case",
            "to_lower_case",
            "to_snake_case",
            "to_dash_case",
            "to_camel_case",
            "to_pascal_case",
            "to_path_case",
            "to_title_case",
            "to_phrase_case",
            "to_dot_case",
        }
    local pats = { pat }
    local tc = require("textcase").api
    for _, mode in ipairs(modes) do
        local pat2 = tc[mode](pat)
        if pat2 ~= pat then
            pats[#pats + 1] = pat2
        end
    end
    return "\\V\\(" .. table.concat(pats, "\\|") .. "\\)"
end
M.remote_op = function(callback, operator, register, opfunc)
    if operator then
        if type(operator) == "function" then
            _G.__remote_op_opfunc = operator
            operator = "g@"
            opfunc = "v:lua.__remote_op_opfunc"
        end
    end
    local opstate = {
        operator = operator or vim.v.operator,
        register = register or vim.v.register,
        op_func = opfunc or vim.go.operatorfunc,
        pos = vim.api.nvim_win_get_cursor(0),
        win = vim.api.nvim_get_current_win(),
    }
    vim.api.nvim_input("<esc>")
    if callback then
        vim.schedule(function()
            callback(function(...)
                do_op(opstate, ...)
            end)
        end)
    end
    return opstate
end

M.do_op = do_op
M.swap_with = function(opts)
    local v = vim.api.nvim_get_mode().mode:lower() == "v"
    if v then
        swap_with(opts, "<", ">")
    else
        _G.__remote_op_opfunc = function()
            swap_with(opts, v and "<" or "[", v and ">" or "]")
        end
        vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
        vim.api.nvim_feedkeys("g@", "n", false)
    end
end
M.jump_windows = function()
    require("flash").jump({
        pattern = ".",
        search = { multi_window = true, wrap = true },
        highlight = { backdrop = true },
        matcher = function()
            return vim.tbl_map(function(window)
                local wininfo = vim.fn.getwininfo(window)[1]
                return { pos = { wininfo.topline, 1 }, end_pos = { wininfo.topline, 0 } }
            end, get_windows())
        end,
        action = function(match, _)
            vim.api.nvim_set_current_win(match.win)
            vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, { match.pos[1], 0 })
            end)
        end,
    })
end
M.search_win = function()
    if lambda.config.ui.use_hlslens then
        require("hlslens").start()
    end
    local pat = vim.fn.getreg("/")
    require("flash").jump({
        pattern = pat,
        search = { multi_window = false, wrap = true },
    })
end
M.search_ref = function()
    local ref = require("illuminate.reference").buf_get_references(vim.api.nvim_get_current_buf())

    require("flash").jump({
        pattern = ".", -- initialize pattern with any char
        matcher = function()
            local results = {}
            for _, v in pairs(ref) do
                table.insert(results, {
                    pos = { v[1][1] + 1, v[1][2] + 1 },
                    end_pos = { v[2][1] + 1, v[2][2] + 1 },
                })
            end
            return results
        end,

        search = { multi_window = true, wrap = true },
    })
    return true
end

return M
