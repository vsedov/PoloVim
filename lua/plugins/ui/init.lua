vim.opt.wrap = false -- Recommended
vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
local AnnotationMode = {
    Sign = "sign", -- Show braille signs in the sign column
    Icon = "icon", -- Show icons in the sign column
    Line = "line", -- Highlight the background of the line on the minimap
}

vim.g.neominimap = {
    -- Enable the plugin by default
    auto_enable = true, ---@type boolean

    -- Log level
    log_level = vim.log.levels.OFF, ---@type Neominimap.Log.Levels

    -- Notification level
    notification_level = vim.log.levels.INFO, ---@type Neominimap.Log.Levels

    -- Path to the log file
    log_path = vim.fn.stdpath("data") .. "/neominimap.log", ---@type string

    -- Minimap will not be created for buffers of these types
    ---@type string[]
    exclude_filetypes = {
        "help",
        "AvanteInput",
    },

    -- Minimap will not be created for buffers of these types
    ---@type string[]
    exclude_buftypes = {
        "nofile",
        "nowrite",
        "quickfix",
        "terminal",
        "prompt",
    },

    -- When false is returned, the minimap will not be created for this buffer
    ---@type fun(bufnr: integer): boolean
    buf_filter = function()
        return true
    end,

    -- When false is returned, the minimap will not be created for this window
    ---@type fun(winid: integer): boolean
    win_filter = function()
        return true
    end,

    -- How many columns a dot should span
    x_multiplier = 4, ---@type integer

    -- How many rows a dot should span
    y_multiplier = 1, ---@type integer

    ---@alias Neominimap.Config.LayoutType "split" | "float"

    --- Either `split` or `float`
    --- When layout is set to `float`,
    --- the minimap will be created in floating windows attached to all suitable windows
    --- When layout is set to `split`,
    --- the minimap will be created in one split window
    layout = "float", ---@type Neominimap.Config.LayoutType

    --- Used when `layout` is set to `split`
    split = {
        minimap_width = 20, ---@type integer

        -- Always fix the width of the split window
        fix_width = false, ---@type boolean

        ---@alias Neominimap.Config.SplitDirection "left" | "right"
        direction = "right", ---@type Neominimap.Config.SplitDirection

        ---Automatically close the split window when it is the last window
        close_if_last_window = false, ---@type boolean
    },

    --- Used when `layout` is set to `float`
    float = {
        minimap_width = 20, ---@type integer

        --- If set to nil, there is no maximum height restriction
        --- @type integer
        max_minimap_height = nil,

        margin = {
            right = 0, ---@type integer
            top = 0, ---@type integer
            bottom = 0, ---@type integer
        },
        z_index = 1, ---@type integer

        --- Border style of the floating window.
        --- Accepts all usual border style options (e.g., "single", "double")
        --- @type string | string[] | [string, string][]
        window_border = "single",
    },

    -- For performance issue, when text changed,
    -- minimap is refreshed after a certain delay
    -- Set the delay in milliseconds
    delay = 200, ---@type integer

    -- Sync the cursor position with the minimap
    sync_cursor = true, ---@type boolean

    click = {
        -- Enable mouse click on minimap
        enabled = true, ---@type boolean
        -- Automatically switch focus to minimap when clicked
        auto_switch_focus = true, ---@type boolean
    },

    diagnostic = {
        enabled = true, ---@type boolean
        severity = vim.diagnostic.severity.WARN, ---@type vim.diagnostic.SeverityInt
        mode = "line", ---@type Neominimap.Handler.MarkMode
        priority = {
            ERROR = 100, ---@type integer
            WARN = 90, ---@type integer
            INFO = 80, ---@type integer
            HINT = 70, ---@type integer
        },
    },

    git = {
        enabled = true, ---@type boolean
        mode = "sign", ---@type Neominimap.Handler.MarkMode
        priority = 6, ---@type integer
    },

    search = {
        enabled = false, ---@type boolean
        mode = "line", ---@type Neominimap.Handler.MarkMode
        priority = 20, ---@type integer
    },

    mark = {
        enabled = false, ---@type boolean
        mode = "icon", ---@type Neominimap.Handler.Annotation
        priority = 10, ---@type integer
        key = "m", ---@type string
        show_builtins = false, ---@type boolean -- shows the builtin marks like [ ] < >
    },

    treesitter = {
        enabled = true, ---@type boolean
        priority = 200, ---@type integer
    },

    fold = {
        -- Considering fold when rendering minimap
        enabled = true, ---@type boolean
    },
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
