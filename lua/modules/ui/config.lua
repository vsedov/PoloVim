local config = {}
packer_plugins = packer_plugins or {} -- supress warning

function config.fidget()
    local relative = "editor"
    require("fidget").setup({
        text = {
            spinner = {
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
            },
            done = "", -- character shown when all tasks are complete
            commenced = " ", -- message shown when task starts
            completed = " ", -- message shown when task completes
        },
        align = {
            bottom = true, -- align fidgets along bottom edge of buffer
            right = true, -- align fidgets along right edge of buffer
        },
        timer = {
            spinner_rate = 100, -- frame rate of spinner animation, in ms
            fidget_decay = 500, -- how long to keep around empty fidget, in ms
            task_decay = 300, -- how long to keep around completed task, in ms
        },
        window = {
            relative = relative, -- where to anchor the window, either `"win"` or `"editor"`
            blend = 100, -- `&winblend` for the window
            zindex = nil, -- the `zindex` value for the window
        },
        fmt = {
            leftpad = true, -- right-justify text in fidget box
            stack_upwards = true, -- list of tasks grows upwards
            max_width = 0, -- maximum width of the fidget box
            -- function to format fidget title
            fidget = function(fidget_name, spinner)
                return string.format("%s %s", spinner, fidget_name)
            end,
            -- function to format each task line
            task = function(task_name, message, percentage)
                return string.format(
                    "%s%s [%s]",
                    message,
                    percentage and string.format(" (%s%%)", percentage) or "",
                    task_name
                )
            end,
        },

        debug = {
            logging = false, -- whether to enable logging, for debugging
            strict = false, -- whether to interpret LSP strictly
        },
    })
end

-- function config.nvim_bufferline_tabby_setup()
--         if lambda.config.tabby_or_bufferline then
--             require("packer").loader("bufferline.nvim")
--         end
-- end

