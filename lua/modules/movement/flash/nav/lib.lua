-- https://github.com/IndianBoy42/dot.nvim/blob/89d6d6e70fd9869c36fe4633f69345bd9dbcbe94/lua/editor/nav/lib.lua#L11
local ai_objs = {
    "a(",
    "i(",
    "a'",
    "i'",
    'a"',
    'i"',
    "a[",
    "i[",
    "a{",
    "i{",
    "a<",
    "i<",
    "a`",
    "i`",
}

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
            vim.schedule(function()
                state:restore()
            end)
        end)
    end
end

M.flash_diagnostics = function(opts)
    local action = opts and opts.action or vim.diagnostic.open_float
    if opts and opts.action then
        opts.action = nil
    end

    require("flash").jump(vim.tbl_deep_extend("force", {
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
        action = function(match, state)
            vim.api.nvim_set_current_win(match.win)
            vim.api.nvim_win_set_cursor(match.win, match.pos)
            action()
        end,
        search = { max_length = 0 },
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
            mode = "references",
            search = { max_length = 0 },
            matcher = function(win)
                local cword = #vim.fn.expand("<cword>")
                local oe = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
                return vim.tbl_map(function(loc)
                    local end_pos
                    if not loc.end_col then
                        end_pos = { loc.lnum, loc.col + cword - 2 }
                    else
                        end_pos = { loc.end_lnum or loc.lnum, loc.end_col - 1 }
                    end
                    return {
                        pos = { loc.lnum, loc.col - 1 },
                        end_pos = end_pos,
                    }
                end, vim.lsp.util.locations_to_items(result, oe))
            end,
        }, opts or {}))
    end)
end

