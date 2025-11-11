local config = {}

function config.lsp_install()
    require("modules.lsp.lsp.providers.lsp_install")
end

function config.saga()
    local saga = require("lspsaga")
    saga.init_lsp_saga({
        symbol_in_winbar = {
            in_custom = false,
            enable = false,
            separator = " ",
            show_file = false,
            click_support = false,
        },
        saga_winblend = 10,
        move_in_saga = { prev = "<C-,>", next = "<C-.>" },
        diagnostic_header = { " ", " ", " ", "ﴞ " },
        max_preview_lines = 10,
        code_action_icon = "ﯦ",
        code_action_num_shortcut = true,
        code_action_lightbulb = {
            enable = false,
            sign = true,
            sign_priority = 20,
            virtual_text = false,
        },
        finder_icons = {
            def = "  ",
            ref = "諭 ",
            link = "  ",
        },
        finder_action_keys = {
            open = { "o", "<cr>" },
            vsplit = "s",
            split = "i",
            tabe = "t",
            quit = "q",
            scroll_down = "<C-f>",
            scroll_up = "<C-b>",
        },
        code_action_keys = {
            quit = "q",
            exec = "<CR>",
        },
        rename_action_quit = "<C-c>",

        show_outline = {
            win_position = "right",
            -- set the special filetype in there which in left like nvimtree neotree defx
            left_with = "",
            win_width = 30,
            auto_enter = true,
            auto_preview = true,
            virt_text = "┃",
            jump_key = "o",
            -- auto refresh when change buffer
            auto_refresh = true,
        },
    })
end
function config.lsp_sig()
    local cfg = {
        bind = true,
        fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
        doc_lines = 10,
        floating_window = false, -- show hint in a floating window, set to false for virtual text only mode ]]
        floating_window_above_cur_line = false,
        hint_enable = true, -- virtual hint enable
        hint_prefix = "🐼 ", -- Panda for parameter
        auto_close_after = 15, -- close after 15 seconds
        --[[ hint_prefix = " ", ]]
        toggle_key = "»",
        select_signature_key = "<C-n>",
        max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
            border = lambda.style.border.type_0, -- double, single, shadow, none
        },

        transpancy = 80,
        zindex = 300, -- by default it will be on top of all floating windows, set to 50 send it to bottom
        log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
        padding = " ", -- character to pad on left and right of signature can be ' ', or '|'  etc
    }

    require("lsp_signature").setup(cfg)
end

function config.hover()
    require("hover").setup({
        init = function()
            require("hover.providers.lsp")
            require("hover.providers.gh")
            require("hover.providers.jira")
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

function config.lsp_lines()
    require("lsp_lines").setup()
    local Diagnostics = vim.api.nvim_create_augroup("Diagnostics", { clear = true })

    local create_auto_cmd = function()
        vim.api.nvim_create_autocmd("InsertLeave", {
            pattern = "*",
            group = Diagnostics,
            callback = function()
                vim.diagnostic.config({ virtual_lines = true })
            end,
        })
        vim.api.nvim_create_autocmd("InsertEnter", {
            pattern = "*",
            group = Diagnostics,
            callback = function()
                vim.diagnostic.config({ virtual_lines = false })
            end,
        })
    end

    create_auto_cmd()
    vim.api.nvim_create_user_command("TL", function()
        popup_toggle = lambda.config.lsp.use_lsp_lines
        if popup_toggle then
            create_auto_cmd()
        else
            vim.api.nvim_clear_autocmds({ group = Diagnostics })
            vim.diagnostic.config({ virtual_lines = false })
        end
    end, { force = true })
end

function config.rename()
    require("inc_rename").setup({
        input_buffer_type = "dressing",
        hl_group = "Visual",
    })
end

function config.navic()
    local highlights = require("utils.ui.highlights")
    local s = lambda.style
    local misc = s.icons.misc

    highlights.plugin("navic", {
        { NavicText = { bold = true } },
        { NavicSeparator = { link = "Directory" } },
    })
    require("nvim-navic").setup({
        icons = {
            File = " ",
            Module = " ",
            Namespace = " ",
            Package = " ",
            Class = " ",
            Method = " ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = "練",
            Interface = "練",
            Function = " ",
            Variable = " ",
            Constant = " ",
            String = " ",
            Number = " ",
            Boolean = "◩ ",
            Array = " ",
            Object = " ",
            Key = " ",
            Null = "ﳠ ",
            EnumMember = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
        },
        highlight = true,
        separator = (" %s "):format(misc.arrow_right),
        depth_limit = 0,
        depth_limit_indicator = misc.ellipsis,
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
        auto_cmds = false,
    })
    require("lsp_lines").setup()
    local Diagnostics = vim.api.nvim_create_augroup("right_corner_diagnostics", { clear = true })

    local create_auto_cmd = function()
        vim.api.nvim_create_autocmd("InsertLeave", {
            pattern = "*",
            group = Diagnostics,
            callback = function()
                require("rcd").show()
            end,
        })
        vim.api.nvim_create_autocmd("InsertEnter", {
            pattern = "*",
            group = Diagnostics,
            callback = function()
                require("rcd").hide()
            end,
        })
    end
    create_auto_cmd()
    vim.api.nvim_create_user_command("RCD", function()
        popup_toggle = lambda.config.lsp.use_rcd
        if popup_toggle then
            create_auto_cmd()
        else
            vim.api.nvim_clear_autocmds({ group = Diagnostics })
            require("rcd").hide()
        end
    end, { force = true })
end

function config.goto_preview()
    local telescope = require("telescope.themes")

    require("goto-preview").setup({
        width = 80, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
            telescope = {
                require("telescope.themes").get_dropdown({
                    winblend = 15,
                    layout_config = {
                        prompt_position = "top",
                        width = 64,
                        height = 15,
                    },
                    border = {},
                    previewer = false,
                    shorten_path = false,
                }),
            },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
    })
end

return config
