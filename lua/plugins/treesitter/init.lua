local rainbow_delimiters = require("rainbow-delimiters")


vim.g.rainbow_delimiters = {

    strategy = {
        [""] = rainbow_delimiters.strategy["global"],
    },
    query = {
        [""] = "rainbow-delimiters",
    },
}

require("modules.treesitter.treesitter").treesitter()

require("modules.treesitter.treesitter").endwise()

require("modules.treesitter.treesitter").treesitter_obj()
require("modules.treesitter.treesitter").textsubjects()

require("modules.treesitter.treesitter").treesitter_ref()

require("nvim-treesitter.configs").setup({
    playground = {
        enable = true,
        disable = {},
        updatetime = 50, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
    },
})

require("hlargs").setup({
    color = "#ef9062",
    highlight = {},
    excluded_filetypes = {
        "oil",
        "trouble",
        "vim",
        "help",
        "dashboard",
        "packer",
        "lazy",
        "config",
        "nofile",
    },
    paint_arg_declarations = true,
    paint_arg_usages = true,
    paint_catch_blocks = {
        declarations = true,
        usages = true,
    },
    extras = {
        named_parameters = true,
    },
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
lambda.command("HlargsEnable", function()
    require("hlargs").enable()
end, {})
lambda.command("HlargsDisable", function()
    require("hlargs").disable()
end, {})
lambda.command("HlargsToggle", function()
    require("hlargs").toggle()
end, {})

vim.g.matchup_matchparen_offscreen = { method = "popup" }

function setkey(k)
    local function out(kk, v)
        vim[k][kk] = v
    end

    return out
end

setglobal = setkey("g")
setglobal("hiPairs_hl_matchPair", {
    term = "underline,bold",
    cterm = "underline,bold",
    ctermfg = "0",
    ctermbg = "180",
    gui = "underline,bold,italic",
    guifg = "#fb94ff",
    guibg = "NONE",
})
require("guess-indent").setup({
    auto_cmd = true, -- Set to false to disable automatic execution
    filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
        "netrw",
        "neo-tree",
        "tutor",
    },
    buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
    },
})
