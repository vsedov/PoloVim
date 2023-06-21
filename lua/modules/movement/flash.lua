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

local function jump_lines()
    require("flash").jump({
        search = { multi_window = true, wrap = true },
        highlight = { backdrop = true, label = { current = true } },
        matcher = function()
            local results = {}
            for i = vim.fn.line("w0"), vim.fn.line("w$") do
                table.insert(results, {
                    pos = { i, 1 },
                    end_pos = { i, 0 },
                })
            end
            return results
        end,
        action = function(match, _)
            vim.api.nvim_set_current_win(match.win)
            vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, { match.pos[1], 0 })
            end)
        end,
    })
end

vim.keymap.set({ "o", "x" }, "<c-w>", function()
    local operator = vim.v.operator
    local register = vim.v.register
    vim.api.nvim_feedkeys(vim.keycode("<esc>"), "o", true)
    vim.schedule(function()
        require("flash").jump({
            action = function(match, state)
                local op_func = vim.go.operatorfunc
                local saved_view = vim.fn.winsaveview()
                vim.api.nvim_set_current_win(match.win)
                vim.api.nvim_win_set_cursor(match.win, match.pos)
                _G.flash_op = function()
                    local start = vim.api.nvim_buf_get_mark(0, "[")
                    local finish = vim.api.nvim_buf_get_mark(0, "]")
                    vim.api.nvim_cmd({ cmd = "normal", bang = true, args = { "v" } }, {})
                    vim.api.nvim_win_set_cursor(0, { start[1], start[2] })
                    vim.cmd("normal! o")
                    vim.api.nvim_win_set_cursor(0, { finish[1], finish[2] })
                    vim.api.nvim_input('"' .. register .. operator)

                    vim.schedule(function()
                        vim.api.nvim_set_current_win(state.win)
                        vim.fn.winrestview(saved_view)
                        vim.go.operatorfunc = op_func
                    end)

                    _G.flash_op = nil
                end
                vim.go.operatorfunc = "v:lua.flash_op"
                vim.api.nvim_feedkeys("g@", "n", false)
            end,
        })
    end)
end)
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

local M = {}
M.setup = function()
    require("flash").setup({
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = {
            -- save location in the jumplist
            jumplist = true,
            -- jump position
            pos = "start", ---@type "start" | "end" | "range"
            -- add pattern to search history
            history = true,
            -- add pattern to search register
            register = true,
            -- clear highlight after jump
            nohlsearch = false,
            autojump = true,
        },
        highlight = {
            label = {
                -- add a label for the first match in the current window.
                -- you can always jump to the first match with `<CR>`
                current = true,
                -- show the label after the match
                after = true, ---@type boolean|number[]
                -- show the label before the match
                before = true, ---@type boolean|number[]
                -- position of the label extmark
                style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
                -- flash tries to re-use labels that were already assigned to a position,
                -- when typing more characters. By default only lower-case labels are re-used.
                reuse = "lowercase", ---@type "lowercase" | "all"
            },
        },
        modes = {
            -- options used when flash is activated theough
            -- a regular search with `/` or `?`
            search = {
                enabled = true, -- enable flash for search
                highlight = { backdrop = true },
                jump = { history = true, register = true, nohlsearch = false },
                search = {
                    -- `forward` will be automatically set to the search direction
                    -- `mode` is always set to `search`
                    -- `incremental` is set to `true` when `incsearch` is enabled
                },
            },
            char = {
                enabled = true,
                search = { wrap = true },
                highlight = { backdrop = true },
                jump = { register = true },
            },
            treesitter = {
                labels = "abcdefghijklmnopqrstuvwxyz",
                jump = { pos = "range" },
                highlight = {
                    label = { before = true, after = true, style = "inline" },
                    backdrop = true,
                    matches = true,
                },
            },
        },
    })
end

M.binds = function()
    return {
        {
            "x",
            mode = { "o", "x" },
            function()
                -- default options: exact mode, multi window, all directions, with a backdrop
                require("flash").jump({
                    search = { forward = true, wrap = false, multi_window = false },
                })
            end,
        },
        {
            "X",
            mode = { "o", "x" },
            function()
                require("flash").jump({
                    search = { forward = false, wrap = false, multi_window = false },
                })
            end,
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
        },
        {
            "S",
            mode = { "n" },
            function()
                require("flash").jump({
                    search = { forward = false, wrap = false, multi_window = false },
                })
            end,
        },
        {
            "S", -- trree hopper thing replacement in some sense
            mode = { "o", "x" },
            function()
                require("flash").treesitter()
            end,
        },
        {
            "<S-cr>",
            mode = { "n", "o", "x" },
            function()
                require("flash").jump()
            end,
        },
        {
            "<c-s>",
            mode = { "n", "o", "x" },
            function()
                require("flash").jump({
                    search = { multi_window = false },
                })
            end,
        },

        {
            "<leader>l",
            mode = { "n" },
            function()
                require("flash").jump({
                    action = function(match, state)
                        vim.api.nvim_win_call(match.win, function()
                            vim.api.nvim_win_set_cursor(match.win, match.pos)
                            vim.diagnostic.open_float()
                            vim.api.nvim_win_set_cursor(match.win, state.pos)
                        end)
                    end,
                })
            end,
        },
        {
            "<c-p>",
            mode = { "n" },
            function()
                jump_windows()
            end,
        },
        {
            "<c-e>",
            mode = { "n" },
            function()
                jump_lines()
            end,
        },
        {
            "<c-w><c-w>",
            mode = { "n" },
            function()
                require("flash").jump({
                    search = {
                        mode = function(str)
                            return "\\<" .. str
                        end,
                    },
                })
            end,
        },
        {
            "z<cr>",
            function()
                require("flash").treesitter()
                vim.cmd("normal! Vzf")
            end,
            mode = "n",
            silent = true,
            desc = "God Fold",
        },
        {
            "*",
            function()
                require("lasterisk").search()
                vim.schedule(search_win)
            end,
            desc = "Search cword",
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
            desc = "Search cword",
        },
        {
            "g*",
            function()
                require("lasterisk").search({ is_whole = false })
                vim.schedule(search_win)
            end,
            desc = "Search cword",
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
            desc = "Search cword (ref)",
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
            desc = "Search cword",
        },
        {
            "g#",
            function()
                require("lasterisk").search({ is_whole = false })
                vim.schedule(search_win)
            end,
            desc = "Search cword",
        },
    }
end

return M
