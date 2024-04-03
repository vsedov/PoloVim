local mini = require("core.pack").package
local conf = require("modules.mini.config")
local mini_opt = lambda.config.ui.mini_animate
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
        "neorg",
        "norg",
        "*.norg",
        "*norg",
        "*neorg",
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

mini({
    "echasnovski/mini.indentscope",
    cond = lambda.config.ui.indent_lines.use_mini_indent_scope,
    event = { "VeryLazy" },
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
