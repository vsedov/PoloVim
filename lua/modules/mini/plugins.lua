local mini = require("core.pack").package
local conf = require("modules.mini.config")
local mini_opt = lambda.config.ui.mini_animate

mini({
    "echasnovski/mini.ai",
    keys = { { "[f", desc = "Prev function" }, { "]f", desc = "Next function" } },
    opts = function()
        -- add treesitter jumping
        ---@param capture string
        ---@param start boolean
        ---@param down boolean
        local function jump(capture, start, down)
            local rhs = function()
                local parser = vim.treesitter.get_parser()
                if not parser then
                    return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
                end

                local query = vim.treesitter.get_query(vim.bo.filetype, "textobjects")
                if not query then
                    return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
                end

                local cursor = vim.api.nvim_win_get_cursor(0)

                ---@type {[1]:number, [2]:number}[]
                local locs = {}
                for _, tree in ipairs(parser:trees()) do
                    for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
                        if query.captures[capture_id] == capture then
                            local range = { node:range() } ---@type number[]
                            local row = (start and range[1] or range[3]) + 1
                            local col = (start and range[2] or range[4]) + 1
                            if down and row > cursor[1] or not down and row < cursor[1] then
                                table.insert(locs, { row, col })
                            end
                        end
                    end
                end
                return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
            end

            local c = capture:sub(1, 1):lower()
            local lhs = (down and "]" or "[") .. (start and c or c:upper())
            local desc = (down and "Next " or "Prev ")
                .. (start and "start" or "end")
                .. " of "
                .. capture:gsub("%..*", "")
            vim.keymap.set("n", lhs, rhs, { desc = desc })
        end

        for _, capture in ipairs({ "function.outer", "class.outer" }) do
            for _, start in ipairs({ true, false }) do
                for _, down in ipairs({ true, false }) do
                    jump(capture, start, down)
                end
            end
        end
    end,
})

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
