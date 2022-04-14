-- local global = require("core.global")
local config = {}

function config.nvim_lsp()
    require("modules.completion.lsp")
end

function config.clangd()
    require("modules.completion.lsp.providers.c")
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

return config
