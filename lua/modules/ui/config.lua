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
            enforce_regular_tabs = false,
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
                        highlight = { guisp = "#D27E99", gui = "underline" },
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

function config.notify()
    if #vim.api.nvim_list_uis() == 0 then
        -- no need to configure notifications in headless
        return
    end
    local notify = require("notify")
    local default = {
        -- Animation style (see below for details)
        stages = "fade_in_slide_out", -- "slide",

        -- Function called when a new window is opened, use for changing win settings/config
        on_open = nil,

        -- Function called when a window is closed
        on_close = nil,

        -- Render function for notifications. See notify-render()
        render = "default",

        -- Default timeout for notifications
        timeout = 5000,

        -- For stages that change opacity this is treated as the highlight behind the window
        -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
        background_colour = function()
            local group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#")
            if group_bg == "" or group_bg == "none" then
                group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Float")), "bg#")
                if group_bg == "" or group_bg == "none" then
                    return "#000000"
                end
            end
            return group_bg
        end,

        -- Minimum width for notification windows
        minimum_width = 50,

        -- Icons for the different levels
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },
    }

    notify.setup(default)

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
                event = "neo_tree_buffer_enter",
                handler = function()
                    vim.wo.signcolumn = "no"
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
    require("satellite").setup()
end

function config.scrollbar()
    if vim.wo.diff then
        return
    end
    local w = vim.api.nvim_call_function("winwidth", { 0 })
    if w < 70 then
        return
    end
    require("scrollbar").setup({
        handle = {
            color = "#16161D",
        },
        marks = {
            Search = { color = "#FFA066" },
            Error = { color = "#E82424" },
            Warn = { color = "#FF9E3B" },
            Info = { color = "#6A9589" },
            Hint = { color = "#658594" },
            Misc = { color = "#938AA9" },
        },
        excluded_filetypes = {
            "",
            "prompt",
            "TelescopePrompt",
        },
        autocmd = {
            render = {
                "BufWinEnter",
                "TabEnter",
                "TermEnter",
                "WinEnter",
                "CmdwinLeave",
                "TextChanged",
                "VimResized",
                "WinScrolled",
            },
        },
        handlers = {
            diagnostic = true,
            search = false,
        },
    })

    -- vim.cmd([[
    --     augroup scrollbar_search_hide
    --       autocmd!
    --       autocmd CmdlineLeave : lua require('scrollbar').search_handler.hide()
    --     augroup END
    -- ]])

    -- vimcmd("augroup " .. "ScrollbarInit")
    -- vimcmd("autocmd!")
    -- vimcmd("autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()")
    -- vimcmd("autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()")
    -- vimcmd("autocmd WinLeave,FocusLost,BufLeave    * silent! lua require('scrollbar').clear()")
    -- vimcmd("autocmd WinLeave,BufLeave    * silent! DiffviewClose")
    -- vimcmd("augroup end")
    -- vimcmd("highlight link Scrollbar Comment")
    -- vim.g.sb_default_behavior = "never"
    -- vim.g.sb_bar_style = "solid"
end
function config.pretty_fold()
    require("pretty-fold.preview").setup()
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
                function(config)
                    return config.fill_char:rep(3)
                end,
            },
        },
        -- List of patterns that will be removed from content foldtext section.
        stop_words = {
            "@brief%s*", -- (for cpp) Remove '@brief' and all spaces after.
        },
    })
end

function config.scrollview()
    if vim.wo.diff then
        return
    end
    local w = vim.api.nvim_call_function("winwidth", { 0 })
    if w < 70 then
        return
    end

    vim.g.scrollview_column = 1
end
function config.dir_buff()
    require("dirbuf").setup({
        hash_padding = 2,
        show_hidden = true,
        sort_order = function(l, r)
            return l.fname:lower() < r.fname:lower()
        end,
    })
end

function config.tokyonight()
    local opt = { "storm", "night" }
    local v = math.random(1, #opt)
    vim.g.tokyonight_style = opt[v]
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    vim.g.tokyonight_colors = { hint = "orange", error = "#ae1960" }
end

function config.tokyodark()
    vim.g.tokyodark_transparent_background = false
    vim.g.tokyodark_enable_italic_comment = true
    vim.g.tokyodark_enable_italic = true
    vim.g.tokyodark_color_gamma = "1.0"
end
function config.dogrun()
    vim.g.clap_theme = "dogrun"
end

function config.chalk()
    local chalklines = require("chalklines")
    chalklines.setup({
        integration = {
            neotree = {
                enabled = true,
                show_root = true, -- makes the root folder not transparent
                transparent_panel = false, -- make the panel transparent
            },
        },
        modules = {
            barbar = true,
            bufferline = true,
            cmp = true,
            dashboard = true,
            diagnostic = {
                enable = true,
                background = true,
            },
            fern = true,
            fidget = true,
            gitgutter = true,
            gitsigns = true,
            glyph_palette = true,
            hop = true,
            indent_blankline = true,
            illuminate = true,
            lightspeed = true,
            lsp_saga = true,
            lsp_trouble = true,
            modes = true,
            native_lsp = true,
            neogit = true,
            neorg = true,
            neotree = true,
            notify = true,
            nvimtree = true,
            pounce = true,
            sneak = true,
            symbol_outline = true,
            telescope = true,
            treesitter = true,
            tsrainbow = true,
            vimwiki = true,
            whichkey = true,
        },
    })
    vim.cmd([[colorscheme chalklines]])
end

function config.catppuccin()
    local catppuccin = require("catppuccin")

    -- configure it
    catppuccin.setup({
        transparent_background = false,
        term_colors = true,
        styles = {
            comments = "italic",
            functions = "italic",
            keywords = "italic",
            strings = "NONE",
            variables = "italic",
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = "italic",
                    hints = "italic",
                    warnings = "italic",
                    information = "italic",
                },
                underlines = {
                    errors = "underline",
                    hints = "underline",
                    warnings = "underline",
                    information = "underline",
                },
            },
            lsp_trouble = true,
            cmp = true,
            lsp_saga = true,
            gitgutter = true,
            gitsigns = true,
            telescope = true,
            nvimtree = {
                enabled = true,
                show_root = true,
                transparent_panel = true,
            },
            which_key = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = true,
            },
            dashboard = false,
            neogit = true,
            vim_sneak = true,
            fern = true,
            barbar = false,
            bufferline = false, -- see how this effects our bar
            markdown = true,
            lightspeed = true,
            ts_rainbow = true,
            hop = false,
            notify = true,
            telekasten = true,
        },
    })
    vim.cmd([[colorscheme catppuccin]])