function config.nvim_bufferline()
    if not packer_plugins["nvim-web-devicons"].loaded then
        packer_plugins["nvim-web-devicons"].loaded = true
        vim.cmd([[packadd nvim-web-devicons]])
    end
    local fn = vim.fn
    local function diagnostics_indicator(_, _, diagnostics)
        local symbols = { error = " ", warning = " ", info = " " }
        local result = {}
        for name, count in pairs(diagnostics) do
            if symbols[name] and count > 0 then
                table.insert(result, symbols[name] .. count)
            end
        end
        result = table.concat(result, " ")
        return #result > 0 and result or ""
    end

    local function custom_filter(buf, buf_nums)
        local logs = vim.tbl_filter(function(b)
            return vim.bo[b].filetype == "log"
        end, buf_nums)
        if vim.tbl_isempty(logs) then
            return true
        end
        local tab_num = vim.fn.tabpagenr()
        local last_tab = vim.fn.tabpagenr("$")
        local is_log = vim.bo[buf].filetype == "log"
        if last_tab == 1 then
            return true
        end
        -- only show log buffers in secondary tabs
        return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
    end

    local function sort_by_mtime(a, b)
        local astat = vim.loop.fs_stat(a.path)
        local bstat = vim.loop.fs_stat(b.path)
        local mod_a = astat and astat.mtime.sec or 0
        local mod_b = bstat and bstat.mtime.sec or 0
        return mod_a > mod_b
    end

    local groups = require("bufferline.groups")

    require("bufferline").setup({
        highlights = {
            info = { gui = "undercurl" },
            info_selected = { gui = "undercurl" },
            info_visible = { gui = "undercurl" },
            warning = { gui = "undercurl" },
            warning_selected = { gui = "undercurl" },
            warning_visible = { gui = "undercurl" },
            error = { gui = "undercurl" },
            error_selected = { gui = "undercurl" },
            error_visible = { gui = "undercurl" },
        },
        options = {
            view = "multiwindow",
            numbers = "none", -- function(opts) return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal)) end,
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            -- mappings = true,
            max_name_length = 14,
            max_prefix_length = 10,
            tab_size = 16,
            mode = "buffers", -- tabs
            sort_by = sort_by_mtime,
            show_close_icon = false,
            show_buffer_icons = true,
            show_buffer_close_icons = false,
            show_tab_indicators = true,
            enforce_regular_tabs = true,
            always_show_bufferline = false,
            -- 'extension' | 'directory' |
            ---based on https://github.com/kovidgoyal/kitty/issues/957
            diagnostics = "nvim_lsp",
            diagnostics_indicator = diagnostics_indicator,
            diagnostics_update_in_insert = false,
            custom_filter = custom_filter,
            separator_style = "thin", -- "thin",
            -- 'extension' | 'directory' |
            offsets = {
                {
                    filetype = "undotree",
                    text = "Undotree",
                    highlight = "PanelHeading",
                },
                {
                    filetype = "NvimTree",
                    text = "Explorer",
                    highlight = "PanelHeading",
                },
                {
                    filetype = "neo-tree",
                    text = "Explorer",
                    highlight = "PanelHeading",
                },
                {
                    filetype = "DiffviewFiles",
                    text = "Diff View",
                    highlight = "PanelHeading",
                },
                {
                    filetype = "flutterToolsOutline",
                    text = "Flutter Outline",
                    highlight = "PanelHeading",
                },
                {
                    filetype = "packer",
                    text = "Packer",
                    highlight = "PanelHeading",
                },
            },
            groups = {
                options = {
                    toggle_hidden_on_enter = true,
                },
                items = {
                    groups.builtin.ungrouped,
                    {
                        highlight = { guisp = "#808080", gui = "underline" },
                        name = "tests",
                        icon = "",
                        matcher = function(buf)
                            return buf.filename:match("_spec") or buf.filename:match("test")
                        end,
                    },
                    {
                        name = "view models",
                        highlight = { guisp = "#54546D", gui = "underline" },
                        matcher = function(buf)
                            return buf.filename:match("view_model%.dart")
                        end,
                    },
                    {
                        name = "screens",
                        highlight = { guisp = "#D27E99", gui = "underline" },
                        matcher = function(buf)
                            return buf.path:match("screen")
                        end,
                    },
                    {
                        highlight = { guisp = "#938AA9", gui = "underline" },
                        name = "docs",
                        matcher = function(buf)
                            for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                                if ext == fn.fnamemodify(buf.path, ":e") then
                                    return true
                                end
                            end
                        end,
                    },
                    {
                        name = "plugins",
                        highlight = { guisp = "#54546D", gui = "underline" },

                        matcher = function(buf)
                            return buf.filename:match("plugins")
                        end,
                    },
                    {
                        name = "config",
                        highlight = { guisp = "#54546D", gui = "underline" },

                        matcher = function(buf)
                            return buf.filename:match("config")
                        end,
                    },
                },
            },
        },
    })
end

function config.tabby()
    -- use default as that is good enough.
    require("tabby").setup()
end

function config.notify()
    if #vim.api.nvim_list_uis() == 0 then
        -- no need to configure notifications in headless
        return
    end
    local notify = require("notify")
    notify.setup({
        timeout = 3000,
        stages = "fade_in_slide_out",
        max_width = function()
            return math.floor(vim.o.columns * 0.8)
        end,
        max_height = function()
            return math.floor(vim.o.lines * 0.8)
        end,
        on_open = function(win)
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_config(win, { border = "single" })
            end
        end,
        render = function(bufnr, notif, highlights, config)
            local style = notif.title[1] == "" and "minimal" or "default"
            require("notify.render")[style](bufnr, notif, highlights, config)
        end,
    })
    vim.notify = notify
    vim.keymap.set("n", "|+", ":lua require('notify').dismiss()<CR>", { noremap = true, silent = true })
    require("telescope").load_extension("notify")
end

