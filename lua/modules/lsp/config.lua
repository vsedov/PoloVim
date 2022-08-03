local config = {}
function config.nvim_lsp_setup()
    require("modules.lsp.lsp.utils").setup()
end

function config.nvim_lsp()
    require("modules.lsp.lsp")
end

function config.clangd()
    require("modules.lsp.lsp.providers.c")
end

function config.rust_tools()
    require("modules.lsp.lsp.providers.rust")
end

function config.luadev()
    require("modules.lsp.lsp.providers.luadev")
end

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
        code_action_icon = "", -- this nice feature
        -- diable this for the time, seems to lag things up
        code_action_lightbulb = {
            enable = false,
            sign = false,
            sign_priority = 0,
            virtual_text = false,
        },
        rename_in_select = true,
        server_filetype_map = {},
    })
end

function config.lsp_sig()
    local cfg = {
        bind = true,
        doc_lines = 10,
        floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
        floating_window_above_cur_line = true,
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        hint_prefix = "🐼 ", -- Panda for parameter
        -- hint_prefix = " ",
        extra_trigger_chars = { "(", "{", "," },
        hint_scheme = "DiagnosticHint",
        transparency = vim.api.nvim_get_option("pumblend"),
        toggle_key = "»",
        select_signature_key = "<C-n>",
        use_lspsaga = false, -- set to true if you want to use lspsaga popup
        hi_parameter = "search", -- how your parameter will be highlight
        max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
        -- to view the hiding contents
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
            border = "single", -- double, single, shadow, none
        },
        -- transpancy = 80,
        zindex = 1002, -- by default it will be on top of all floating windows, set to 50 send it to bottom
        debug = plugin_debug(),
        verbose = plugin_debug(),
        log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
        padding = " ", -- character to pad on left and right of signature can be ' ', or '|'  etc
        shadow_blend = 36, -- if you using shadow as border use this set the opacity
        shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    }

    require("lsp_signature").setup(cfg)
end

function config.hover()
    require("hover").setup({
        init = function()
            require("hover.providers.lsp")
            require("hover.providers.gh")
            require("hover.providers.dictionary")
            require("hover.providers.man")
        end,
        preview_opts = {
            border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
        },
        title = false,
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
    local popup_toggle = true
    vim.api.nvim_create_user_command("TL", function()
        popup_toggle = not popup_toggle
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
        hl_group = "Visual",
    })
end

function config.navic()
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
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
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

return config
