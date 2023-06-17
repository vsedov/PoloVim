-- local api = vim.api
local r, api, fn = vim.regex, vim.api, vim.fn
local strwidth = api.nvim_strwidth

local config = {}

function config.h_line()
    require("modules.ui.heirline")
end

function config.murmur()
    require("murmur").setup({
        max_len = 80,
        min_len = 3, -- this is recommended since I prefer no cursorword highlighting on `if`.
        exclude_filetypes = {},
        callbacks = {
            function()
                vim.cmd("doautocmd InsertEnter")
                vim.w.diag_shown = false
            end,
        },
    })

    local FOO = "murmur"
    vim.api.nvim_create_augroup(FOO, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = FOO,
        pattern = "*",
        callback = function()
            if vim.w.diag_shown then
                return
            end
            if vim.w.cursor_word ~= "" then
                vim.diagnostic.open_float()
                vim.w.diag_shown = true
            end
        end,
    })
end

function config.notify()
    lambda.highlight.plugin("notify", {
        { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
        { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
        { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
        { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
        { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
        { NotifyERRORBody = { link = "NormalFloat" } },
        { NotifyWARNBody = { link = "NormalFloat" } },
        { NotifyINFOBody = { link = "NormalFloat" } },
        { NotifyDEBUGBody = { link = "NormalFloat" } },
        { NotifyTRACEBody = { link = "NormalFloat" } },
    })

    local notify = require("notify")
    notify.setup({
        timeout = 5000,
        stages = "fade_in_slide_out",
        top_down = false,
        -- background_colour = "#000000",                                                                          ▕

        max_width = function()
            return math.floor(vim.o.columns * 0.6)
        end,
        max_height = function()
            return math.floor(vim.o.lines * 0.8)
        end,
        on_open = function(win)
            if not api.nvim_win_is_valid(win) then
                return
            end
            vim.api.nvim_win_set_config(win, { border = lambda.style.border.type_0 })
        end,
        render = function(...)
            local notification = select(2, ...)
            local style = lambda.falsy(notification.title[1]) and "minimal" or "default"
            require("notify.render")[style](...)
        end,
    })
    vim.notify = notify

    vim.keymap.set("n", "<leader>nd", function()
        notify.dismiss({ silent = true, pending = true })
    end, {
        desc = "dismiss notifications",
    })
    require("telescope").load_extension("notify")
end

function config.neo_tree()
    local highlights = lambda.highlight
    local symbols = require("lspkind").symbol_map
    local lsp_kinds = lambda.style.lsp.highlights
    local icons = lambda.style.icons
    vim.g.neo_tree_remove_legacy_commands = 1
    require("neo-tree").setup({
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "diagnostics",
            "document_symbols",
        },
        source_selector = {
            winbar = true,
            separator_active = " ",
        },
        open_files_do_not_replace_types = {
            "terminal",
            "Trouble",
            "qf",
            "Outline",
            "Vista",
            "edgy",
        },
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "solid", -- "double", "none", "rounded", "shadow", "single" or "solid
        enable_git_status = true,
        enable_diagnostics = true,
        git_status_async = true,
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function()
                    highlights.set("Cursor", { blend = 100 })
                end,
            },
            {
                event = "neo_tree_buffer_leave",
                handler = function()
                    highlights.set("Cursor", { blend = 0 })
                end,
            },
            {
                event = "neo_tree_window_after_close",
                handler = function()
                    highlights.set("Cursor", { blend = 0 })
                end,
            },
        },
        use_popups_for_input = false,

        default_component_configs = {
            icon = {
                folder_empty = icons.documents.open_folder,
            },
            name = {
                highlight_opened_files = true,
            },
            document_symbols = {
                follow_cursor = true,
                kinds = vim.iter(symbols):fold({}, function(acc, k, v)
                    acc[k] = { icon = v, hl = lsp_kinds[k] }
                    return acc
                end),
            },
            modified = {
                symbol = icons.misc.circle .. " ",
            },
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
        },
        window = {
            position = "left",
            width = 35,
            mappings = {
                ["<space>"] = "toggle_node",
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["t"] = "open_tabnew",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                ["a"] = "add",
                ["A"] = "add_directory",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy", -- takes text input for destination
                ["m"] = "move", -- takes text input for destination
                ["q"] = "close_window",
                ["R"] = "refresh",
            },
        },
        nesting_rules = {},
        filesystem = {
            filtered_items = {
                visible = false, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    "node_modules",
                },
                hide_by_pattern = { -- uses glob style patterns
                    "*.meta",
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    ".gitignored",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    ".DS_Store",
                    "thumbs.db",
                },
            },
            follow_current_file = true, -- This will find and focus the file in the active buffer every
            group_empty_dirs = true, -- when true, empty folders will be grouped together
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        }, -- instead of relying on nvim autocmd events.
        buffers = {
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = "buffer_delete",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                },
            },
        },
        git_status = {
            window = {
                position = "float",
                mappings = {
                    ["A"] = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["ga"] = "git_add_file",
                    ["gr"] = "git_revert_file",
                    ["gc"] = "git_commit",
                    ["gp"] = "git_push",
                    ["gg"] = "git_commit_and_push",
                },
            },
        },
    })
