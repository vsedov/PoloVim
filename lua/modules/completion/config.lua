local global = require("core.global")
local config = {}

function config.nvim_lsp()
    require("modules.completion.lsp")
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

local function is_prior_char_whitespace()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

function config.nvim_cmp()
    local cmp = require("cmp")
    local kind = require("utils.kind")

    -- local kind = cmp.lsp.CompletionItemKind

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    local luasnip = require("luasnip")
    local function tab(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            -- F("<Tab>")
            fallback()
        end
    end

    if load_coq() then
        local sources = {}
        cmp.setup.buffer({ completion = { autocomplete = false } })
        return
    end
    -- print("cmp setup")
    local comp_kind = nil
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end
    local lspkind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }
    local sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "treesitter", keyword_length = 2 },
        { name = "look", keyword_length = 4 },
        { name = "neorg", priority = 6 },
        -- { name = "nvim_lsp_signature_help", priority = 10 },
        -- {name = 'buffer', keyword_length = 4} {name = 'path'}, {name = 'look'},
        -- {name = 'calc'}, {name = 'ultisnips'} { name = 'snippy' }
    }
    if vim.o.ft == "sql" then
        table.insert(sources, { name = "vim-dadbod-completion" })
    end
    if vim.o.ft == "python" then
        table.insert(sources, { name = "cmp_tabnine" })
    end

    if vim.o.ft == "markdown" then
        table.insert(sources, { name = "spell" })
        table.insert(sources, { name = "look" })
        table.insert(sources, { name = "latex_symbols" })
    end
    if vim.o.ft == "lua" then
        table.insert(sources, { name = "nvim_lua" })
        table.insert(sources, { name = "cmp_tabnine" })
    end
    if vim.o.ft == "zsh" or vim.o.ft == "sh" or vim.o.ft == "fish" or vim.o.ft == "proto" then
        table.insert(sources, { name = "path" })
        table.insert(sources, { name = "buffer", keyword_length = 3 })
        table.insert(sources, { name = "calc" })
    end
    cmp.setup({

        window = {
            completion = {
                border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                scrollbar = { "║" },
            },
            documentation = {
                border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                scrollbar = { "║" },
            },
        },

        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        completion = {
            autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
            completeopt = "menu,menuone,noselect",
        },
        formatting = {
            fields = {
                cmp.ItemField.Kind,
                cmp.ItemField.Abbr,
                cmp.ItemField.Menu,
            },
            format = kind.cmp_format({
                with_text = false,
                before = function(entry, vim_item)
                    -- Get the full snippet (and only keep first line)
                    local word = entry:get_insert_text()
                    if
                        entry.completion_item.insertTextFormat
                        --[[  ]]
                        == types.lsp.InsertTextFormat.Snippet
                    then
                        word = vim.lsp.util.parse_snippet(word)
                    end
                    word = str.oneline(word)

                    -- concatenates the string
                    local max = 50
                    if string.len(word) >= max then
                        local before = string.sub(word, 1, math.floor((max - 3) / 2))
                        word = before .. "..."
                    end

                    if
                        entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
                        and string.sub(vim_item.abbr, -1, -1) == "~"
                    then
                        word = word .. "~"
                    end
                    vim_item.abbr = word

                    vim_item.dup = ({
                        buffer = 1,
                        path = 1,
                        nvim_lsp = 0,
                    })[entry.source.name] or 0

                    return vim_item
                end,
            }),
            -- format = function(entry, vim_item)
            --   vim_item.kind = string.format(
            --     "%s %s",
            --     -- "%s",
            --     get_kind(vim_item.kind),
            --     vim_item.kind
            --   )

            -- end
        },
        -- You must set mapping if you want.
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),

            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-' '>"] = cmp.mapping.confirm({ select = true }),

            ["<CR>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Insert,
            }),

            ["<C-f>"] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    require("luasnip").change_choice(1)
                elseif cmp.visible() then
                    cmp.mapping.scroll_docs(4)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
            ["<C-d>"] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    require("luasnip").change_choice(-1)
                elseif cmp.visible() then
                    cmp.mapping.scroll_docs(-4)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),

            ["<Tab>"] = cmp.mapping(function(core, fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expandable() then
                    luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif not check_backspace() then
                    cmp.mapping.complete()(core, fallback)
                elseif has_words_before() then
                    cmp.complete()
                else
                    vim.cmd(":>")
                end
            end, {
                "i",
                "s",
            }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    vim.cmd(":<")
                end
            end, {
                "i",
                "s",
            }),

            ["<C-j>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.mapping.abort()
                    cmp.mapping.close()
                end
                if luasnip.expandable() then
                    luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif check_backspace() then
                    fallback()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),

            ["<C-k>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.mapping.abort()
                    cmp.mapping.close()
                end
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),

            ["<C-l>"] = cmp.mapping(function(fallback)
                local copilot_keys = vim.fn["copilot#Accept"]("")
                if copilot_keys ~= "" then
                    vim.api.nvim_feedkeys(copilot_keys, "i", true)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
        },

        -- You should specify your *installed* sources.
        sources = sources,

        enabled = function()
            -- if require"cmp.config.context".in_treesitter_capture("comment")==true or require"cmp.config.context".in_syntax_group("Comment") then
            --   return false
            -- else
            --   return true
            -- end
            if vim.bo.ft == "TelescopePrompt" then
                return false
            end
            if vim.bo.ft == "lua" then
                return true
            end
            local lnum, col = vim.fn.line("."), math.min(vim.fn.col("."), #vim.fn.getline("."))
            for _, syn_id in ipairs(vim.fn.synstack(lnum, col)) do
                syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
                if vim.fn.synIDattr(syn_id, "name") == "Comment" then
                    return false
                end
            end
            if vim.tbl_contains(Get_treesitter_hl(), "TSComment") then
                return false
            end
            if string.find(vim.api.nvim_buf_get_name(0), "neorg://") then
                return false
            end
            if string.find(vim.api.nvim_buf_get_name(0), "s_popup:/") then
                return false
            end
            return true
        end,

        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        experimental = { ghost_text = true, native_menu = false },
    })

    require("packer").loader("nvim-autopairs")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

    -- require'cmp'.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
    if vim.o.ft == "clap_input" or vim.o.ft == "guihua" or vim.o.ft == "guihua_rust" then
        require("cmp").setup.buffer({ completion = { enable = false } })
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "TelescopePrompt", "clap_input" },
        callback = function()
            require("cmp").setup.buffer({ enabled = false })
        end,
        once = false,
    })

    -- if vim.o.ft ~= 'sql' then
    --   require'cmp'.setup.buffer { completion = {autocomplete = false} }
    -- end
    cmp.setup.cmdline(":", {
        window = {
            completion = {
                border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                scrollbar = { "║" },
            },
            documentation = {
                border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                scrollbar = { "║" },
            },
        },
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
        enabled = function()
            return true
        end,
    })

    cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer", keyword_length = 1 },
        },
        enabled = function()
            return true
        end,
        window = {
            completion = {
                border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                scrollbar = { "║" },
            },
            documentation = {
                border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                scrollbar = { "║" },
            },
        },
    })
    local neorg = require("neorg")

    local function load_completion()
        neorg.modules.load_module("core.norg.completion", nil, {
            engine = "nvim-cmp",
        })
    end

    if neorg.is_loaded() then
        load_completion()
    else
        neorg.callbacks.on_event("core.started", load_completion)
    end

    vim.cmd([[hi NormalFloat guibg=none]])
end

function config.vim_vsnip()
    vim.g.vsnip_snippet_dir = os.getenv("HOME") .. "/.config/nvim/snippets"
end
-- packer.nvim: Error running config for LuaSnip: [string "..."]:0: attempt to index global 'ls_types' (a nil value)
function config.luasnip()
    require("modules.completion.luasnip")
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
    vim.g.ale_lint_on_text_changed = 1

    vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"

    vim.g.ale_lint_on_insert_leave = 0
    vim.g.ale_lint_on_enter = 0

    vim.g.ale_set_balloons = 1
    vim.g.ale_hover_cursor = 1
    vim.g.ale_hover_to_preview = 1
    vim.g.ale_float_preview = 1
    vim.g.ale_virtualtext_cursor = 1

    vim.g.ale_fix_on_save = 1
    vim.g.ale_fix_on_insert_leave = 0
    vim.g.ale_fix_on_text_changed = "never"
end

return config
