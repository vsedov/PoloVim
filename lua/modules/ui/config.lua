-- local api = vim.api
local r, api, fn = vim.regex, vim.api, vim.fn
local strwidth = api.nvim_strwidth

local symbols = lambda.reqidx("lspkind")

local config = {}

function config.h_line()
    require("modules.ui.heirline")
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
        background_colour = "NormalFloat",
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
            api.nvim_win_set_config(win, { border = lambda.style.border.type_0 })
        end,
        render = function(...)
            local notification = select(2, ...)
            local style = lambda.falsy(notification.title[1]) and "minimal" or "default"
            require("notify.render")[style](...)
        end,
    })

    vim.keymap.set("n", "<leader>nd", function()
        notify.dismiss({ silent = true, pending = true })
    end, {
        desc = "dismiss notifications",
    })
    vim.notify = notify
    require("telescope").load_extension("notify")
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
        close_fold_kinds_for_ft = { "imports", "comment" },
        provider_selector = function(_, ft)
            return { "treesitter" }

            -- return ft_map[ft] or { "treesitter", "indent" }
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
                "bpacker",
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
