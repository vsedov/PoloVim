local api = vim.api
function paranormal(targets)
    -- Get the :normal sequence to be executed.
    local input = vim.fn.input("normal! ")
    if #input < 1 then
        return
    end

    local ns = api.nvim_create_namespace("")

    -- Set an extmark as an anchor for each target, so that we can also execute
    -- commands that modify the positions of other targets (insert/change/delete).
    for _, target in ipairs(targets) do
        local line, col = unpack(target.pos)
        id = api.nvim_buf_set_extmark(0, ns, line - 1, col - 1, {})
        target.extmark_id = id
    end

    -- Jump to each extmark (anchored to the "moving" targets), and execute the
    -- command sequence.
    for _, target in ipairs(targets) do
        local id = target.extmark_id
        local pos = api.nvim_buf_get_extmark_by_id(0, ns, id, {})
        vim.fn.cursor(pos[1] + 1, pos[2] + 1)
        vim.cmd("normal! " .. input)
    end

    -- Clean up the extmarks.
    api.nvim_buf_clear_namespace(0, ns, 0, -1)
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

local function jump_windows()
    require("flash").jump({
        search = { multi_window = true, wrap = true },
        highlight = { backdrop = true, label = { current = true } },
        matcher = function(win)
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
            nohlsearch = true,
        },
        modes = {
            -- options used when flash is activated theough
            -- a regular search with `/` or `?`
            search = {
                enabled = true, -- enable flash for search
                highlight = { backdrop = true },
                jump = { history = true, register = true, nohlsearch = true },
                search = {
                    -- `forward` will be automatically set to the search direction
                    -- `mode` is always set to `search`
                    -- `incremental` is set to `true` when `incsearch` is enabled
                },
            },
            -- options used when flash is activated through
            -- `f`, `F`, `t`, `T`, `;` and `,` motions
            char = {
                enabled = true,
                search = { wrap = true },
                highlight = { backdrop = true },
                jump = { register = true },
            },
            -- options used for treesitter selections
            -- `require("flash").treesitter()`
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
            "<c-s>", -- trree hopper thing replacement in some sense
            mode = { "n", "o", "x" },
            function()
                require("flash").jump()
            end,
        },
        {
            "\\<cr>", -- this does not work yet.
            mode = { "n", "o", "x" },
            function()
                require("flash").jump({
                    search = { multi_window = true, wrap = true },
                    highlight = { backdrop = true, label = { current = true } },

                    action = paranormal,
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
    }
end

return M
