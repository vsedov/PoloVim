local config = {}
function config.nvim_treesitter()
    require("modules.treesitter.treesitter").treesitter()
end

function config.endwise()
    require("modules.treesitter.treesitter").endwise()
end

function config.treesitter_obj()
    require("modules.treesitter.treesitter").treesitter_obj()
end

function config.rainbow()
    require("modules.treesitter.treesitter").rainbow()
end

function config.treesitter_ref()
    require("modules.treesitter.treesitter").treesitter_ref()
end

function config.tsubject()
    require("nvim-treesitter.configs").setup({
        textsubjects = {
            enable = true,
            keymaps = { ["<CR>"] = "textsubjects-smart", [";"] = "textsubjects-container-outer" },
        },
    })
end

function config.playground()
    require("nvim-treesitter.configs").setup({
        playground = {
            enable = true,
            disable = {},
            updatetime = 50, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = true, -- Whether the query persists across vim sessions
        },
    })
end

function config.context()
    require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    })
end

function config.hlargs()
    require("utils.ui.highlights").plugin("hlargs", {
        { Hlargs = { fg = "#ef9062", italic = true, bold = false } },
    })
    require("hlargs").setup({
        color = "#ef9062",
        highlight = {},
        excluded_filetypes = {},
        paint_arg_declarations = true,
        paint_arg_usages = true,
        hl_priority = 10000,
        excluded_argnames = {
            declarations = {},
            usages = {
                python = { "self", "cls" },
                lua = { "self" },
            },
        },
        performance = {
            parse_delay = 1,
            slow_parse_delay = 50,
            max_iterations = 400,
            max_concurrent_partial_parses = 30,
            debounce = {
                partial_parse = 3,
                partial_insert_mode = 100,
                total_parse = 700,
                slow_parse = 5000,
            },
        },
    })
end

return config
