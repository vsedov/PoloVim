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

local M = {}
function M.highlight()
    vim.api.nvim_set_hl(0, "FlashBackdrop", { link = "Conceal" })
    vim.api.nvim_set_hl(0, "FlashLabel", {
        fg = "#ff2f87",
        bold = true,
        nocombine = true,
    })
end

M.setup = function()
    require("flash").setup({
        labels = "sfnjklhodwembuyvrgtcx/zSFNJKLHODWEMBUYVRGTCX?Z",
        search = {
            -- search/jump in all windows
            multi_window = true,
            -- search direction
            forward = true,
            -- when `false`, find only matches in the given direction
            wrap = true,
            ---@type Flash.Pattern.Mode
            -- Each mode will take ignorecase and smartcase into account.
            -- * exact: exact match
            -- * search: regular search
            -- * fuzzy: fuzzy search
            -- * fun(str): custom function that returns a pattern
            --   For example, to only match at the beginning of a word:
            --   mode = function(str)
            --     return "\\<" .. str
            --   end,
            mode = "fuzzy", -- go with fuzzy for now, as i feel like this would feel the best right
            -- behave like `incsearch`
            incremental = false,
            filetype_exclude = { "notify", "noice" },
        },
        char = {
            keys = { "f", "F", "t", "T", ";", "," },
            enabled = true,
            search = { wrap = true },
            highlight = { backdrop = true },
            jump = { register = true },
        },

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
                after = false, ---@type boolean|number[]
                -- show the label before the match
                before = true, ---@type boolean|number[]
                -- position of the label extmark
                style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
                -- flash tries to re-use labels that were already assigned to a position,
                -- when typing more characters. By default only lower-case labels are re-used.
                reuse = "all", ---@type "lowercase" | "all"
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
                    search = {
                        incremental = true,
                        trigger = ";",
                    },
                },
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

    M.highlight()
    lambda.augroup("Flash_Colourchange", {
        {
            event = { "ColorScheme" },
            pattern = "*",
            command = function()
                M.highlight()
            end,
        },
    })
end
M.binds = function()
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
            "<c-s>",
            mode = { "n", "o", "x" },
            function()
                require("flash").jump({
                    search = { multi_window = false },
                })
            end,
            desc = "Flash Current buffer",
        },
        {
            -- "<c-w><c-w>",
            "<leader>S",
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
            desc = "Match beginning of words only",
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
            ";a",
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
            "r",
            mode = { "o", "x" },
            function()
                require("flash").remote()
            end,
            desc = "Remote Jump",
        },
        {

            "M",
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
            desc = "Jump to a position, make a Treesitter selection and jump back This should be bound to a keymap like <leader>t. Then you could do y<leader>t to remotely yank a Treesitter selection.",
        },
    }
end

return M