end

function config.scrollbar()
    require("scrollbar.handlers.search").setup()
    require("scrollbar").setup({
        show = true,
        set_highlights = true,
        handle = {
            color = "#777777",
        },
        marks = {
            Search = { color = "#ff9e64" },
            Error = { color = "#db4b4b" },
            Warn = { color = "#e0af68" },
            Info = { color = "#0db9d7" },
            Hint = { color = "#1abc9c" },
            Misc = { color = "#9d7cd8" },
            GitAdd = {
                color = "#9ed072",
                text = "+",
            },
            GitDelete = {
                color = "#fc5d7c",
                text = "-",
            },
            GitChange = {
                color = "#76cce0",
                text = "*",
            },
        },
        handlers = {
            diagnostic = true,
            search = true,
            gitsigns = false,
        },
    })
end

function config.ufo()
    local ft_map = { rust = "lsp" }
    require("ufo").setup({
        open_fold_hl_timeout = 0,
        preview = { win_config = { winhighlight = "Normal:Normal,FloatBorder:Normal" } },
        enable_get_fold_virt_text = true,
        close_fold_kinds = { "imports", "comment" },
        provider_selector = function(_, ft)
            return ft_map[ft] or { "treesitter", "indent" }
        end,
        fold_virt_text_handler = function(virt_text, _, end_lnum, width, truncate, ctx)
            local result, cur_width, padding = {}, 0, ""
            local suffix_width = strwidth(ctx.text)
            local target_width = width - suffix_width

            for _, chunk in ipairs(virt_text) do
                local chunk_text = chunk[1]
                local chunk_width = strwidth(chunk_text)
                if target_width > cur_width + chunk_width then
                    table.insert(result, chunk)
                else
                    chunk_text = truncate(chunk_text, target_width - cur_width)
                    local hl_group = chunk[2]
                    table.insert(result, { chunk_text, hl_group })
                    chunk_width = strwidth(chunk_text)
                    if cur_width + chunk_width < target_width then
                        padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
                    end
                    break
                end
                cur_width = cur_width + chunk_width
            end

            if ft_map[vim.bo[ctx.bufnr].ft] == "lsp" then
                table.insert(result, { " ⋯ ", "UfoFoldedEllipsis" })
                return result
            end

            local end_text = ctx.get_fold_virt_text(end_lnum)
            -- reformat the end text to trim excess whitespace from
            -- indentation usually the first item is indentation
            if end_text[1] and end_text[1][1] then
                end_text[1][1] = end_text[1][1]:gsub("[%s\t]+", "")
            end

            vim.list_extend(result, { { " ⋯ ", "UfoFoldedEllipsis" }, unpack(end_text) })
            table.insert(result, { padding, "" })
            return result
        end,
    })