end

function config.kanagawa()
    if not packer_plugins["kanagawa.nvim"].loaded then
        vim.cmd([[packadd kanagawa.nvim ]])
    end
    require("kanagawa").setup({
        undercurl = true, -- enable undercurls
        commentStyle = "italic",
        functionStyle = "italic",
        keywordStyle = "italic",
        statementStyle = "bold",
        typeStyle = "NONE",
        variablebuiltinStyle = "italic",
        specialReturn = true, -- special highlight for the return keyword
        specialException = true, -- special highlight for exception handling keywords
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC` -- Kinda messes with things
        colors = {},
        overrides = {
            Pmenu = { fg = "NONE", bg = "NONE" },
            normalfloat = { bg = "NONE" },
        },
    })
    vim.cmd([[colorscheme kanagawa]])
end

function config.nightfly()
    vim.g.nightflyCursorColor = 1
    vim.g.nightflyUnderlineMatchParen = 1
    vim.g.nightflyUndercurls = 1
    vim.g.nightflyItalics = 1
    vim.g.nightflyNormalFloat = 1
    vim.g.nightflyTransparent = 1

    -- body
end

function config.rosepine()
    vim.g.rose_pine_variant = "moon"
    vim.g.rose_pine_bold_vertical_split_line = true
    vim.g.rose_pine_disable_italics = false
    vim.g.rose_pine_disable_background = false
    vim.g.rose_pine_disable_float_background = true
end

function config.nvcode()
    vim.g.nvcode_termcolors = 256
    local opt = { "nvcode", "nord", "aurora", "onedark", "gruvbox", "palenight", "snazzy" }
    local v = "colorscheme " .. opt[math.random(1, #opt)]
    vim.cmd(v)
    -- body
end

function config.sonokai()
    local opt = { "andromeda", "default", "andromeda", "shusia", "maia", "atlantis" }
    local v = opt[math.random(1, #opt)]
    vim.g.sonokai_style = v
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_diagnostic_virtual_text = "colored"
    vim.g.sonokai_disable_italic_comment = 1
    vim.g.sonokai_current_word = "underline"
    vim.cmd([[colorscheme sonokai]])
    vim.cmd([[hi CurrentWord guifg=#E3F467 guibg=#332248 gui=Bold,undercurl]])
    vim.cmd([[hi TSKeyword gui=Bold]])
end

function config.blankline()
    vim.opt.termguicolors = true
    vim.opt.list = true

    -- test this for now, not sure if i like this or not .
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")

    require("indent_blankline").setup({
        enabled = true,
        -- char = "|",
        char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
        filetype_exclude = {
            "neo-tree-popup",
            "help",
            "startify",
            "dashboard",
            "packer",
            "guihua",
            "NvimTree",
            "sidekick",
        },
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        buftype_exclude = { "terminal" },
        space_char_blankline = " ",
        use_treesitter = true,
        show_current_context = true,

        context_patterns = {
            "class",
            "return",
            "function",
            "method",
            "^if",
            "if",
            "^while",
            "jsx_element",
            "^for",
            "for",
            "^object",
            "^table",
            "block",
            "arguments",
            "if_statement",
            "else_clause",
            "jsx_element",
            "jsx_self_closing_element",
            "try_statement",
            "catch_clause",
            "import_statement",
            "operation_type",
        },
        bufname_exclude = { "README.md" },
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

function config.gruvbox()
    local opt = { "soft", "medium", "hard" }
    local palettes = { "material", "mix", "original" }
    local v = opt[math.random(1, #opt)]
    local palette = palettes[math.random(1, #palettes)]
    local h = tonumber(os.date("%H"))
    if h > 6 and h < 18 then
        lprint("gruvboxlight")
        vim.cmd("set background=light")
    else
        lprint("gruvboxdark")
        vim.cmd("set background=dark")
    end

    vim.g.gruvbox_material_invert_selection = 0
    vim.g.gruvbox_material_enable_italic = 1
    -- vim.g.gruvbox_material_italicize_strings = 1
    -- vim.g.gruvbox_material_invert_signs = 1
    vim.g.gruvbox_material_improved_strings = 1
    vim.g.gruvbox_material_improved_warnings = 1
    -- vim.g.gruvbox_material_contrast_dark=v
    vim.g.gruvbox_material_background = v
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_palette = palette
    vim.cmd("colorscheme gruvbox-material")
    vim.cmd("doautocmd ColorScheme")
end

function config.minimap()
    vim.cmd([[nmap <F14> :MinimapToggle<CR>]])
    local w = vim.api.nvim_call_function("winwidth", { 0 })
    if w > 180 then
        vim.g.minimap_width = 12
    elseif w > 120 then
        vim.g.minimap_width = 10
    elseif w > 80 then
        vim.g.minimap_width = 7
    else
        vim.g.minimap_width = 2
    end
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
