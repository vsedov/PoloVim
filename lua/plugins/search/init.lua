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
local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

local plugins = {
    "telescope-live-grep-args.nvim",
    "telescope-frecency.nvim",
    "telescope-file-browser.nvim",
    "telescope-bookmarks.nvim",
    "telescope-sg",
}
for _, v in ipairs(plugins) do
    vim.cmd("packadd " .. v)
end
-- require("telescope").setup({
--     extensions = {
--         conda = { anaconda_path = "/home/viv/.conda/" },
--         bookmarks = {
--             selected_browser = "firefox",
--             url_open_command = "open",
--             profile_name = "default-nightly-1",
--             url_open_plugin = nil,
--             full_path = true,
--             buku_include_tags = false,
--             debug = false,
--         },
--     },
-- })
telescope.load_extension("zf-native")
telescope.load_extension("file_browser")

telescope.setup({
    extensions = {
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
                i = {
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    -- freeze the current list and start a fuzzy search in the frozen list
                },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
        },
    },
})

telescope.load_extension("live_grep_args")
