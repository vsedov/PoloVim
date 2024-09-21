local config = {}

function config.clangd()
    require("plugins.lsp.lsp.providers.c")
end

function config.lsp_sig()
end

function config.hover()
    local diag = require("vim.diagnostic")
    require("hover").setup({
        init = function()
            -- require("hover.providers.lsp")
            -- require("hover").register(LSPWithDiagSource)
            require("hover.providers.lsp")
            require("hover.providers.gh")
            -- require("hover.providers.jira")
            require("hover.providers.man")
            require("hover.providers.dictionary")
        end,
        preview_opts = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
        },
        title = true,
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
    })
end

function config.vista()
    vim.g["vista#renderer#enable_icon"] = 1
    vim.g.vista_disable_statusline = 1

    vim.g.vista_default_executive = "nvim_lsp" -- ctag
    vim.g.vista_echo_cursor_strategy = "floating_win"
    vim.g.vista_vimwiki_executive = "markdown"
    vim.g.vista_executive_for = {
        vimwiki = "markdown",
        pandoc = "markdown",
        markdown = "toc",
        typescript = "nvim_lsp",
        typescriptreact = "nvim_lsp",
        go = "nvim_lsp",
        lua = "nvim_lsp",
    }
end

function config.rcd()
    require("rcd").setup({
        position = "top",
        auto_cmds = true,
    })
end

function config.glance()
    -- Lua configuration
    local glance = require("glance")
    local actions = glance.actions

    glance.setup({
        height = 18, -- Height of the window
        zindex = 45,

        -- By default glance will open preview "embedded" within your active window
        -- when `detached` is enabled, glance will render above all existing windows
        -- and won't be restiricted by the width of your active window
        detached = true,

        preview_win_opts = { -- Configure preview window options
            cursorline = true,
            number = true,
            wrap = true,
        },
        border = {
            enable = false, -- Show window borders. Only horizontal borders allowed
            top_char = "―",
            bottom_char = "―",
        },
        list = {
            position = "right", -- Position of the list window 'left'|'right'
            width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
        },
        theme = { -- This feature might not work properly in nvim-0.7.2
            enable = true, -- Will generate colors for the plugin based on your current colorscheme
            mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        },
        mappings = {
            list = {
                ["j"] = actions.next, -- Bring the cursor to the next item in the list
                ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
                ["<Down>"] = actions.next,
                ["<Up>"] = actions.previous,
                ["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
                ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
                ["<C-u>"] = actions.preview_scroll_win(5),
                ["<C-d>"] = actions.preview_scroll_win(-5),
                ["v"] = actions.jump_vsplit,
                ["s"] = actions.jump_split,
                ["t"] = actions.jump_tab,
                ["<CR>"] = actions.jump,
                ["o"] = actions.jump,
                ["l"] = actions.open_fold,
                ["h"] = actions.close_fold,
                ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
                ["q"] = actions.close,
                ["Q"] = actions.close,
                ["<Esc>"] = actions.close,
                ["<C-q>"] = actions.quickfix,
                -- ['<Esc>'] = false -- disable a mapping
            },
            preview = {
                ["Q"] = actions.close,
                ["<Tab>"] = actions.next_location,
                ["<S-Tab>"] = actions.previous_location,
                ["<leader>l"] = actions.enter_win("list"), -- Focus list window
            },
        },
        hooks = {},
        folds = {
            fold_closed = "",
            fold_open = "",
            folded = true, -- Automatically fold list on startup
        },
        indent_lines = {
            enable = true,
            icon = "│",
        },
        winbar = {
            enable = true, -- Available strating from nvim-0.8+
        },
        use_trouble_qf = true, -- Quickfix action will open trouble.nvim instead of built-in quickfix list window
    })
end

function config.nvimdev()
    vim.g.nvimdev_auto_lint = 0
end

function config.definition_or_reference()
    local make_entry = require("telescope.make_entry")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")

    local function filter_entries(results)
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_line = vim.api.nvim_win_get_cursor(0)[1]

        local function should_include_entry(entry)
            -- if entry is on the same line
            if entry.filename == current_file and entry.lnum == current_line then
                return false
            end

            -- if entry is closing tag - just before it there is a closing tag syntax '</'
            if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == "</" then
                return false
            end

            return true
        end

        return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
    end

    local function handle_references_response(result)
        local locations = vim.lsp.util.locations_to_items(result, "utf-8")
        local filtered_entries = filter_entries(locations)
        pickers
            .new({}, {
                prompt_title = "LSP References",
                finder = finders.new_table({
                    results = filtered_entries,
                    entry_maker = make_entry.gen_from_quickfix(),
                }),
                previewer = require("telescope.config").values.qflist_previewer({}),
                sorter = require("telescope.config").values.generic_sorter({}),
                push_cursor_on_edit = true,
                push_tagstack_on_edit = true,
                initial_mode = "normal",
            })
            :find()
    end

    require("definition-or-references").setup({
        on_references_result = handle_references_response,
    })
end

return config
