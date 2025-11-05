local config = {}
function config.nvim_bufferline()
    local fn = vim.fn
    local r = vim.regex
    local fmt = string.format
    local icons = lambda.style.icons.lsp

    local highlights = require("utils.ui.highlights")
    local groups = require("bufferline.groups")

    local visible_tab = { highlight = "VisibleTab", attribute = "bg" }

    require("bufferline").setup({
        highlights = function(defaults)
            local data = highlights.get("normal")
            local normal_bg, normal_fg = data.background, data.foreground
            local visible = highlights.alter_color(normal_fg, -40)
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
    })
end
function config.tabby()
    require("tabby").setup()
end

function config.reach()
    require("reach").setup({
        notifications = true,
    })
end
function config.cybu()
    require("cybu").setup()
end

function config.scope()
    require("scope").setup()
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
    vim.api.nvim_create_user_command("Kwbd", function()
        require("close_buffers").delete({ type = "this" })
    end, { range = true })
end

function config.bbye()
    vim.keymap.set("n", "_q", "<Cmd>Bwipeout<CR>", { silent = true })
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

return config
