local function opts()
    return {
        labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM,?/.;#",

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
            incremental = true, -- Enable this
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
            -- You can force inclusive/exclusive jumps by setting the
            -- `inclusive` option. By default it will be automatically
            -- set based on the mode.
            inclusive = nil, ---@type boolean?
            -- jump position offset. Not used for range jumps.
            -- 0: default
            -- 1: when pos == "end" and pos < current position
            offset = nil, ---@type number
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
        continue = true,
        -- You can override the default options for a specific mode.
        -- Use it with `require("flash").jump({mode = "forward"})`
        ---@type table<string, Flash.Config>
        modes = {
            -- options used when flash is activated through
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
                enabled = false,
                -- by default all keymaps are enabled, but you can disable some of them,
                -- by removing them from the list.
                keys = { "f", "F", "t", "T", ";", "," },
                search = { wrap = true },
                highlight = { backdrop = true },
                jump = { register = true },
            },
            -- options used for treesitter selections
            -- `require("flash").treesitter()`
            treesitter = {
                labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM,?/.;#",

                jump = { pos = "range" },
                highlight = {
                    label = { before = true, after = true, style = "inline" },
                    backdrop = true,
                    matches = true,
                },
            },
            -- options used for remote flash
            remote = {},
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

function config(_, opts)
    require("flash").setup(opts)
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
