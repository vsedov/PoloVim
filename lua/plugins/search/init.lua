require("modules.search.telescope.telescope").setup()
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
