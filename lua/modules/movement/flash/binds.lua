---@diagnostic disable: undefined-field
local lib = require("modules.movement.flash.nav.lib")
local lsp_utils = require("modules.lsp.lsp.utils")
local Flash = lambda.reqidx("flash")

return {

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Word Jumpers                                               │
    --  ╰────────────────────────────────────────────────────────────────────╯
    {
        "?",
        mode = { "n" },
        function()
            Flash.jump({ mode = "fuzzy" })
        end,
        desc = "Fuzzy search",
    },
    {
        "?",
        mode = { "o" },
        function()
            Flash.remote({ mode = "select" })
        end,
        desc = "Fuzzy Sel",
    },
    {
        "?",
        mode = "x",
        function()
            Flash.jump({ mode = "select" })
        end,
        desc = "Fuzzy Sel",
    },
    "/",
    {
        "x",
        mode = { "o", "x" },
        function()
            -- Flash: exact mode, multi window, all directions, with a backdrop
            Flash.jump({
                continue = true,
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
                continue = true,
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
            Flash.jump({
                search = { forward = true, wrap = false, multi_window = false },
            })
        end,
        desc = "Normal Mode Flash Forward",
    },
    {
        "S",
        mode = { "n" },
        function()
            Flash.jump({
                search = { forward = false, wrap = false, multi_window = false },
            })
        end,
        desc = "Normal Mode Flash Backward",
    },

    {
        "S", -- trree hopper thing replacement in some sense
        mode = { "o", "x" },
        function()
            Flash.treesitter()
        end,
        desc = "Operator Pending Flash Treesitter",
    },
    {
        "<leader>W",
        mode = { "n", "o", "x" },
        function()
            Flash.jump({
                pattern = vim.fn.expand("<cword>"),
            })
        end,

        desc = "Flash Current word",
    },

    {
        "<S-cr>",
        mode = { "n", "o", "x" },
        function()
            Flash.jump()
        end,

        desc = "Flash Current Screen",
    },
    {
        "<leader>ww",
        mode = { "n", "o", "x" },
        function()
            Flash.jump({
                search = { mode = "search" },
                label = { after = false, before = { 0, 0 }, uppercase = false },
                pattern = [[\<\|\>]],
                action = function(match, state)
                    state:hide()
                    Flash.jump({
                        search = { max_length = 0 },
                        label = { distance = false },
                        highlight = { matches = false },
                        matcher = function(win)
                            return vim.tbl_filter(function(m)
                                return m.label == match.label and m.win == win
                            end, state.results)
                        end,
                    })
                end,
                labeler = function(matches, state)
                    local labels = state:labels()
                    for m, match in ipairs(matches) do
                        match.label = labels[math.floor((m - 1) / #labels) + 1]
                    end
                end,
            })
        end,

        desc = "Flash Current Screen",
    },

    {
        --  TODO: (vsedov) (21:59:14 - 24/06/23): Return this to normal if this is not viable
        "<c-s>",
        mode = { "n", "o", "x" },
        function()
            Flash.jump({
                search = {
                    multi_window = false,
                    mode = "textcase",
                },
            })
        end,
        desc = "Flash Current buffer",
    },
    {
        "<c-s>",
        mode = { "c" },
        function()
            Flash.toggle()
        end,
        desc = "Toggle Flash Search",
    },
    {
        "<leader>/",
        mode = { "n", "x", "o" },
        function()
            Flash.jump({
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
    --  'gt' - go to definition
    -- 'gT' - go to type definition
    -- 'gr' - references
    -- 'gd' - go to declaration
    {
        "gf",
        function()
            local prev_timeout = vim.opt.timeout

            vim.opt.timeout = false

            Flash.jump({
                action = function(match, state)
                    state:hide()

                    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

                    vim.api.nvim_set_current_win(match.win)
                    vim.api.nvim_win_set_cursor(match.win, match.pos)

                    local key = vim.api.nvim_replace_termcodes("<Ignore>" .. "g", true, true, true)

                    vim.api.nvim_feedkeys(key, "i", false)

                    vim.schedule(function()
                        vim.api.nvim_win_set_cursor(match.win, { row, col })
                        vim.opt.timeout = prev_timeout
                        require("flash.jump").restore_remote(state)
                    end)
                end,
                search = {
                    max_length = 2,
                },
                label = {
                    before = { 0, 2 },
                    after = false,
                },
            })
        end,
        desc = "Go to definition on jump",
    },
    {
        "J",
        desc = "Hover",
        function()
            Flash.jump({ mode = "hover" })
        end,
    },
    {
        "D",
        mode = { "n" },
        function()
            Flash.jump({
                pattern = ".", -- initialize pattern with any char
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
            -- lib.flash_diagnostics(opts)
        end,
        desc = "Show diagnostics at target, without changing cursor position",
    },
    {
        "<leader>s",
        mode = { "n" },
        lib.flash_references,
        desc = "Flash Lsp References",
    },
    {
        "<leader>;",
        function()
            require("modules.movement.flash.nav.lib").flash_diagnostics({
                action = require("actions-preview").code_actions,
            })
        end,
        desc = "Diagnostics + Code Action",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Window Jump and jump lines                                 │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<c-p>",
        mode = { "n" },
        lib.jump_windows,
        desc = "Jump Windows",
    },
    {
        "<c-e>",
        mode = { "n" },
        lib.flash_lines,
        desc = "Jump Lines",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Fold                                                       │
    --  ╰────────────────────────────────────────────────────────────────────╯
    {
        "z<cr>",
        function()
            Flash.treesitter()
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
            lib.search_win()
        end,
        desc = "Search cword *",
    },
    {
        "*",
        function()
            require("lasterisk").search({ is_whole = false })
            vim.schedule(lib.search_win)
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
            lib.search_win()
        end,
        desc = "Search cword g*",
    },
    {
        "#",
        function()
            if lib.search_ref() then
                return
            end
            require("lasterisk").search()
            lib.search_win()
        end,
        desc = "Search cword (ref) # ",
    },
    {
        "#",
        function()
            require("lasterisk").search({ is_whole = false })

            vim.schedule(lib.search_win)
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
            lib.search_win()
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
            Flash.remote()
        end,
        desc = "Remote Jump",
    },
    {
        "M", -- [M, r, <cr>]
        mode = { "n", "x", "o" },
        function()
            local win = vim.api.nvim_get_current_win()
            local view = vim.fn.winsaveview()
            Flash.jump({
                action = function(match, state)
                    state:hide()
                    vim.api.nvim_set_current_win(match.win)
                    vim.api.nvim_win_set_cursor(match.win, match.pos)
                    Flash.treesitter()
                    vim.schedule(function()
                        vim.api.nvim_set_current_win(win)
                        vim.fn.winrestview(view)
                    end)
                end,
            })
        end,
        desc = [[
            Jump to a position, make a Treesitter selection and jump back This should be bound to a keymap like M.
            Then you could o yM to remotely yank a Treesitter selection.
        ]],
    },

    {
        "R",
        function()
            Flash.treesitter_search({
                highlight = {
                    label = { before = true, after = true, style = "inline" },
                },
                remote_op = { restore = true },
            })
        end,
        mode = { "n", "x", "o" },
        desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
    },
    "f",
    "t",
    "F",
    "T",
}