end
function config.fold_focus()
    local foldcus = require("foldcus")
    local NS = { noremap = true, silent = true }

    -- Fold multiline comments longer than or equal to 4 lines
    vim.keymap.set("n", "z;", function()
        foldcus.fold(4)
    end, NS)

    -- Fold multiline comments longer than or equal to the number of lines specified by args
    -- e.g. Foldcus 4
    vim.api.nvim_create_user_command("Foldcus", function(args)
        foldcus.fold(tonumber(args.args))
    end, { nargs = "*" })

    -- Delete folds of multiline comments longer than or equal to 4 lines
    vim.keymap.set("n", "z\\", function()
        foldcus.unfold(4)
    end, NS)

    -- Delete folds of multiline comments longer than or equal to the number of lines specified by args
    -- e.g. Unfoldcus 4
    vim.api.nvim_create_user_command("Unfoldcus", function(args)
        foldcus.unfold(tonumber(args.args))
    end, { nargs = "*" })
end

function config.blankline()
    vim.opt.termguicolors = true
    require("indent_blankline").setup({
        enabled = true,
        -- char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
        show_foldtext = false,
        -- context_char = "┃",
        -- indent_blankline_context_char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
        char = "│", -- ┆ ┊ 
        context_char = "▎",
        char_priority = 12,
        show_current_context = true,
        show_current_context_start = true,
        show_current_context_start_on_current_line = true,
        show_first_indent_level = false,
        filetype_exclude = {
            "OverseerForm",
            "norg",
            "dbout",
            "neo-tree-popup",
            "dap-repl",
            "startify",
            "dashboard",
            "log",
            "fugitive",
            "gitcommit",
            "packer",
            "vimwiki",
            "markdown",
            "json",
            "txt",
            "vista",
            "help",
            "NvimTree",
            "git",
            "TelescopePrompt",
            "undotree",
            "flutterToolsOutline",
            "norg",
            "org",
            "orgagenda",
            "oil_preview", -- for all buffers without a file type
        },
        buftype_exclude = { "terminal", "nofile", "dashboard", "norg" },
        context_patterns = {
            "class",
            "function",
            "method",
            "block",
            "list_literal",
            "selector",
            "^if",
            "^table",
            "if_statement",
            "while",
            "for",
        },
    })
end

function config.transparent()
    require("transparent").setup({
        extra_groups = {
            -- example of akinsho/nvim-bufferline.lua
            "BufferLineTabClose",
            "BufferlineBufferSelected",
            "BufferLineFill",
            "BufferLineBackground",
            "BufferLineSeparator",
            "BufferLineIndicatorSelected",
        },
        -- groups you don't want to clear
    })
    -- [transparent.nvim] Please check the README for detailed information.
    -- - "exclude" has been changed to "exclude_groups".
    -- - "enable" has been removed.
end

function config.tint()
    require("tint").setup({
        tint = -30,
        highlight_ignore_patterns = {
            "WinSeparator",
            "St.*",
            "Comment",
            "Panel.*",
            "Telescope.*",
            "Bqf.*",
        },
        window_ignore_function = function(win_id)
            if vim.wo[win_id].diff or vim.fn.win_gettype(win_id) ~= "" then
                return true
            end
            local buf = vim.api.nvim_win_get_buf(win_id)
            local b = vim.bo[buf]
            local ignore_bt = { "terminal", "prompt", "nofile" }
            local ignore_ft = {
                "neo-tree",
                "packer",
                "diff",
                "toggleterm",
                "Neogit.*",
                "Telescope.*",
                "qf",
            }
            return lambda.any(b.bt, ignore_bt) or lambda.any(b.ft, ignore_ft)
        end,
    })
end

function config.illuminate()
    -- default configuration
    require("illuminate").configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
            [[ "lsp", ]],
            "regex",
            "treesitter",
        },
        -- delay: delay in milliseconds
        delay = 100,
        -- filetype_overrides: filetype specific overrides.
        -- The keys are strings to represent the filetype while the values are tables that
        -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
        filetype_overrides = {},
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {
            "dirvish",
            "fugitive",
            "NvimTree",
            "aerial",
            "alpha",
            "undotree",
            "spectre_panel",
            "dbui",
            "toggleterm",
            "notify",
            "startuptime",
            "packer",
            "mason",
            "help",
            "terminal",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "",
            "neo-tree",
            "neo-tree-popup",
        },
        -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
        filetypes_allowlist = {},
        -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
        modes_denylist = {},
        -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
        modes_allowlist = {},
        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_denylist = {},
        -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_allowlist = {},
        -- under_cursor: whether or not to illuminate under the cursor
        under_cursor = true,
    })
end

return config
