local mini = require("core.pack").package
local conf = require("modules.mini.config")
local mini_opt = lambda.config.ui.mini_animate

mini({
    "echasnovski/mini.indentscope",
    cond = lambda.config.ui.indent_lines.use_mini_indent_scope,
    event = { "UIEnter" },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "alpha",
                "coc-explorer",
                "dashboard",
                "fzf", -- fzf-lua
                "help",
                "lazy",
                "lazyterm",
                "lspsagafinder",
                "mason",
                "nnn",
                "notify",
                "NvimTree",
                "qf",
                "starter", -- mini.starter
                "toggleterm",
                "Trouble",
                "neoai-input",
                "neoai-*",
                "neoai-output",
                "neo-tree",
                "neo-*",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
                vim.schedule(function()
                    if MiniIndentscope then
                        MiniIndentscope.undraw()
                    end
                end)
            end,
        })
    end,
    opts = {
        symbol = "│",
        options = {
            border = "both",
            indent_at_cursor = true,
            try_as_border = true,
        },
    },
})
mini({
    "echasnovski/mini.animate",
    cond = lambda.config.ui.mini_animate.use_animate,
    event = "VeryLazy",
    opts = function()
        -- don't use animate when scrolling with the mouse
        local mouse_scrolled = false
        for _, scroll in ipairs({ "Up", "Down" }) do
            local key = "<ScrollWheel" .. scroll .. ">"
            vim.keymap.set({ "", "i" }, key, function()
                mouse_scrolled = true
                return key
            end, { expr = true })
        end

        local animate = require("mini.animate")
        return {
            cursor = {
                enable = mini_opt.use_cursor,
                timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
            },
            resize = {
                enable = mini_opt.use_resize,
            },
            close = {
                enable = mini_opt.use_close,
            },
            open = {
                enable = false,
                timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
            },
            scroll = {
                enable = mini_opt.use_scroll,

                -- timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
                -- subscroll = animate.gen_subscroll.equal({
                --     max_output_steps = 60,
                --     predicate = function(total_scroll)
                --         if mouse_scrolled then
                --             mouse_scrolled = false
                --             return false
                --         end
                --         return total_scroll > 1
                --     end,
                -- }),
            },
        }
    end,
})
-- NOTE: (vsedov) (15:53:38 - 13/06/23): this is nice to have so no point removing this
mini({
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    init = function()
        lambda.command("TrimTrailSpace", function()
            MiniTrailspace.trim()
        end, {})
        lambda.command("TrimLastLine", function()
            MiniTrailspace.trim_last_lines()
        end, {})
    end,
    config = true,
})

-- mini({
--     "echasnovski/mini.align",
--     main = "mini.align",
--     opts = {},
--     keys = { { "ga" } },
-- })

mini({
    "echasnovski/mini.clue",
    cond = lambda.config.tools.use_which_key_or_use_mini_clue == "mini",
    event = "VeryLazy",
    config = function()
        local miniclue = require("mini.clue")
        miniclue.setup({
            triggers = {
                --  ──────────────────────────────────────────────────────────────────────

                -- Leader triggers
                { mode = "n", keys = ";" },
                { mode = "x", keys = ";" },
                { mode = "n", keys = "_" },
                { mode = "x", keys = "_" },

                { mode = "n", keys = "<Leader>" },
                { mode = "x", keys = "<Leader>" },
                --  ──────────────────────────────────────────────────────────────────────
                { mode = "x", keys = "<cr>" },
                { mode = "o", keys = "<cr>" },
                --  ──────────────────────────────────────────────────────────────────────

                { mode = "n", keys = "<c-g>" },
                { mode = "x", keys = "<c-g>" },
                --  ──────────────────────────────────────────────────────────────────────
                { mode = "n", keys = "," },
                { mode = "x", keys = "," },
                --  ──────────────────────────────────────────────────────────────────────

                { mode = "n", keys = "\\" },
                { mode = "x", keys = "\\" },
                --  ──────────────────────────────────────────────────────────────────────

                { mode = "x", keys = "]" },
                { mode = "o", keys = "]" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Built-in completion
                { mode = "i", keys = "<C-x>" },
                --  ──────────────────────────────────────────────────────────────────────

                -- -- `g` key
                -- { mode = "n", keys = "g" },
                -- { mode = "x", keys = "g" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Marks
                { mode = "n", keys = "'" },
                { mode = "n", keys = "`" },
                { mode = "x", keys = "'" },
                { mode = "x", keys = "`" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Registers
                { mode = "n", keys = '"' },
                { mode = "x", keys = '"' },
                { mode = "i", keys = "<C-r>" },
                { mode = "c", keys = "<C-r>" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Window commands
                { mode = "n", keys = "<C-w>" },
                --  ──────────────────────────────────────────────────────────────────────

                -- `z` key
                { mode = "n", keys = "z" },
                { mode = "x", keys = "z" },
                --  ──────────────────────────────────────────────────────────────────────

                -- { mode = "n", keys = ";r" },
                -- { mode = "x", keys = ";r" },

                { mode = "n", keys = "m" },
                { mode = "x", keys = "m" },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
            window = {
                delay = 100,
            },
        })
    end,
})
