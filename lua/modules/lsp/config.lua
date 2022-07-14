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

function config.saga()
    local saga = require("lspsaga")
    saga.init_lsp_saga({
        -- Not need for the time.  > maybe later though
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
        },
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
    })
end

function config.lps_lines_setup()
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
    vim.api.nvim_create_user_command("DiagnosticDisable", function()
        vim.api.nvim_clear_autocmds({ group = Diagnostics })
        vim.diagnostic.config({ virtual_lines = false })
    end, { force = true })

    vim.api.nvim_create_user_command("DiagnosticEnable", function()
        vim.cmd([[packadd lsp_lines.nvim]])
        create_auto_cmd()
    end, { force = true })
end

function config.lsp_lines()
    require("lsp_lines").register_lsp_virtual_lines()
end

function config.format()
    require("formatter").setup({
        -- All formatter configurations are opt-in
        filetype = {
            lua = {
                -- Pick from defaults:
                require("formatter.filetypes.lua").stylua,
            },
            python = {
                require("formatter.filetypes.python").yapf,
                require("formatter.filetypes.python").isort,
            },
        },
    })
end

function config.lint()
    local lint = require("lint")
    local pattern = "[^:]+:(%d+):(%d+)-(%d+): %((%a)(%d+)%) (.*)"
    local groups = { "lnum", "col", "end_col", "severity", "code", "message" }
    local severities = {
        W = vim.diagnostic.severity.WARN,
        E = vim.diagnostic.severity.ERROR,
    }

    local custom_lua_check = {
        cmd = "luacheck",
        stdin = true,
        args = { "--formatter", "plain", "--codes", "--ranges", "--config", "/home/viv/.config/.luacheckrc", "-" },
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(pattern, groups, severities, { ["source"] = "luacheck" }),
    }
    lint.linters.luacheck = custom_lua_check
    lint.linters_by_ft = {
        lua = { "luacheck" },
        markdown = { "vale" },

        python = { "codespell", "flake8" }, --  "flake8",
    }
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
return config