M.flash_lines = function(opts)
    require("flash").jump(vim.tbl_deep_extend("force", {
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

local do_op = function(state, win, pos, end_pos)
    local _restore = function()
        vim.api.nvim_set_current_win(state.win)
        vim.fn.winrestview(state.view)
    end
    local function restore()
        vim.schedule(function()
            require("flash.jump").restore_remote({
                restore = _restore,
            })
        end)
    end
    local function __do_op(start, finish)
        vim.api.nvim_win_set_cursor(0, start)
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, finish)
        vim.api.nvim_input('"' .. state.register .. state.operator)

        restore()
    end

    vim.api.nvim_feedkeys(vim.keycode("<C-\\><C-n>"), "nx", false)
    vim.api.nvim_feedkeys(vim.keycode("<esc>"), "n", false)

    vim.schedule(function()
        vim.api.nvim_set_current_win(win)

        if not end_pos or type(end_pos) ~= "table" then -- Use a op-pending to get a selction
            vim.api.nvim_win_set_cursor(win, pos)

            if type(end_pos) == "function" then
                end_pos() -- FIXME: doesn't work at all
                restore()
            else
                -- _G.__remote_op_opfunc = function() __do_op(vim.api.nvim_buf_get_mark(0, "["), vim.api.nvim_buf_get_mark(0, "]")) end
                -- vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
                vim.go.operatorfunc = state.op_func
                vim.api.nvim_input('"' .. state.register .. state.operator .. (end_pos and end_pos or ""))
                restore()
            end
        else
            __do_op(pos, end_pos)
        end
    end)
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
        view = vim.fn.winsaveview(),
    }

    -- vim.api.nvim_feedkeys(vim.keycode "<C-\\><C-n>", "nx", false)
    -- vim.api.nvim_feedkeys(vim.keycode "<esc>", "n", false)
    if callback then
        callback(function(...)
            do_op(opstate, ...)
        end)
    end
    return opstate
end
M.do_op = do_op

local swap_text = function(opts, ma, mb)
    local start, finish = vim.api.nvim_buf_get_mark(0, ma), vim.api.nvim_buf_get_mark(0, mb)
    local this_text = vim.api.nvim_buf_get_text(0, start[1] - 1, start[2], finish[1] - 1, finish[2], {})
    vim.schedule(function()
        require("flash").jump(vim.tbl_deep_extend("force", {
            action = function(match, state)
                local other_buf = vim.api.nvim_win_get_buf(match.win)
                local other_start, other_finish = match.pos, match.end_pos
                local other_text = vim.api.nvim_buf_get_text(
                    0,
                    other_start[1] - 1,
                    other_start[2],
                    other_finish[1] - 1,
                    other_finish[2],
                    {}
                )
                vim.api.nvim_buf_set_text(
                    other_buf,
                    other_start[1] - 1,
                    other_start[2],
                    other_finish[1] - 1,
                    other_finish[2],
                    this_text
                )
                vim.api.nvim_buf_set_text(0, start[1] - 1, start[2], finish[1] - 1, finish[2], other_text)
            end,
            remote_op = {
                restore = true,
                motion = true,
            },
        }, opts))
    end)
end

local swap_with = function(opts, ma, mb, jumper)
    local reg = vim.fn.getreg('"')
    local start, finish = vim.api.nvim_buf_get_mark(0, ma), vim.api.nvim_buf_get_mark(0, mb)
    local a, b = vim.api.nvim_buf_get_mark(0, "a"), vim.api.nvim_buf_get_mark(0, "b")
    vim.api.nvim_buf_set_mark(0, "a", start[1], start[2], {})
    vim.api.nvim_buf_set_mark(0, "b", finish[1], finish[2], {})
    local vis_mode = opts and opts.exchange and opts.exchange.visual_mode or "v"
    vim.api.nvim_feedkeys("`a" .. vis_mode .. "`by", "nx", false)

    -- vim.schedule(function()
    _G.__remote_op_opfunc = function()
        local action = "`[" .. vis_mode .. "`]"
        if opts and opts.exchange and opts.exchange.not_there then
            action = action .. "y"
        else
            action = action .. "p"
        end
        if not (opts and opts.exchange and opts.exchange.not_here) then
            action = action .. "`a" .. vis_mode .. "`bp"
        end
        vim.cmd("normal! " .. action)

        vim.fn.setreg('"', reg)
        vim.api.nvim_buf_set_mark(0, "a", a[1], a[2], {})
        vim.api.nvim_buf_set_mark(0, "b", b[1], b[2], {})
    end
    vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
    vim.api.nvim_feedkeys("g@" .. (type(jumper) == "string" and jumper or ""), "m", false)
    -- end)
    if jumper and type(jumper) == "function" then
        jumper(opts)
    elseif jumper == nil then
        vim.schedule(function()
            require("flash").jump(vim.tbl_deep_extend("force", {
                remote = {
                    restore = true,
                    motion = true,
                },
            }, opts or {}))
        end)
    end
end

M.swap_with = function(opts, textobj, textobj2)
    _G.__remote_op_opfunc = function()
        swap_with(opts, "[", "]", textobj2)
    end
    vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
    vim.api.nvim_feedkeys("g@" .. (type(textobj) == "string" and textobj or ""), "m", false)
    if type(textobj) == "function" then
        textobj()
    end
end
function M.leap_anywhere(action)
    local focusable_windows_on_tabpage = vim.tbl_filter(function(win)
        return vim.api.nvim_win_get_config(win).focusable
    end, vim.api.nvim_tabpage_list_wins(0))
    require("leap").leap({
        case_sensitive = false,
        target_windows = focusable_windows_on_tabpage,
        action = action,
    })
end
M.leap_remote = function()
    M.remote_op(function(do_op)
        M.leap_anywhere(function(jt)
            do_op(jt.wininfo.winid, jt.pos)
        end)
    end)
end

M.remote_paste = function(key, paste_key)
    local view = vim.fn.winsaveview()
    local pos = vim.api.nvim_win_get_cursor(0)
    paste_key = paste_key or "P"
    return function()
        local cur = vim.api.nvim_win_get_cursor(0)
        _G.__remote_op_opfunc = function()
            -- Get the other side of the selection
            local a, b = vim.api.nvim_buf_get_mark(0, "["), vim.api.nvim_buf_get_mark(0, "]")
            if cur[1] == a[1] and cur[2] == a[2] then
                vim.api.nvim_win_set_cursor(0, b)
            elseif cur[1] == b[1] and cur[2] == b[2] then
                a[2] = a[2] - 1
                vim.api.nvim_win_set_cursor(0, a)
            end
            -- vim.api.nvim_input(vim.keycode "<esc>" .. paste_key)
            vim.api.nvim_feedkeys(vim.keycode(paste_key), "m", false)
            vim.schedule(function()
                vim.fn.winrestview(view)
                vim.api.nvim_win_set_cursor(0, pos)
            end)
        end
        vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
        vim.api.nvim_feedkeys("g@" .. key, "m", false)
    end
end

local ai_objs = {
    "a(",
    "i(",
    "a'",
    "i'",
    'a"',
    'i"',
    "a[",
    "i[",
    "a{",
    "i{",
    "a<",
    "i<",
    "a`",
    "i`",
}
M.filter_nodes = function(nodes, win, pos, end_pos)
    local Pos = require("flash.search.pos")
    local function fto(obj, count)
        return MiniAi.find_textobject(obj:sub(1, 1), obj:sub(2, 2), {
            search_method = "cover",
            reference_region = {
                from = { line = pos[1], col = pos[2] + 1 },
                -- to = { line = end_pos[1], col = end_pos[2] },
            },
            n_times = count,
        })
    end
    for _, obj in ipairs(ai_objs) do
        if type(obj) == "string" then
            local count = 1
            local tobj = fto(obj, count)
            while tobj ~= nil do
                nodes[#nodes + 1] = {
                    pos = Pos({ tobj.from.line, tobj.from.col - 1 }),
                    end_pos = Pos({ tobj.to.line, tobj.to.col - 1 }),
                    win = win,
                }
                count = count + 1
                tobj = fto(obj, count)
            end
        elseif type(obj) == "function" then
            obj(win, pos, end_pos)
        end
    end
    return nodes
end
M.get_nodes = function(win, pos, end_pos)
    local nodes = require("flash.plugins.treesitter").get_nodes(win, pos)
    local matches = {}
    -- nodes = M.filter_nodes(nodes, win, pos, end_pos)
    return nodes
end

local function sib(dir, n)
    if dir < 0 then
        return n:prev_named_sibling()
    else
        return n:next_named_sibling()
    end
end

local function node_proc(bwd, fwd, m, matches, n, opts, state)
    local ok = true
    local tsopts = state.opts.treesitter or {}
    if tsopts.starting_from_pos then
        ok = ok and (m.pos == n.pos)
    end
    if tsopts.ending_at_pos then
        ok = ok and (m.end_pos == n.end_pos)
    end
    if tsopts.containing_end_pos then
        ok = ok and (m.end_pos <= n.end_pos)
    end
    if fwd ~= 0 or bwd ~= 0 then
        local node = n.node
        local parent = n.node:parent()
        while parent ~= nil do
            local a, b, c, d = parent:range()
            local na, nb, nc, nd = node:range()
            if a ~= na or b ~= nb or c ~= nc or d ~= nd then
                break
            end
            node = parent
            parent = parent:parent()
        end

        local sn, en = node, node
        if fwd ~= 0 then
            for _ = 1, math.abs(fwd) do
                en = sib(fwd, en)
                if en == nil then
                    ok = false
                    break
                end
            end
            if en ~= nil then
                local r, c = en:end_()
                n.end_pos = { row = r + 1, col = c - 1 }
                -- TODO: needs some correction
            end
        end
        if bwd ~= 0 then
            for _ = 1, math.abs(bwd) do
                sn = sib(-bwd, sn)
                if sn == nil then
                    ok = false
                    break
                end
            end
            if sn ~= nil then
                local r, c = sn:start()
                n.pos = { row = r + 1, col = c }
            end
        end
    end

    if ok then
        -- don't highlight treesitter nodes. Use labels only
        n.highlight = false
        if tsopts.end_of_node then
            n.pos = n.end_pos
            n.end_pos = n.pos
        end
        if tsopts.start_of_node then
            if tsopts.end_of_node then
                local n2 = vim.deepcopy(n)
                n2.end_pos = nil
                table.insert(matches, n2)
            else
                n.end_pos = nil
            end
        end
        table.insert(matches, n)
    end
    return ok
end

-- TODO: Full on almost arbitrary node selection (iswap.nvim style)
M.custom_ts = function(win, state, opts)
    local fwd = state.remote_ts_fwd or 0
    local bwd = state.remote_ts_bwd or 0
    local matches = {}
    local m = {
        pos = state.pos,
        end_pos = state.pos,
    }
    for _, n in ipairs(M.get_nodes(win, m.pos, m.end_pos)) do
        node_proc(bwd, fwd, m, matches, n, opts, state)
    end
    return matches
end
M.remote_ts = function(win, state, opts)
    if state.pattern.pattern == " " then
        -- TODO: completely switch to `custom_ts`
        -- state.pattern.pattern = (" "):rep(state.opts.search.max_length)
        state.opts.search.max_length = 1
        local matches = require("flash.plugins.treesitter").matcher(win, state)
        for _, m in ipairs(matches) do
            m.highlight = false
        end
        return matches
    end

    local Search = require("flash.search")
    local matches = {} ---@type Flash.Match[]
    local search = Search.new(win, state)
    local smatches = search:get(opts)
    local find_nodes = #state.pattern.pattern >= 2
    local fwd = state.remote_ts_fwd or 0
    local bwd = state.remote_ts_bwd or 0
    for _, m in ipairs(smatches) do
        local ok = false
        if find_nodes then
            for _, n in ipairs(M.get_nodes(win, m.pos, m.end_pos)) do
                ok = node_proc(bwd, fwd, m, matches, n, opts, state)
            end
        end
        if not find_nodes or ok then
            -- don't add labels to the search results
            m.label = false
            table.insert(matches, m)
        end
    end
    return matches
end
local function ts_shift(state, fwdincr, bwdincr)
    state.remote_ts_fwd = (state.remote_ts_fwd or 0) + fwdincr
    state.remote_ts_bwd = (state.remote_ts_bwd or 0) + bwdincr

    -- Force update
    -- state.pattern:set(state.remote_ts_fwd .. state.remote_ts_bwd)
    state:update({ dirty_cache = true })
end
M.ts_actions = {
    -- Extend right
    ["}"] = function(state)
        ts_shift(state, 1, 0)
    end,
    ["{"] = function(state)
        ts_shift(state, 0, 1)
    end,
    -- Extend left
    ["["] = function(state)
        ts_shift(state, -1, 0)
    end,
    ["]"] = function(state)
        ts_shift(state, 0, -1)
    end,
    -- Move
    [")"] = function(state)
        ts_shift(state, 1, -1)
    end,
    ["("] = function(state)
        ts_shift(state, -1, 1)
    end,
}
M.remote_sel = function(win, state, opts)
    local pat = state.pattern
    state.pattern = pat:sub(1, 1)
    local search = require("flash.search").new(win, state)
    local matches = {}
    for _, m in ipairs(search:get(opts)) do
        state.pattern = pat:sub(2)
        for _, n in ipairs(search:get({ from = m.pos, to = m.end_pos })) do
        end
    end
    return matches
end

-- TODO: iswap
M.iswap = function(opts) end

M.move_by_ts = function()
    local iter = {
        next = function()
            return true
        end,
        prev = function()
            return true
        end,
        state = {},
    }
end

M.select_operatorfunc = function()
    local start, finish = vim.api.nvim_buf_get_mark(0, "["), vim.api.nvim_buf_get_mark(0, "]")
    vim.api.nvim_win_set_cursor(0, start)
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(0, finish)
end
M.select_mapping = function()
    vim.go.operatorfunc = "v:lua.require'editor.nav.lib'.select_operatorfunc"
    return "g@"
end

M.jump_windows = function()
    require("flash").jump({
        pattern = ".",
        search = { multi_window = true, wrap = true },
        highlight = { backdrop = true },
        label = { current = true },
        matcher = function()
            return vim.tbl_map(function(window)
                local wininfo = vim.fn.getwininfo(window)[1]
                return {
                    pos = { wininfo.topline, 1 },
                    end_pos = { wininfo.topline, 0 },
                }
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
