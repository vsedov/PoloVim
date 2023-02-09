local config = {}
function config.nvim_bufferline()
    local fn = vim.fn
    local r = vim.regex
    local fmt = string.format
    local icons = lambda.style.icons.lsp

    local gl = require("utils.ui.utils")
    local groups = require("bufferline.groups")

    local visible_tab = { highlight = "VisibleTab", attribute = "bg" }

    require("bufferline").setup({
        highlights = function(defaults)
            local data = gl.get("normal")
            local normal_bg, normal_fg = data.background, data.foreground
            local visible = gl.alter_color(normal_fg, -40)
            local diagnostic = r([[\(error_selected\|warning_selected\|info_selected\|hint_selected\)]])

            local hl = lambda.fold(function(accum, attrs, name)
                local formatted = name:lower()
                local is_group = formatted:match("group")
                local is_offset = formatted:match("offset")
                local is_separator = formatted:match("separator")
                if diagnostic:match_str(formatted) then
                    attrs.fg = normal_fg
                end
                if not is_group or (is_group and is_separator) then
                    attrs.bg = normal_bg
                end
                if not is_group and not is_offset and is_separator then
                    attrs.fg = normal_bg
                end
                accum[name] = attrs
                return accum
            end, defaults.highlights)

            -- make the visible buffers and selected tab more "visible"
            hl.buffer_visible.bold = true
            hl.buffer_visible.italic = true
            hl.buffer_visible.fg = visible
            hl.tab_selected.bold = true
            hl.tab_selected.bg = visible_tab
            hl.tab_separator_selected.bg = visible_tab

            return hl
        end,
        options = {
            debug = { logging = true },
            mode = "buffers", -- tabs
            sort_by = "insert_after_current",
            right_mouse_command = "vert sbuffer %d",
            show_close_icon = false,
            indicator = { style = "underline" },
            show_buffer_close_icons = true,
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level)
                return (icons[level] or "?") .. " " .. count
            end,
            diagnostics_update_in_insert = false,
            offsets = {
                {
                    text = "EXPLORER",
                    filetype = "neo-tree",
                    highlight = "PanelHeading",
                    text_align = "left",
                    separator = true,
                },
                {
                    text = " FLUTTER OUTLINE",
                    filetype = "flutterToolsOutline",
                    highlight = "PanelHeading",
                    separator = true,
                },
                {
                    text = "UNDOTREE",
                    filetype = "undotree",
                    highlight = "PanelHeading",
                    separator = true,
                },
                {
                    text = " PACKER",
                    filetype = "packer",
                    highlight = "PanelHeading",
                    separator = true,
                },
                {
                    text = " DATABASE VIEWER",
                    filetype = "dbui",
                    highlight = "PanelHeading",
                    separator = true,
                },
                {
                    text = " DIFF VIEW",
                    filetype = "DiffviewFiles",
                    highlight = "PanelHeading",
                    separator = true,
                },
            },
            groups = {
                options = {
                    toggle_hidden_on_enter = true,
                },
                items = {
                    groups.builtin.pinned:with({ icon = "" }),
                    groups.builtin.ungrouped,
                    {
                        name = "Dependencies",
                        icon = "",
                        highlight = { fg = "#ECBE7B" },
                        matcher = function(buf)
                            return vim.startswith(buf.path, fmt("%s/site/pack/packer", fn.stdpath("data")))
                                or vim.startswith(buf.path, fn.expand("$VIMRUNTIME"))
                        end,
                    },
                    {
                        name = "Terraform",
                        matcher = function(buf)
                            return buf.name:match("%.tf") ~= nil
                        end,
                    },
                    {
                        name = "Kubernetes",
                        matcher = function(buf)
                            return buf.name:match("kubernetes") and buf.name:match("%.yaml")
                        end,
                    },
                    {
                        name = "SQL",
                        matcher = function(buf)
                            return buf.filename:match("%.sql$")
                        end,
                    },
                    {
                        name = "tests",
                        icon = "",
                        matcher = function(buf)
                            local name = buf.filename
                            if name:match("%.sql$") == nil then
                                return false
                            end
                            return name:match("_spec") or name:match("_test")
                        end,
                    },
                    {
                        name = "docs",
                        icon = "",
                        matcher = function(buf)
                            for _, ext in ipairs({ "md", "txt", "norg", "wiki" }) do
                                if ext == fn.fnamemodify(buf.path, ":e") then
                                    return true
                                end
                            end
                        end,
                    },
                },
            },
        },
    })

    require("modules.editor.hydra.buffer")
end

function config.reach()
    require("reach").setup({
        notifications = true,
    })
end

function config.close_buffers()
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
    vim.api.nvim_create_user_command("BufKillThis", function()
        require("close_buffers").delete({ type = "this" })
    end, { range = true })

    vim.api.nvim_create_user_command("BufKillNameless", function()
        require("close_buffers").delete({ type = "nameless" })
    end, { range = true })

    vim.api.nvim_create_user_command("BufKillHidden", function()
        require("close_buffers").delete({ type = "hidden", force = true }) -- delete all non a vis vis à vis buffers
    end, { range = true })

    vim.api.nvim_create_user_command("BufWipe", function()
        require("close_buffers").wipe({ type = "other" }) -- Wipe all buffers except the current focused
    end, { range = true })

    vim.keymap.set("n", "_q", "<Cmd>BWipeout other<CR>", { silent = true })
end

function config.sticky_buf()
    require("stickybuf").setup({
        buftype = {
            [""] = false,
            acwrite = false,
            help = "buftype",
            nofile = false,
            nowrite = false,
            quickfix = "buftype",
            terminal = false,
            prompt = "bufnr",
        },
        wintype = {
            autocmd = false,
            popup = "bufnr",
            preview = false,
            command = false,
            [""] = false,
            unknown = false,
            floating = false,
        },
        filetype = {
            aerial = "filetype",
            nerdtree = "filetype",
            ["neotest-summary"] = "filetype",
        },
        bufname = {
            ["Neogit.*Popup"] = "bufnr",
        },
        autocmds = {
            defx = [[au FileType defx if &winfixwidth || &winfixheight | silent! PinFiletype | endif]],
            fern = [[au FileType fern if &winfixwidth || &winfixheight | silent! PinFiletype | endif]],
            neogit = [[au FileType NeogitStatus,NeogitLog,NeogitGitCommandHistory if winnr('$') > 1 | silent! PinFiletype | endif]],
        },
    })
end
function config.three()
    require("three").setup({
        bufferline = {
            enabled = true,
            icon = {
                dividers = { "▍", "" },
                scroll = { "«", "»" },
                pin = "車",
            },
            scope_by_directory = true,
        },
        windows = {
            enabled = false,
            -- Constant or function to calculate the minimum window width of the focused window
            winwidth = function(winid)
                local bufnr = vim.api.nvim_win_get_buf(winid)
                return math.max(vim.api.nvim_buf_get_option(bufnr, "textwidth"), 80)
            end,
            -- Constant or function to calculate the minimum window height of the focused window
            winheight = 10,
        },
        projects = {
            enabled = true,
            -- Name of file to store the project directory cache
            filename = "projects.json",
            -- When true, automatically add directories entered as projects
            -- If false, you will need to manually call add_project()
            autoadd = true,
            -- List of lua patterns. If any match the directory, it will be allowed as a project
            allowlist = {},
            -- List of lua patterns. If any match the directory, it will be ignored as a project
            blocklist = {},
            -- Return true to allow a directory as a project
            filter_dir = function(dir)
                return true
            end,
        },
    })
end
return config
