local config = {}
function config.nvim_bufferline()
    local fn = vim.fn
    local r = vim.regex
    local fmt = string.format
    local icons = lambda.style.icons.lsp

    local bufferline = require("bufferline")
    local Offset = require("bufferline.offset")
    bufferline.setup({
        options = {
            debug = { logging = true },
            style_preset = { bufferline.style_preset.minimal },
            mode = "buffers",
            sort_by = "insert_after_current",
            move_wraps_at_ends = true,
            right_mouse_command = "vert sbuffer %d",
            show_close_icon = false,
            show_buffer_close_icons = true,
            indicator = { style = "underline" },
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level)
                level = level:match("warn") and "warn" or level
                return (icons[level] or "?") .. " " .. count
            end,
            diagnostics_update_in_insert = false,
            hover = { enabled = true, reveal = { "close" } },
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
                options = { toggle_hidden_on_enter = true },
                items = {
                    bufferline.groups.builtin.pinned:with({ icon = "" }),
                    bufferline.groups.builtin.ungrouped,
                    {
                        name = "Dependencies",
                        icon = "",
                        highlight = { fg = "#ECBE7B" },
                        matcher = function(buf)
                            return vim.startswith(buf.path, vim.env.VIMRUNTIME)
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
                            return buf.name:match("%.sql$")
                        end,
                    },
                    {
                        name = "tests",
                        icon = "",
                        matcher = function(buf)
                            local name = buf.name
                            return name:match("[_%.]spec") or name:match("[_%.]test")
                        end,
                    },
                    {
                        name = "docs",
                        icon = "",
                        matcher = function(buf)
                            if vim.bo[buf.id].filetype == "man" or buf.path:match("man://") then
                                return true
                            end
                            for _, ext in ipairs({ "txt", "org", "wiki" }) do
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
    if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
            if package.loaded.edgy then
                local layout = require("edgy.config").layout
                local ret = { left = "", left_size = 0, right = "", right_size = 0 }
                for _, pos in ipairs({ "left", "right" }) do
                    local sb = layout[pos]
                    if sb and #sb.wins > 0 then
                        local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                        ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                        ret[pos .. "_size"] = sb.bounds.width
                    end
                end
                ret.total_size = ret.left_size + ret.right_size
                if ret.total_size > 0 then
                    return ret
                end
            end
            return get()
        end
        Offset.edgy = true
    end
end

function config.reach()
    require("reach").setup({
        notifications = true,
    })
end

function config.sticky_buf()
    require("stickybuf").setup({
        get_auto_pin = function(bufnr)
            return require("stickybuf").should_auto_pin(bufnr)
        end,
    })
end

function config.three()
    local three = require("three")

    three.setup({
        bufferline = {
            enabled = true,
            icon = {
                -- Tab left/right dividers
                -- Set to this value for fancier, more "tab-looking" tabs
                -- dividers = { " ", " " },
                dividers = { "▍", "" },
                -- Scroll indicator icons when buffers exceed screen width
                scroll = { "«", "»" },
                -- Pinned buffer icon
                pin = "󰐃",
            },
            -- When true, only show buffers that are inside the current directory
            -- This can be toggled on a per-tab basis with toggle_scope_by_dir()
            scope_by_directory = true,
        },
        windows = {
            enabled = false,
            -- Constant or function to calculate the minimum window width of the focused window
            winwidth = function(winid)
                local bufnr = vim.api.nvim_win_get_buf(winid)
                return math.max(vim.bo[bufnr].textwidth, 80)
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

    lambda.command("BufCloseAllButCurrent", function()
        three.close_all_buffers(function(info)
            return info.bufnr ~= vim.api.nvim_get_current_buf()
        end)
    end, {})
    lambda.command("BufCloseAllButPinned", function()
        three.close_all_buffers(function(info)
            return not info.pinned
        end)
    end, {})
    lambda.command("BufHideAll", function()
        three.hide_all_buffers()
    end, {})
    lambda.command("BufHideAllButCurrent", function()
        three.hide_all_buffers(function(info)
            return info.bufnr ~= vim.api.nvim_get_current_buf()
        end)
    end, {})
    lambda.command("BufHideAllButPinned", function()
        three.hide_all_buffers(function(info)
            return not info.pinned
        end)
    end, {})
end
return config
