-- local labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM,?/.;#",
-- local labels = "jklfdsahg;nm,.?/ervcxzbuioyptwq"
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
            incremental = false,
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
            after = false, ---@type boolean|number[]
            -- show the label before the match
            before = true, ---@type boolean|number[]
            -- position of the label extmark
            style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
            -- flash tries to re-use labels that were already assigned to a position,
            -- when typing more characters. By default only lower-case labels are re-used.
            reuse = "lowercase", ---@type "lowercase" | "all"
            -- for the current window, label targets closer to the cursor first
            distance = true,
            -- minimum pattern length to show labels
            -- Ignored for custom labelers.
            min_pattern_length = 0,
            -- Enable this to use rainbow colors to highlight labels
            -- Can be useful for visualizing Treesitter ranges.
            -- Pretty stupid ngl
            rainbow = {
                enabled = false,
                -- number between 1 and 9
                shade = 9,
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
        -- action to perform when picking a label.
        -- defaults to the jumping logic depending on the mode.
        ---@type fun(match:Flash.Match, state:Flash.State)|nil
        action = nil,
        -- initial pattern to use when opening flash
        pattern = "",
        -- When `true`, flash will try to continue the last search
        continue = false,
        -- You can override the default options for a specific mode.
        -- Use it with `require("flash").jump({mode = "forward"})`
        ---@type table<string, Flash.Config>
        modes = {
            -- options used when flash is activated through
            -- a regular search with `/` or `?`
            search = {
                -- when `true`, flash will be activated during regular search by default.
                -- You can always toggle when searching with `require("flash").toggle()`
                enabled = true,
                highlight = { backdrop = false },
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

                -- dynamic configuration for ftFT motions
                config = function(opts)
                    -- autohide flash when in operator-pending mode
                    opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

                    -- disable jump labels when enabled and when using a count
                    opts.jump_labels = opts.jump_labels and vim.v.count == 0

                    -- Show jump labels only in operator-pending mode
                    -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
                end,
                -- hide after jump when not using jump labels
                autohide = true,
                -- show jump labels
                jump_labels = true,
                -- When using jump labels, don't use these keys
                -- This allows using those keys directly after the motion
                label = { exclude = "hjkliardc" },
                -- by default all keymaps are enabled, but you can disable some of them,
                -- by removing them from the list.
                -- If you rather use another key, you can map them
                -- to something else, e.g., { [";"] = "L", [","] = H }
                keys = { "f", "F", "t", "T", [";"] = "L", [","] = "H" },
                search = { wrap = false },
                highlight = { backdrop = true },
                jump = { register = true },
            },
            -- options used for treesitter selections
            -- `require("flash").treesitter()`
            treesitter = {
                labels = labels,
                jump = { pos = "range" },
                search = { incremental = false },
                label = { before = true, after = true, style = "inline" },
                highlight = {
                    backdrop = true,
                    matches = true,
                },
            },
            treesitter_search = {
                jump = { pos = "range" },
                search = { multi_window = true, wrap = true, incremental = false },
                remote_op = { restore = true },
                label = { before = true, after = true, style = "inline" },
            },
            fuzzy = {
                search = { mode = "fuzzy" },
                -- highlight = {
                -- label = { before = true, after = false },
                -- },
            },
            -- options used for remote flash
            remote = {
                remote_op = { restore = true, motion = true },
            },
            leap = {
                search = {
                    max_length = 2,
                },
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
                            require("hover").hover()
                            -- vim.lsp.handlers.hover(err, result, ctx, { focusable = true, focus = true })
                            -- vim.api.nvim_win_set_cursor(match.win, state.pos)
                        end)
                    end)
                end,
            },
            select = {
                search = { mode = "fuzzy" },
                jump = { pos = "range" },
                highlight = {
                    label = { before = true, after = true },
                },
            },
            references = {},
        },
        -- options for the floating window that shows the prompt,
        -- for regular jumps
        prompt = {
            enabled = true,
            prefix = { { "⚡", "FlashPromptIcon" } },
            win_config = {
                relative = "editor",
                width = 1, -- when <=1 it's a percentage of the editor width
                height = 1,
                row = -1, -- when negative it's an offset from the bottom
                col = 0, -- when negative it's an offset from the right
                zindex = 1000,
            },
        },
        -- options for remote operator pending mode
        remote_op = {
            -- restore window views and cursor position
            -- after doing a remote operation
            restore = false,
            -- For `jump.pos = "range"`, this setting is ignored.
            -- `true`: always enter a new motion when doing a remote operation
            -- `false`: use the window's cursor position and jump target
            -- `nil`: act as `true` for remote windows, `false` for the current window
            motion = false,
        },
    }
end

local function highlight()
    vim.api.nvim_set_hl(0, "FlashBackdrop", { link = "Conceal" })
    vim.api.nvim_set_hl(0, "FlashLabel", {
        fg = "#ff2f87",
        bold = true,
        nocombine = true,
    })
end

function config(_, op)
    require("flash").setup(op)
    highlight()
    lambda.augroup("Flash_Colourchange", {
        {
            event = { "ColorScheme" },
            pattern = "*",
            command = function()
                highlight()
            end,
        },
    })
end
return {
    opts = opts,
    config = config,
}