function config.neo_tree()
    if not packer_plugins["nui.nvim"].loaded then
        vim.cmd([[packadd nui.nvim ]])
    end
    if not packer_plugins["nvim-window-picker"].loaded then
        vim.cmd([[packadd nvim-window-picker ]])
    end

    vim.g.neo_tree_remove_legacy_commands = 1

    require("neo-tree").setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "solid", -- "double", "none", "rounded", "shadow", "single" or "solid
        enable_git_status = true,
        enable_diagnostics = true,
        event_handlers = {
            {
                event = "vim_buffer_enter",
                handler = function(_)
                    if vim.bo.filetype == "neo-tree" then
                        vim.wo.signcolumn = "auto"
                    end
                    vim.cmd("highlight! Cursor blend=100")
                end,
            },
        },
        use_popups_for_input = false,
        default_component_configs = {
            indent = {
                indent_size = 2,
                padding = 1, -- extra padding on left hand side
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "ﰊ",
                default = "*",
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted = "✖", -- this can only be used in the git_status source
                    renamed = "", -- this can only be used in the git_status source
                    -- Status type
                    untracked = "",
                    ignored = "",
                    unstaged = "",
                    staged = "",
                    conflict = "",
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
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                    --"node_modules"
                },
                never_show = { -- remains hidden even if visible is toggled to true
                    --".DS_Store",
                    --"thumbs.db"
                },
            },
            follow_current_file = true, -- This will find and focus the file in the active buffer every
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            use_libuv_file_watcher = true,
            window = {
                mappings = {
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["H"] = "toggle_hidden",
                    ["/"] = "fuzzy_finder",
                    ["f"] = "filter_on_submit",
                    ["<c-x>"] = "clear_filter",
                },
            },
        },
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

function config.satellite()
    require("satellite").setup({
        handlers = {
            gitsigns = {
                enable = false,
            },
            marks = {
                enable = true,
            },
        },
        excluded_filetypes = {
            "packer",
            "neo-tree",
            "norg",
            "neo-tree-popup",
            "dapui_scopes",
            "dapui_stacks",
        },
    })
end

function config.pretty_fold()
    require("pretty-fold").setup({
        keep_indentation = true,
        fill_char = "•",
        sections = {
            left = {
                "content",
            },
            right = {
                " ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ",
                function(fold_config)
                    return fold_config.fill_char:rep(3)
                end,
            },
        },
        -- List of patterns that will be removed from content foldtext section.
        stop_words = {
            "@brief%s*", -- (for cpp) Remove '@brief' and all spaces after.
        },
    })
end

function config.blankline()
    vim.opt.termguicolors = true
    vim.opt.list = true

    -- test this for now, not sure if i like this or not .
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")
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
        show_current_context_start_on_current_line = false,
        show_first_indent_level = true,
        filetype_exclude = {
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
            "", -- for all buffers without a file type
        },
        buftype_exclude = { "terminal", "nofile", "dashboard" },
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
    -- useing treesitter instead of char highlight
    -- vim.g.indent_blankline_char_highlight_list =
    -- {"WarningMsg", "Identifier", "Delimiter", "Type", "String", "Boolean"}
end

function config.indentguides()
    require("indent_guides").setup({
        -- put your options in here
        indent_soft_pattern = "\\s",
    })
end

function config.buffers_close()
    require("close_buffers").setup({
        preserve_window_layout = { "this" },
        next_buffer_cmd = function(windows)
            require("bufferline").cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()

            for _, window in ipairs(windows) do
                vim.api.nvim_win_set_buf(window, bufnr)
            end
        end,
    })
end

function config.modes()
    require("modes").setup({
        colors = {
            copy = "#f5c359",
            delete = "#c75c6a",
            insert = "#78ccc5",
            visual = "#9745be",
        },

        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { "NvimTree", "TelescopePrompt", "NeoTree" },
        plugins = {
            presets = {
                operators = false,
            },
        },
    })
end

function config.transparent()
    require("transparent").setup({
        enable = false,
        -- additional groups that should be clear
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
        exclude = {},
    })
end

function config.dim()
    require("neodim").setup({
        alpha = 0.5,
        blend_color = "#000000",
        update_in_insert = {
            enable = true,
            delay = 100,
        },
        hide = {
            virtual_text = true,
            signs = true,
            underline = true,
        },
    })
end

function config.colourutils()
    require("colortils").setup()
end

