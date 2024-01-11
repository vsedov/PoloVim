-- local labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM,?/.;#",
-- local labels = "¬"
local labels = "sfnjklhodwembuyvrgtcxzSZFNJKLHODWEMBUYVRGTCXZ/?.,;#"
local lib = require("modules.movement.flash.nav.lib")
local lsp_utils = require("modules.lsp.lsp.utils")

local function opts()
    return {
        labels = labels,
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
            mode = "exact",
            -- behave like `incsearch`
            incremental = true,
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
            nohlsearch = true,
            -- automatically jump when there is only one match
            autojump = true,
        },
        label = {
            -- allow uppercase labels
            uppercase = true,
            -- add any labels with the correct case here, that you want to exclude
            exclude = "",
            -- add a label for the first match in the current window.
            -- you can always jump to the first match with `<CR>`
            current = true,
            -- show the label after the match
            after = true, ---@type boolean|number[]
            -- show the label before the match
            before = false, ---@type boolean|number[]
            -- position of the label extmark
            style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
            -- flash tries to re-use labels that were already assigned to a position,
            -- when typing more characters. By default only lower-case labels are re-used.
            reuse = "all", ---@type "lowercase" | "all"
            -- for the current window, label targets closer to the cursor first
            distance = true,
            -- minimum pattern length to show labels
            -- Ignored for custom labelers.
            min_pattern_length = 0,
            -- Enable this to use rainbow colors to highlight labels
            -- Can be useful for visualizing Treesitter ranges.
            -- Pretty stupid ngl
            rainbow = {
                enabled = true,
                -- number between 1 and 9
                shade = 1,
            },
            -- With `format`, you can change how the label is rendered.
            -- Should return a list of `[text, highlight]` tuples.
            ---@class Flash.Format
            ---@field state Flash.State
            ---@field match Flash.Match
            ---@field hl_group string
            ---@field after boolean
            ---@type fun(opts:Flash.Format): string[][]
            format = function(opts)
                return { { opts.match.label, opts.hl_group } }
            end,
        },
        highlight = {
            -- show a backdrop with hl FlashBackdrop
            backdrop = true,
            -- Highlight the search matches
            matches = true,
            -- extmark priority
            priority = 5000,
            groups = {
                match = "FlashMatch",
                current = "FlashCurrent",
                backdrop = "FlashBackdrop",
                label = "FlashLabel",
            },
        },

        modes = {
            search = {
                label = { min_pattern_length = 3 },
            },
            char = {
                enabled = false,
                keys = { "f", "f", "t", "t" },
            },
            treesitter = {
                labels = "sfnjklhodwembuyvrgtcxzszfnjklhodwembuyvrgtcxz/?.,;#",

                remote_op = {
                    restore = true,
                    motion = true,
                },
                search = { multi_window = false, wrap = true, incremental = false, max_length = 0 },
                config = function(opts)
                    if false and vim.fn.mode() == "v" then
                        opts.labels:gsub("[cdyrx]", "") -- todo: remove all operations
                    end
                end,
                treesitter = { containing_end_pos = true },
                matcher = lib.custom_ts,
                actions = lib.ts_actions,
            },
            remote_ts = {
                -- todo: use `;,<cr><tab><spc` to extend the selection to sibling nodes
                -- todo: integrate i/a textobjects somehow. maybe 'i<label><char>' = jump<label> i<char>
                mode = "treesitter",
                search = {
                    mode = lib.remote_ts_search,
                    max_length = 2,
                    incremental = false,
                },
                jump = { pos = "range", register = false },
                highlight = { matches = true },
                treesitter = { containing_end_pos = true },
                actions = lib.ts_actions,
                remote_op = {
                    restore = true,
                    motion = true,
                },
                matcher = lib.remote_ts,
            },
            fuzzy = {
                search = { mode = "fuzzy", max_length = 9999 },
                label = { min_pattern_length = 4 },
                -- label = { before = true, after = false },
            },
            leap = {
                search = {
                    max_length = 2,
                },
            },
            textcase = {
                search = { mode = lib.mode_textcase },
            },
            search_diagnostics = {
                search = { mode = "fuzzy" },
                action = lib.there_and_back(lsp_utils.diag_line),
            },
            hover = {
                search = { mode = "fuzzy" },
                action = function(match, state)
                    vim.api.nvim_win_call(match.win, function()
                        vim.api.nvim_win_set_cursor(match.win, match.pos)
                        lsp_utils.hover(function(err, result, ctx)
                            vim.cmd("lspsaga hover_doc")
                            -- vim.lsp.handlers.hover(err, result, ctx, { focusable = true, focus = true })
                            vim.api.nvim_win_set_cursor(match.win, state.pos)
                        end)
                    end)
                end,
            },
            select = {
                search = { mode = "fuzzy" },
                jump = { pos = "range" },
                label = { before = true, after = true },
            },
            references = {},
            diagnostics = {
                search = { multi_window = true, wrap = true, incremental = true },
                label = { current = true },
                highlight = { backdrop = true },
            },
            remote = {
                search = { mode = "fuzzy" },
                jump = { autojump = true },
            },
        },
    }
end

local function highlight()
    vim.api.nvim_set_hl(0, "FlashBackdrop", { link = "Conceal" })
    -- vim.api.nvim_set_hl(0, "FlashMatch", {
    --     fg = "white", -- for light themes, set to 'black' or similar
    --     bold = true,
    --     nocombine = true,
    -- })
    -- vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#4b579e" })
    vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", bold = true, fg = "#bdc9ff" })

    --    vim.api.nvim_set_hl(0, "FlashCurrent", {
    --      fg = "#ff2f87",
    --    bold = true,
    --  nocombine = true,
    -- })
    --
    -- vim.api.nvim_set_hl(0, "FlashCurrent", {
    --     fg = "white", -- for light themes, set to 'black' or similar
    --     bold = true,
    --     nocombine = true,
    -- })
    -- vim.api.nvim_set_hl(0, "FlashMatch", {
    --     fg = "#ff2f87",
    --     bold = true,
    --     nocombine = true,
    -- })
end

function config(_, op)
    require("flash").setup(op)
    lambda.augroup("Flash_Colourchange", {
        {
            event = { "ColorScheme" },
            pattern = "*",
            command = function()
                highlight()
            end,
        },
    })
    vim.defer_fn(function()
        highlight()
    end, 500)
end

highlight()
return {
    opts = opts,
    config = config,
    binds = require("modules.movement.flash.keybinds"),
}
