local function get_windows()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local curr_win = vim.api.nvim_get_current_win()
    local function check(win)
        local config = vim.api.nvim_win_get_config(win)
        return (config.focusable and (config.relative == "") and (win ~= curr_win))
    end
    return vim.tbl_filter(check, wins)
end

local function jump_windows()
    require("flash").jump({
        search = { multi_window = true, wrap = true },
        highlight = { backdrop = true, label = { current = true } },
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
-- TODO: jump to next one after first selection
local function lsp_references()
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
        require("flash").jump({
            mode = "references",
            matcher = function()
                local oe = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
                return vim.tbl_map(function(loc)
                    return {
                        pos = { loc.lnum, loc.col - 1 },
                        end_pos = { loc.end_lnum or loc.lnum, (loc.end_col or loc.col) - 1 },
                    }
                end, vim.lsp.util.locations_to_items(result, oe))
            end,
        })
    end)
end

local function jump_lines()
    require("flash").jump({ search = { mode = "search" }, highlight = { label = { after = { 0, 0 } } }, pattern = "^" })
end

local function search_win()
    require("hlslens").start()
    local pat = vim.fn.getreg("/")
    require("flash").jump({
        pattern = pat,
        search = { multi_window = false, wrap = true },
    })
end

local function search_ref()
    local ref = require("illuminate.reference").buf_get_references(vim.api.nvim_get_current_buf())
    if not ref or #ref == 0 then
        return false
    end

    local targets = {}
    for _, v in pairs(ref) do
        table.insert(targets, {})
    end

    require("flash").jump({
        matcher = function()
            local results = {}
            for _, v in pairs(ref) do
                table.insert(results, {
                    pos = { v[1][1] + 1, v[1][2] + 1 },
                    end_pos = { v[1][1] + 1, v[1][2] + 1 },
                })
            end
            return results
        end,

        search = { multi_window = true, wrap = true },
    })

    return true
end
return {
    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Word Jumpers                                               │
    --  ╰────────────────────────────────────────────────────────────────────╯
    "/",
    "?",
    {
        "x",
        mode = { "o", "x" },
        function()
            -- default options: exact mode, multi window, all directions, with a backdrop
            require("flash").jump({
                search = { forward = true, wrap = false, multi_window = false },
            })
        end,
        desc = "Operator Pending Flash Forward",
    },
    {
        "X",
        mode = { "o", "x" },
        function()
            require("flash").jump({
                search = { forward = false, wrap = false, multi_window = false },
            })
        end,
        desc = "Operator Pending Flash Backward",
    },

    {
        "s",
        mode = { "n" },
        function()
            -- default options: exact mode, multi window, all directions, with a backdrop
            require("flash").jump({
                search = { forward = true, wrap = false, multi_window = false },
            })
        end,
        desc = "Normal Mode Flash Forward",
    },
    {
        "S",
        mode = { "n" },
        function()
            require("flash").jump({
                search = { forward = false, wrap = false, multi_window = false },
            })
        end,
        desc = "Normal Mode Flash Backward",
    },
    {
        "S", -- trree hopper thing replacement in some sense
        mode = { "o", "x" },
        function()
            require("flash").treesitter()
        end,
        desc = "Operator Pending Flash Treesitter",
    },
    {
        "<S-cr>",
        mode = { "n", "o", "x" },
        function()
            require("flash").jump()
        end,

        desc = "Flash Current Screen",
    },
    {
        --  TODO: (vsedov) (21:59:14 - 24/06/23): Return this to normal if this is not viable
        "<c-s>",
        mode = { "n", "o", "x" },
        function()
            require("flash").jump({
                search = {
                    multi_window = false,
                    mode = function(pat, modes)
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
                    end,
                },
            })
        end,
        desc = "Flash Current buffer",
    },
    {
        "<leader>s",
        mode = { "n", "x", "o" },
        function()
            local win = vim.api.nvim_get_current_win()
            local view = vim.fn.winsaveview()
            require("flash").jump({
                pattern = ".", -- initialize pattern with any char
                search = {
                    mode = function(pattern)
                        -- remove leading dot
                        if pattern:sub(1, 1) == "." then
                            pattern = pattern:sub(2)
                        end
                        -- return word pattern and proper skip pattern
                        return ([[\v<%s\w*>]]):format(pattern), ([[\v<%s]]):format(pattern)
                    end,
                },
                -- select the range
                jump = { pos = "range" },
            })
        end,
        desc = "Select any word",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │ lsp                                                                │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<leader>S",
        mode = { "n" },
        function()
            require("flash").jump({
                matcher = function(win)
                    ---@param diag Diagnostic
                    return vim.tbl_map(function(diag)
                        return {
                            pos = { diag.lnum + 1, diag.col },
                            end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                        }
                    end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
                end,
                action = function(match, state)
                    vim.api.nvim_win_call(match.win, function()
                        vim.api.nvim_win_set_cursor(match.win, match.pos)
                        vim.diagnostic.open_float()
                        vim.api.nvim_win_set_cursor(match.win, state.pos)
                    end)
                end,
            })
        end,
        desc = "Show diagnostics at target, without changing cursor position",
    },
    {
        ";d",
        mode = { "n" },
        function()
            lsp_references()
        end,
        desc = "Flash Lsp References",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Window Jump and jump lines                                 │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<c-p>",
        mode = { "n" },
        function()
            jump_windows()
        end,
        desc = "Jump Windows",
    },
    {
        "<c-e>",
        mode = { "n" },
        function()
            jump_lines()
        end,
        desc = "Jump Lines",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Fold                                                       │
    --  ╰────────────────────────────────────────────────────────────────────╯
    {
        "z<cr>",
        function()
            require("flash").treesitter()
            vim.cmd("normal! Vzf")
        end,
        mode = { "n" },
        silent = true,
        desc = "God Fold",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Lasterisk and better search                                │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "*",
        function()
            require("lasterisk").search()
            vim.schedule(search_win)
        end,
        desc = "Search cword *",
    },
    {
        "*",
        function()
            require("lasterisk").search({ is_whole = false })
            vim.schedule(search_win)
            return "<C-\\><C-N>"
        end,
        mode = { "x" },
        expr = true,
        desc = "Search cword *",
    },
    {
        "g*",
        function()
            require("lasterisk").search({ is_whole = false })
            vim.schedule(search_win)
        end,
        desc = "Search cword g*",
    },
    {
        "#",
        function()
            if search_ref() then
                return
            end
            require("lasterisk").search()
            vim.schedule(search_win)
        end,
        desc = "Search cword (ref) # ",
    },
    {
        "#",
        function()
            require("lasterisk").search({ is_whole = false })

            vim.schedule(search_win)
            return "<C-\\><C-N>"
        end,
        mode = { "x" },
        expr = true,
        desc = "Search #",
    },
    {
        "g#",
        function()
            require("lasterisk").search({ is_whole = false })
            vim.schedule(search_win)
        end,
        desc = "Search g#",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Remote Jumps  and treesitter bindings                      │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<c-w>",
        mode = { "o", "x" },
        function()
            require("flash").remote()
        end,
        desc = "Remote Jump",
    },
    {
        "M", -- [M, r, <cr>]
        mode = { "n", "x", "o" },
        function()
            local win = vim.api.nvim_get_current_win()
            local view = vim.fn.winsaveview()
            require("flash").jump({
                action = function(match, state)
                    state:hide()
                    vim.api.nvim_set_current_win(match.win)
                    vim.api.nvim_win_set_cursor(match.win, match.pos)
                    require("flash").treesitter()
                    vim.schedule(function()
                        vim.api.nvim_set_current_win(win)
                        vim.fn.winrestview(view)
                    end)
                end,
            })
        end,
        desc = "Jump to a position, make a Treesitter selection and jump back This should be bound to a keymap like <leader>t. Then you could o yM to remotely yank a Treesitter selection.",
    },
    --    ╭────────────────────────────────────────────────────────────────────╮
    --    │                                                                    │
    --    │         F, f, T, t                                                 │
    --    │                                                                    │
    --    ╰────────────────────────────────────────────────────────────────────╯
    {
        "f",
        mode = { "n", "x", "o" },
        function()
            -- default options: exact mode, multi window, all directions, with a backdrop
            require("flash").jump({
                forward = true,
                multi_window = false,
                highlight = {
                    label = { after = { 0, 0 }, style = "overlay" },
                },
            })
        end,
    },
    {
        "t",
        mode = { "n", "x", "o" },
        function()
            require("flash").jump({
                forward = true,
                multi_window = false,
                highlight = {
                    label = { after = { 0, 0 }, style = "overlay" },
                },
            })
            vim.cmd([[normal! h]])
        end,
    },
    {
        "F",
        mode = { "n", "x", "o" },
        function()
            require("flash").jump({
                forward = false,
                multi_window = false,
                highlight = {
                    label = { after = { 0, 0 }, style = "overlay" },
                },
            })
        end,
    },
    {
        "T",
        mode = { "n", "x", "o" },
        function()
            require("flash").jump({
                forward = false,
                multi_window = false,
                highlight = {
                    label = { after = { 0, 0 }, style = "overlay" },
                },
            })
            vim.cmd([[normal! l]])
        end,
    },
}
