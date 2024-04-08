local enable = true
local lines = vim.fn.line("$")
local treesitter = function()
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
    parser_configs.markdown.filetype_to_parsername = "octo"

    require("nvim-treesitter.configs").setup({
        autopairs = { enable = false },
        matchup = {
            enable = lambda.config.treesitter.use_matchup,
            disable = { "latex", "tex", "bib" },
        },
        highlight = {
            enable = true, -- false will disable the whole extension
            additional_vim_regex_highlighting = lambda.config.treesitter.use_extra_highlight,
            disable = { "latex", "tex", "bib" },
        },
        incremental_selection = {
            enable = false,
            -- disable = {"elm"},
            keymaps = {
                -- mappings for incremental selection (visual mappings)
                init_selection = "gnn", -- maps in normal mode to init the node/scope selection
                scope_incremental = "gnN", -- increment to the upper scope (as defined in locals.scm)
                node_incremental = "<TAB>", -- increment to the upper named parent
                node_decremental = "<S-TAB>", -- decrement to the previous node
            },
        },
    })
end

local treesitter_obj = function()
    -- lprint("loading treesitter textobj")
    if lines > 30000 then -- skip some settings for large file
        print("skip treesitter obj")
        return
    end

    require("nvim-treesitter.configs").setup({
        indent = { enable = true, disable = { "python" } },
        textobjects = {
            -- syntax-aware textobjects
            enable = enable,
            disable = { "elm" },
            lsp_interop = {
                enable = enable,
                border = "single",
                peek_definition_code = {
                    ["gl"] = "@function.outer",
                    ["gK"] = "@class.outer",
                },
            },
            move = {
                enable = enable,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["gnf"] = "@function.outer",
                    ["gnif"] = "@function.inner",
                    ["gnp"] = "@parameter.inner",
                    ["gnc"] = "@call.outer",
                    ["gnic"] = "@call.inner",
                },
                goto_next_end = {
                    ["gnF"] = "@function.outer",
                    ["gniF"] = "@function.inner",
                    ["gnP"] = "@parameter.inner",
                    ["gnC"] = "@call.outer",
                    ["gniC"] = "@call.inner",
                },
                goto_previous_start = {
                    ["gpf"] = "@function.outer",
                    ["gpif"] = "@function.inner",
                    ["gpp"] = "@parameter.inner",
                    ["gpc"] = "@call.outer",
                    ["gpic"] = "@call.inner",
                },
                goto_previous_end = {
                    ["gpF"] = "@function.outer",
                    ["gpiF"] = "@function.inner",
                    ["gpP"] = "@parameter.inner",
                    ["gpC"] = "@call.outer",
                    ["gpiC"] = "@call.inner",
                },
            },
            select = {
                enable = true,
                include_surrounding_whitespace = true,
                keymaps = {
                    ["af"] = { query = "@function.outer", desc = "ts: all function" },
                    ["if"] = { query = "@function.inner", desc = "ts: inner function" },
                    ["ac"] = { query = "@class.outer", desc = "ts: all class" },
                    ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
                    ["aC"] = { query = "@conditional.outer", desc = "ts: all conditional" },
                    ["iC"] = { query = "@conditional.inner", desc = "ts: inner conditional" },
                    -- FIXME: this is unusable
                    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
                    -- ['ax'] = '@comment.outer',
                },
            },
            swap = {
                enable = enable,
                swap_next = { ["[W"] = "@parameter.inner" },
                swap_previous = { ["]W"] = "@parameter.inner" },
            },
        },
        -- ensure_installed = "maintained"
        ensure_installed = {
            "dap_repl",
            "norg",
            "vim",
            "go",
            "css",
            "html",
            "javascript",
            "typescript",
            "json",
            "c",
            "java",
            "toml",
            "diff",
            "tsx",
            "lua",
            "cpp",
            "python",
            "rust",
        },
    })

    -- print("loading ts")
    vim.cmd([[syntax on]])
end

local treesitter_ref = function()
    -- lprint("loading treesitter refactor")

    if vim.fn.line("$") > 10000 then -- skip for large file
        -- vim.cmd[[syntax on]]
        print("skip treesitter")
        enable = false
    end

    require("nvim-treesitter.configs").setup({
        refactor = {
            highlight_definitions = { enable = enable },
            highlight_current_scope = { enable = false },
            smart_rename = {
                enable = false,
            },
            navigation = {
                enable = true, -- enabled navigation might conflict with mapping
                keymaps = {
                    goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
                    list_definitions = "gnD", -- mapping to list all definitions in current file
                    list_definitions_toc = "gO", -- gT navigator
                    goto_next_usage = "<c->>",
                    goto_previous_usage = "<c-<>",
                },
            },
        },
    })
end

local function endwise()
    require("nvim-treesitter.configs").setup({
        endwise = {
            enable = true,
        },
    })
end

local function textsubjects()
    require("nvim-treesitter.configs").setup({
        textsubjects = {
            enable = true,
            prev_selection = "\\\\", -- (Optional) keymap to select the previous selection
            keymaps = {
                [";w"] = "textsubjects-smart",
                [";W"] = "textsubjects-container-outer",
                ["i;"] = {
                    "textsubjects-container-inner",
                    desc = "Select inside containers (classes, functions, etc.)",
                },
                [";i"] = { -- Select inside the current container
                    "textsubjects-container-outer",
                    desc = "Select inside the current container",
                },
            },
        },
    })
end

-- treesitter()

return {
    endwise = endwise,
    treesitter = treesitter,
    treesitter_obj = treesitter_obj,
    treesitter_ref = treesitter_ref,
    textsubjects = textsubjects,
    -- pyfold = pyfoldo,
}
