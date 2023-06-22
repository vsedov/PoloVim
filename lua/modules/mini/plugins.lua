local mini = require("core.pack").package
local conf = require("modules.mini.config")

mini({
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
        require("mini.ai").setup({ mappings = { around_last = "", inside_last = "" } })
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
                "neo-tree",
                "nnn",
                "notify",
                "NvimTree",
                "qf",
                "starter", -- mini.starter
                "toggleterm",
                "Trouble",
                "neoai-input",
                "neoai-*",
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
    cond = lambda.config.ui.use_mini_animate,
    event = "VeryLazy",
    config = conf.mini,
})
-- NOTE: (vsedov) (15:53:38 - 13/06/23): this is nice to have so no point removing this
mini({
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    config = true,
})
mini({
    "echasnovski/mini.align",
    event = "VeryLazy",
    config = true,
})