function config.clock_setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            local f = vim.fn
            if lambda.config.use_clock and f.getcwd():match(f.stdpath("config")) then
                require("packer").loader("clock.nvim")
            end
        end,
    })
end

function config.clock()
    local c = require("clock")
    local f = vim.fn

    c.setup({
        border = {
            "🭽",
            "▔",
            "🭾",
            "▕",
            "🭿",
            "▁",
            "🭼",
            "▏",
        },
        row = vim.o.lines - 5,
    })
    if f.getcwd():match(f.stdpath("config")) then
        c.Clock:new():count_up({
            duration = { minutes = 30 },
            threshold = { late = "00:15" }, -- at 15mins the clock will become red
        })
    end
end

function config.dashboard_setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            local f = vim.fn
            if lambda.config.use_dashboard then
                require("packer").loader("dashboard")
            end
        end,
        once = true,
    })
end

function config.dashboard_config()
    vim.g.indentLine_fileTypeExclude = { "dashboard" }
    local home = os.getenv("HOME")
    local db = require("dashboard")
    db.custom_header = {
        "┍━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑",
        "│ ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷ │",
        "│ ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇ │",
        "│ ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽ │",
        "│ ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕ │",
        "│ ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕ │",
        "│ ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕ │",
        "│ ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄ │",
        "│ ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕ │",
        "│ ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿ │",
        "│ ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ │",
        "│ ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟ │",
        "│ ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠ │",
        "│ ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙ │",
        "│ ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣ │",
        "┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙",
        "                                  ",
        "                                  ",
        "                                  ",
    }
    db.custom_footer = {
        "	",
        "▷ nya-nvim ◁",
    }
    db.hide_statusline = true -- boolean default is true.it will hide statusline in dashboard buffer and auto open in other buffer
    db.hide_tabline = true -- boolean default is true.it will hide tabline in dashboard buffer and auto open in other buffer
    db.custom_center = {
        {
            icon = "  ",
            desc = "Recently latest session                  ",
            shortcut = "SPC s l",
            action = "SessionLoad",
        },
        {
            icon = "  ",
            desc = "Workspaces                              ",
            shortcut = "SPC s l",
            action = "Telescope workspaces",
        },
        {
            icon = "  ",
            desc = "Recently opened files                   ",
            action = "DashboardFindHistory",
            shortcut = "SPC f h",
        },
        {
            icon = "  ",
            desc = "Find  File                              ",
            action = "Telescope find_files find_command=rg,--hidden,--files",
            shortcut = "SPC f f",
        },
        {
            icon = "  ",
            desc = "File Browser                            ",
            action = "Telescope file_browser",
            shortcut = "SPC f b",
        },
        {
            icon = "  ",
            desc = "Find  word                              ",
            action = "Telescope live_grep",
            shortcut = "SPC f w",
        },
        {
            icon = "  ",
            desc = "Open Personal dotfiles                  ",
            action = "Telescope dotfiles",
            shortcut = "SPC f d",
        },
    }
    -- 	{
    -- 	a = { description = { '  Find File                        ' }, command = 'Telescope find_files' },
    -- 	b = { description = { '  Recents                          ' }, command = 'Telescope oldfiles' },
    -- 	c = { description = { '  Find Word                        ' }, command = 'Telescope live_grep' },
    -- 	d = { description = { 'ﱐ  New File                         ' }, command = 'DashboardNewFile' },
    -- 	e = { description = { '  Bookmarks                        ' }, command = 'Telescope marks' },
    -- 	f = { description = { '  Open Help Doc                    ' }, command = 'view ~/.config/nvim/doc/helpdoc.md' },
    -- }
    --
end

vim.api.nvim_exec(
    [[
    set nocursorcolumn
    set nocursorline
    augroup vimrc_todo
    au!
    au Syntax *.go,*.c,*.rs,*.js,*.tsx,*.cpp,*.html syn match MyTodo /\v<(FIXME|Fixme|NOTE|Note|TODO|ToDo|OPTIMIZE|XXX):/ containedin=.*Comment,vimCommentTitle
    augroup END
    hi def link MyTodo Todo
  ]],
    true
)
return config
