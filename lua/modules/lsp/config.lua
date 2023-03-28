local config = {}
function config.nvim_lsp_setup()
    require("modules.lsp.lsp.config").setup()
end

function config.nvim_lsp()
    require("modules.lsp.lsp")
end
function config.mason_setup()
    require("modules.lsp.lsp.mason.python")
    local get_config = require("modules.lsp.lsp.mason.lsp_servers")
    require("mason").setup({ ui = { border = lambda.style.border.type_0 } })
    require("mason-lspconfig").setup({
        automatic_installation = {
            exclude = { "lua_ls", "clangd", "ltex", "texlab" },
        },
    })

    require("mason-lspconfig").setup_handlers({
        function(name)
            -- print(name)
            local conf = get_config(name)
            if conf then
                require("lspconfig")[name].setup(require("modules.lsp.lsp.config").enhance_attach({ conf }))
            end
        end,
    })
end

function config.lsp_install()
    require("modules.lsp.lsp.providers.lsp_install")
end

function config.clangd()
    require("modules.lsp.lsp.providers.c")
end

function config.luadev()
    require("modules.lsp.lsp.providers.luadev")
end

function config.saga()
    require("lspsaga").setup({
        saga_winblend = 10,
        move_in_saga = { prev = "<C-,>", next = "<C-.>" },
        diagnostic_header = { " ", " ", " ", "ﴞ " },
        max_preview_lines = 10,
        code_action_icon = "",
        code_action_num_shortcut = false,
        lightbulb = {
            enable = false,
            enable_in_insert = false,
            sign = false,
            sign_priority = 40,
            virtual_text = false,
        },
        code_action = {
            num_shortcut = false,
            keys = {
                quit = "q",
                exec = "<CR>",
            },
        },
        diagnostic = {
            twice_into = true,
            show_code_action = false,
            show_source = true,
            keys = {
                exec_action = "o",
                quit = "q",
                go_action = "g",
            },
        },
        symbol_in_winbar = {
            enable = true,
            separator = " ",
            hide_keyword = true,
            show_file = true,
            folder_level = 2,
            respect_root = false,
        },
        ui = {
            -- currently only round theme
            theme = "round",
            -- border type can be single,double,rounded,solid,shadow.
            border = "single",
            winblend = 0,
            expand = "",
            collapse = "",
            preview = " ",
            code_action = "💡",
            diagnostic = "🐞",
            incoming = " ",
            outgoing = " ",
            colors = {
                --float window normal bakcground color
                normal_bg = "NONE",
                --title background
                title_bg = "#CBA6F7",
                red = "#e95678",
                magenta = "#b33076",
                orange = "#FF8700",
                yellow = "#f7bb3b",
                green = "#00bad7",
                cyan = "#36d0e0",
                blue = "#61afef",
                purple = "#CBA6F7",
                white = "#d1d4cf",
                black = "#1c1c19",
            },
            kind = {},
        },
        outline = {
            win_position = "right",
            win_with = "",
            win_width = 30,
            show_detail = true,
            auto_preview = true,
            auto_refresh = true,
            auto_close = true,
            custom_sort = nil,
            keys = {
                jump = "o",
                expand_collapse = "u",
                quit = "q",
            },
        },
    })
    vim.wo.winbar = require("lspsaga.symbolwinbar"):get_winbar()
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
        auto_cmds = true,
    })
end

function config.goto_preview()
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
        focus_on_open = false, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
    })
end

function config.glance()
    -- Lua configuration
    local glance = require("glance")
    local actions = glance.actions

    glance.setup({
        height = 18, -- Height of the window
        border = {
            enable = true, -- Show window borders. Only horizontal borders allowed
            top_char = "-",
            bottom_char = "-",
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
                ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
                ["q"] = actions.close,
                ["Q"] = actions.close,
                ["<Esc>"] = actions.close,
            },
            preview = {
                ["Q"] = actions.close,
                ["<Tab>"] = actions.next_location,
                ["<S-Tab>"] = actions.previous_location,
                ["<leader>l"] = actions.enter_win("list"), -- Focus list window
            },
        },
        folds = {
            fold_closed = "",
            fold_open = "",
            folded = true, -- Automatically fold list on startup
        },
        indent_lines = {
            enable = true,
            icon = "│",
        },
        winbar = {
            enable = true, -- Available strating from nvim-0.8+
        },
    })
end

return config
