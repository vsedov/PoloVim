-- local global = require("core.global")
local config = {}

function config.nvim_lsp()
    -- require("modules.completion.lspp")
    require("modules.completion.lsp")
end

function config.luadev()
    require("modules.completion.lsp.providers.luadev")
end
function config.lsp_install()
    require("modules.completion.lsp.providers.lsp_install")
end

function config.saga()
    local lspsaga = require("lspsaga")
    lspsaga.setup({ -- defaults ...
        debug = false,
        use_saga_diagnostic_sign = false,
        -- code action title icon
        code_action_icon = "",
        code_action_prompt = {
            enable = false,
            sign = false,
            sign_priority = 40,
            virtual_text = false,
        },

        finder_definition_icon = "  ",
        finder_reference_icon = "  ",
        max_preview_lines = 10,
        finder_action_keys = {
            open = "o",
            vsplit = "s",
            split = "i",
            quit = "q",
            scroll_down = "<C-f>",
            scroll_up = "<C-b>",
        },
        code_action_keys = {
            quit = "q",
            exec = "<CR>",
        },
        rename_action_keys = {
            quit = "<C-c>",
            exec = "<CR>",
        },
        definition_preview_icon = "  ",
        border_style = "single",
        rename_prompt_prefix = "➤",
        server_filetype_map = {},
        diagnostic_prefix_format = "%d. ",
    })
end

function config.vim_vsnip()
    vim.g.vsnip_snippet_dir = os.getenv("HOME") .. "/.config/nvim/snippets"
end
-- packer.nvim: Error running config for LuaSnip: [string "..."]:0: attempt to index global 'ls_types' (a nil value)
function config.luasnip()
    require("modules.completion.snippets")
end

function config.telescope()
    require("utils.telescope")
end

function config.emmet()
    vim.g.user_emmet_complete_tag = 1
    -- vim.g.user_emmet_install_global = 1
    vim.g.user_emmet_install_command = 0
    vim.g.user_emmet_mode = "a"
end
function config.vim_sonictemplate()
    vim.g.sonictemplate_postfix_key = "<C-,>"
    vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

function config.tabnine()
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({

        max_line = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
    })
end

function config.ale()
    vim.g.ale_completion_enabled = 0
    vim.g.ale_python_mypy_options = ""
    vim.g.ale_list_window_size = 4
    vim.g.ale_sign_column_always = 0
    vim.g.ale_open_list = 0

    vim.g.ale_set_loclist = 0

    vim.g.ale_set_quickfix = 1
    vim.g.ale_keep_list_window_open = 1
    vim.g.ale_list_vertical = 0

    vim.g.ale_disable_lsp = 0

    vim.g.ale_lint_on_save = 0

    vim.g.ale_sign_error = ""
    vim.g.ale_sign_warning = ""
    vim.g.ale_lint_on_text_changed = 0

    vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
    vim.g.ale_linters_explicit = 1
    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_enter = 0

    vim.g.ale_set_balloons = 1
    vim.g.ale_hover_cursor = 1
    vim.g.ale_hover_to_preview = 1
    vim.g.ale_float_preview = 0
    vim.g.ale_virtualtext_cursor = 0

    vim.g.ale_fix_on_save = 1
    vim.g.ale_fix_on_insert_leave = 0
    vim.g.ale_fix_on_text_changed = "never"
end

return config
