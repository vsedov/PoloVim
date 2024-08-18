vim.opt.wrap = false -- Recommended
vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
vim.g.neominimap = {
    auto_enable = true,
}

-- local conf = require("plugins.ui.config")
-- local highlight, foo, falsy, augroup = lambda.highlight, lambda.style, lambda.falsy, lambda.augroup
-- local border, rect = foo.border.type_0, foo.border.type_0
-- local icons = lambda.style.icons
-- conf.illuminate()
local symbols = require("lspkind").symbol_map
local lsp_kinds = lambda.style.lsp.highlights
local icons = lambda.style.icons

require("heirline").setup({
    --winbar = require("modules.ui.heirline.winbar"),
    statusline = require("plugins.ui.heirline.statusline"),
    statuscolumn = require("plugins.ui.heirline.statuscolumn"),
    opts = {
        disable_winbar_cb = function(args)
            local conditions = require("heirline.conditions")

            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
                filetype = { "alpha", "codecompanion", "oil", "lspinfo", "toggleterm" },
            }, args.buf)
        end,
    },
})

rocks.safe_packadd({ "neo-tree-jj.nvim", "nvim-web-devicons", "nui.nvim" })
rocks.packadd_with_after_dirs({
    "nvim-window-picker",
})
local opts = {
    sources = { "filesystem", "git_status", "document_symbols" },
    source_selector = {
        winbar = true,
        separator_active = "",
        sources = {
            { source = "filesystem" },
            { source = "git_status" },
            { source = "document_symbols" },
        },
    },
    use_popups_for_input = true,
    enable_git_status = true,
    enable_normal_mode_for_inputs = true,
    git_status_async = true,
    nesting_rules = {
        ["dart"] = { "freezed.dart", "g.dart" },
        ["go"] = {
            pattern = "(.*)%.go$",
            files = { "%1_test.go" },
        },
        ["docker"] = {
            pattern = "^dockerfile$",
            ignore_case = true,
            files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
        },
    },
    filesystem = {
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        group_empty_dirs = false,
        follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
        },
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".DS_Store" },
        },
        window = {
            mappings = {
                ["/"] = "noop",
                ["g/"] = "fuzzy_finder",
            },
        },
    },
    default_component_configs = {
        icon = { folder_empty = icons.documents.open_folder },
        name = { highlight_opened_files = true },
        document_symbols = {
            follow_cursor = false,
            kinds = vim.iter(symbols):fold({}, function(acc, k, v)
                acc[k] = { icon = v, hl = lsp_kinds[k] }
                return acc
            end),
        },
        modified = { symbol = icons.misc.circle .. " " },
        git_status = {
            symbols = {
                added = icons.git.add,
                deleted = icons.git.remove,
                modified = icons.git.mod,
                renamed = icons.git.rename,
                untracked = icons.git.untracked,
                ignored = icons.git.ignored,
                unstaged = icons.git.unstaged,
                staged = icons.git.staged,
                conflict = icons.git.conflict,
            },
        },
        file_size = {
            required_width = 50,
        },
    },
    window = {
        mappings = {
            ["o"] = "toggle_node",
            ["<CR>"] = "open_with_window_picker",
            ["<c-w>"] = "split_with_window_picker",
            ["<c-v>"] = "vsplit_with_window_picker",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = false } },
        },
    },
}

require("neo-tree").setup(opts)
require("window-picker").setup({
    hint = "floating-big-letter",
    autoselect_one = true,
    include_current = true,
    filter_rules = {
        bo = {
            filetype = { "neo-tree-popup", "quickfix", "edgy", "neo-tree" },
            buftype = { "terminal", "quickfix", "nofile" },
        },
    },
})

vim.keymap.set("n", "<leader>e", ":Neotree<cr>", { silent = true })
