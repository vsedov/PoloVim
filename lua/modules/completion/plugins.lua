local conf = require("modules.completion.config")
local completion = require("core.pack").package

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ VeryLazy                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

completion({
    "kawre/neotab.nvim",
    lazy = true,
    cond = lambda.config.cmp.use_tabout,
    config = true,
})

--  ──────────────────────────────────────────────────────────────────────
completion({
    "hrsh7th/nvim-cmp",
    cond = lambda.config.cmp.use_cmp,
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        -- { "hrsh7th/cmp-nvim-lsp-signature-help", lazy = true },
        { "https://codeberg.org/FelipeLema/cmp-async-path", lazy = true },
        { "hrsh7th/cmp-buffer", lazy = true },
        { "hrsh7th/cmp-path", lazy = true },
        { "hrsh7th/cmp-omni", lazy = true },
        { "rcarriga/cmp-dap", lazy = true, ft = "dap" },
        { "hrsh7th/cmp-cmdline" },

        -- {
        --     "doxnit/cmp-luasnip-choice",
        --     lazy = true,
        --     config = function()
        --         require("cmp_luasnip_choice").setup({
        --             auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
        --         })
        --     end,
        -- },
        {
            "petertriho/cmp-git",
            lazy = true,
            config = function()
                require("cmp_git").setup({ filetypes = { "gitcommit", "NeogitCommitMessage" } })
            end,
        },
        { "saadparwaiz1/cmp_luasnip", lazy = true },
        { "f3fora/cmp-spell", ft = { "gitcommit", "NeogitCommitMessage", "markdown", "norg", "org" } },
        { "micangl/cmp-vimtex", ft = { "tex", "bib" }, config = true },
    },
    config = conf.cmp,
    -- config = function()
    --     local cmp_status_ok, cmp = pcall(require, "cmp")
    --     if not cmp_status_ok then
    --         return
    --     end
    --
    --     local luasnip_ok, luasnip = pcall(require, "luasnip")
    --     if not luasnip_ok then
    --         return
    --     end
    --
    --     local function copilot(fallback)
    --         local suggestion = require("copilot.suggestion")
    --         if suggestion.is_visible() then
    --             return suggestion.accept()
    --         end
    --     end
    --
    --     local kindIcons = {
    --         Text = "",
    --         Method = "",
    --         Function = "",
    --         Constructor = "",
    --         Field = "",
    --         Variable = "",
    --         Class = "ﴯ",
    --         Interface = "",
    --         Module = "",
    --         Property = "ﰠ",
    --         Unit = "",
    --         Value = "",
    --         Enum = "",
    --         Keyword = "",
    --         Snippet = "",
    --         Color = "",
    --         File = "",
    --         Reference = "",
    --         Folder = "",
    --         EnumMember = "",
    --         Constant = "",
    --         Struct = "",
    --         Event = "",
    --         Operator = "",
    --         TypeParameter = "",
    --     }
    --
    --     local check_backspace = function()
    --         local col = vim.fn.col(".") - 1
    --         return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    --     end
    --
    --     -- local types = require('cmp.types')
    --     -- local function deprioritize_snippet(entry1, entry2)
    --     --   if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
    --     --     return false
    --     --   end
    --     --   if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
    --     --     return true
    --     --   end
    --     -- end
    --
    --     local signs = {
    --         { name = "DiagnosticSignError", text = "" },
    --         { name = "DiagnosticSignWarn", text = "" },
    --         { name = "DiagnosticSignHint", text = "" },
    --         { name = "DiagnosticSignInfo", text = "" },
    --     }
    --
    --     local buffer_option = {
    --         -- Complete from all visible buffers (splits)
    --         get_bufnrs = function()
    --             if vim.b.is_big_file then
    --                 return {}
    --             end
    --             --- from all loaded buffers
    --             local bufs = {}
    --             local loaded_bufs = vim.api.nvim_list_bufs()
    --             for _, bufnr in ipairs(loaded_bufs) do
    --                 -- Don't index giant files
    --                 if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_line_count(bufnr) < 10000 then
    --                     table.insert(bufs, bufnr)
    --                 end
    --             end
    --             return bufs
    --             -- ----
    --             -- from visible bufs.
    --             -- local bufs = {}
    --             -- for _, win in ipairs(vim.api.nvim_list_wins()) do
    --             --   bufs[vim.api.nvim_win_get_buf(win)] = true
    --             -- end
    --             -- --- alternative buf.
    --             -- local alter = vim.fn.bufnr('#')
    --             -- if alter > 0 then bufs[vim.fn.bufnr('#')] = true end
    --             -- return vim.tbl_keys(bufs)
    --         end,
    --     }
    --
    --     cmp.setup({
    --         enabled = function()
    --             if vim.b.is_big_file then
    --                 return false
    --             end
    --             local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    --             if buftype == "prompt" or buftype == "neo-tree" then
    --                 return false
    --             end
    --             return true
    --         end,
    --         -- https://github.com/hrsh7th/nvim-cmp/issues/1271
    --         preselect = cmp.PreselectMode.None,
    --         snippet = {
    --             -- REQUIRED - you must specify a snippet engine
    --             expand = function(args)
    --                 luasnip.lsp_expand(args.body) -- For `luasnip` users.
    --                 -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    --             end,
    --         },
    --         mapping = {
    --             ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    --             ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    --             ["<C-e>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    --             ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    --             ["<CR>"] = cmp.mapping.confirm({
    --                 behavior = cmp.ConfirmBehavior.Replace,
    --                 -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --                 select = true,
    --             }),
    --             ["<C-n>"] = cmp.mapping(function(fallback)
    --                 if cmp.visible() then
    --                     cmp.select_next_item()
    --                 else
    --                     fallback()
    --                 end
    --             end, { "i", "s" }),
    --             ["<C-p>"] = cmp.mapping(function(fallback)
    --                 if cmp.visible() then
    --                     cmp.select_prev_item()
    --                 else
    --                     fallback()
    --                 end
    --             end, { "i", "s" }),
    --             -- Expand or confirm
    --             -- -- select next or jump snippet
    --             -- ["<Tab>"] = cmp.mapping(function(fallback)
    --             --     if cmp.visible() then
    --             --         cmp.select_next_item()
    --             --     elseif luasnip.expand_or_jumpable() then
    --             --         luasnip.expand_or_jump()
    --             --     elseif vim.b._copilot_suggestion ~= nil then
    --             --         vim.fn.feedkeys(
    --             --             vim.api.nvim_replace_termcodes(vim.fn["copilot#Accept"](), true, true, true),
    --             --             ""
    --             --         )
    --             --     else
    --             --         fallback()
    --             --     end
    --             -- end, { "i", "s" }),
    --             -- -- select prev or jump snippet
    --             -- ["<S-Tab>"] = cmp.mapping(function(fallback)
    --             --     if cmp.visible() then
    --             --         cmp.select_prev_item()
    --             --     elseif luasnip.jumpable(-1) then
    --             --         luasnip.jump(-1)
    --             --     else
    --             --         fallback()
    --             --     end
    --             -- end, { "i", "s" }),
    --
    --             ["<Tab>"] = function(fallback)
    --                 if cmp.visible() then
    --                     cmp.select_next_item()
    --                 elseif luasnip.jumpable(1) then
    --                     luasnip.jump(1)
    --                 else
    --                     require("neotab").tabout()
    --                     -- fallback()
    --                 end
    --             end,
    --             ["<c-a>"] = cmp.mapping.complete({
    --                 config = {
    --                     sources = {
    --                         { name = "cody" },
    --                     },
    --                 },
    --             }),
    --
    --             ["<S-Tab>"] = function(fallback)
    --                 if cmp.visible() then
    --                     cmp.select_prev_item()
    --                 elseif luasnip.jumpable(-1) then
    --                     luasnip.jump(-1)
    --                 else
    --                     fallback()
    --                 end
    --             end,
    --
    --             ["<C-l>"] = cmp.mapping(function(fallback)
    --                 if lambda.config.ai.sell_your_soul and lambda.config.ai.copilot.use_cmp_trigger then
    --                     copilot()
    --                     -- local copilot_keys = vim.fn["copilot#Accept"]("")
    --                     -- if copilot_keys ~= "" then
    --                     --     vim.api.nvim_feedkeys(copilot_keys, "i", false)
    --                     --     -- elseif luasnip.expandable() then
    --                     --     --     luasnip.expand()
    --                     --     -- elseif luasnip.expand_or_jumpable() then
    --                     --     --     luasnip.expand_or_jump()
    --                     --     fallback()
    --                     -- end
    --                 else
    --                 end
    --             end, {
    --                 "i",
    --                 "s",
    --             }),
    --
    --             ["<C-k>"] = cmp.mapping(function(fallback)
    --                 if luasnip.expand_or_jumpable() then
    --                     luasnip.expand_or_jump()
    --                 else
    --                     fallback()
    --                 end
    --             end, {
    --                 "i",
    --                 "s",
    --             }),
    --
    --             ["<C-j>"] = cmp.mapping(function(fallback)
    --                 if luasnip.jumpable(-1) then
    --                     luasnip.jump(-1)
    --                 else
    --                     fallback()
    --                 end
    --             end, {
    --                 "i",
    --                 "s",
    --             }),
    --         },
    --         completion = {
    --             -- completeopt = 'menu,menuone,noinsert,noselect',
    --             completeopt = "menu,menuone,noselect",
    --         },
    --         sources = {
    --             { name = "nvim_lsp", priority = 10, max_item_count = 20 },
    --             { name = "luasnip", priority = 6 },
    --             {
    --                 name = "buffer",
    --                 max_item_count = 4,
    --                 priority = 8,
    --                 keyword_length = 2,
    --                 option = buffer_option,
    --             },
    --             {
    --                 name = "neorg",
    --                 enable = true,
    --             },
    --
    --             {
    --                 name = "cmp_tabnine",
    --                 enable = (lambda.config.ai.tabnine.use_tabnine and lambda.config.ai.tabnine.use_tabnine_cmp),
    --                 priority = lambda.config.ai.tabnine.cmp.tabnine_priority,
    --             },
    --
    --             { name = "path", priority = 4, max_item_count = 4 },
    --             {
    --                 name = "cmp_overseer",
    --                 enable = true,
    --             },
    --         },
    --         signs = {
    --             active = signs,
    --         },
    --         update_in_insert = true,
    --         underline = true,
    --         severity_sort = true,
    --         window = {
    --             completion = cmp.config.window.bordered(),
    --             documentation = cmp.config.window.bordered(),
    --         },
    --         float = {
    --             focusable = false,
    --             style = "minimal",
    --             border = "rounded",
    --             source = "always",
    --             header = "",
    --             prefix = "",
    --         },
    --         formatting = {
    --             format = function(entry, vim_item)
    --                 local alias = {
    --                     -- buffer = '[Buf]',
    --                     -- path = '[Path]',
    --                     -- nvim_lsp = '[LSP]',
    --                     -- luasnip = '[LuaSnip]',
    --                     -- ultisnips = '[UltiSnips]',
    --                     -- nvim_lua = '[Lua]',
    --                     -- latex_symbols = '[Latex]',
    --                     neorg = "[Neorg]",
    --                     tabnine = "[TN]",
    --                     nvim_lua = "",
    --                     latex_symbols = "",
    --                     nvim_lsp = "λ",
    --                     luasnip = "⋗",
    --                     ultisnips = "⋗",
    --                     buffer = "Ω",
    --                     path = "🖫",
    --                 }
    --                 -- Kind icons
    --                 vim_item.kind = string.format("%s %s", kindIcons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
    --
    --                 --  I like to know my lsp names :v
    --                 if entry.source.name == "nvim_lsp" then
    --                     -- I can add '['.. lspname .. ']'
    --                     -- But decided against it, I like its look that way.
    --                     vim_item.menu = entry.source.source.client.name
    --
    --                     if entry.source.source.client.name == "jedi_language_server" then
    --                         vim_item.menu = ""
    --                     end
    --                 else
    --                     vim_item.menu = alias[entry.source.name] or entry.source.name
    --                 end
    --                 ---- This sorta of works but now the menu is too large,
    --                 ---- removed for clarity.
    --                 -- local detail = entry:get_completion_item().detail
    --                 -- if detail then
    --                 --   local item_detail = vim.split(detail, '%s', { trimempty = true })
    --                 --   vim_item.menu = vim_item.menu .. ' (' .. item_detail[1] .. ')'
    --                 -- end
    --                 return vim_item
    --             end,
    --         },
    --         sorting = {
    --             comparators = {
    --                 -- require("copilot_cmp.comparators").prioritize,
    --                 cmp.config.compare.offset,
    --                 cmp.config.compare.exact,
    --                 cmp.config.compare.score,
    --
    --                 -- deprioritize_snippet,
    --                 function(entry1, entry2)
    --                     local _, entry1_under = entry1.completion_item.label:find("^_+")
    --                     local _, entry2_under = entry2.completion_item.label:find("^_+")
    --                     entry1_under = entry1_under or 0
    --                     entry2_under = entry2_under or 0
    --                     if entry1_under > entry2_under then
    --                         return false
    --                     elseif entry1_under < entry2_under then
    --                         return true
    --                     end
    --                 end,
    --                 cmp.config.compare.recently_used,
    --                 cmp.config.compare.kind,
    --                 cmp.config.compare.sort_text,
    --                 cmp.config.compare.length,
    --                 cmp.config.compare.order,
    --                 cmp.config.compare.locality,
    --             },
    --         },
    --         performance = {
    --             max_view_items = 15,
    --             trigger_debounce_time = 150,
    --             throttle = 50,
    --             fetching_timeout = 80,
    --         },
    --     })
    --
    --     -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    --     cmp.setup.cmdline(":", {
    --         -- mapping = cmp.mapping.preset.cmdline(),
    --         completion = { completeopt = "menu,menuone,noselect" },
    --         sources = cmp.config.sources({
    --             { { name = "path" } },
    --             { { name = "cmdline" } },
    --         }),
    --     })
    --
    --     -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    --     cmp.setup.cmdline({ "/", "?" }, {
    --         completion = { completeopt = "menu,menuone,noselect" },
    --         sources = {
    --             { name = "buffer" },
    --         },
    --     })
    --
    --     vim.api.nvim_create_autocmd("CmdWinEnter", {
    --         callback = function()
    --             require("cmp").close()
    --         end,
    --     })
    --
    --     cmp.setup.filetype({ "markdown", "pandoc", "text", "latex" }, {
    --         sources = {
    --             {
    --                 name = "nvim_lsp",
    --                 keyword_length = 8,
    --                 group_index = 1,
    --                 max_item_count = 20,
    --             },
    --             { name = "luasnip" },
    --             { name = "path" },
    --             { name = "buffer" },
    --             { name = "dictionary", keyword_length = 2 },
    --             { name = "latex_symbols" },
    --         },
    --     })
    -- end,
})

completion({
    "L3MON4D3/LuaSnip", -- need to be the first to load
    build = "make install_jsregexp",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    event = "InsertEnter",
    dependencies = {
        {
            "rafamadriz/friendly-snippets",
        },
        {
            "mireq/luasnip-snippets",
            cond = true, -- Right now this is broken but i like the idea of having these snippets.
            dependencies = { "L3MON4D3/LuaSnip" },
        },
        {
            "iurimateus/luasnip-latex-snippets.nvim",
            event = "VeryLazy",
            cond = false,
            dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
            config = true,
        },
    }, -- , event = "InsertEnter"
    config = function()
        if lambda.config.use_adv_snip then
            require("modules.completion.snippets")
            require("luasnip_snippets.common.snip_utils").setup()
            require("luasnip").setup({
                -- Required to automatically include base snippets, like "c" snippets for "cpp"
                load_ft_func = require("luasnip_snippets.common.snip_utils").load_ft_func,
                ft_func = require("luasnip_snippets.common.snip_utils").ft_func,
                -- To enable auto expansin
                enable_autosnippets = true,
                -- Uncomment to enable visual snippets triggered using <c-x>
                -- store_selection_keys = '<c-x>',
            })
        end
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
        })
    end,
})
completion({
    "altermo/ultimate-autopair.nvim",
    cond = true,
    branch = "v0.6", --recommended as each new version will have breaking changes
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
        profile = "default",
        --what profile to use
        map = true,
        --whether to allow any insert map
        cmap = true, --cmap stands for cmd-line map
        --whether to allow any cmd-line map
        pair_map = true,
        --whether to allow pair insert map
        pair_cmap = true,
        --whether to allow pair cmd-line map
        multiline = true,
        --enable/disable multiline
        bs = { -- *ultimate-autopair-map-backspace-config*
            enable = true,
            map = "<bs>", --string or table
            cmap = "<bs>", --string or table
            overjumps = true,
            --(|foo) > bs > |foo
            space = true, --false, true or 'balance'
            --( |foo ) > bs > (|foo)
            --balance:
            --  Will prioritize balanced spaces
            --  ( |foo  ) > bs > ( |foo )
            indent_ignore = false,
            --(\n\t|\n) > bs > (|)
            single_delete = false,
            -- <!--|--> > bs > <!-|
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        cr = { -- *ultimate-autopair-map-newline-config*
            enable = true,
            map = "<cr>", --string or table
            autoclose = true,
            --(| > cr > (\n|\n)
            conf = {
                cond = function(fn)
                    return not fn.in_lisp()
                end,
            },
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        space = { -- *ultimate-autopair-map-space-config*
            enable = true,
            map = " ", --string or table
            cmap = " ", --string or table
            check_box_ft = { "markdown", "vimwiki", "org" },
            _check_box_ft2 = { "norg" }, --may be removed
            --+ [|] > space > + [ ]
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        space2 = { -- *ultimate-autopair-map-space2-config*
            enable = false,
            match = [[\k]],
            --what character activate
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
        },
        fastwarp = {
            multi = true,
            {},
            { faster = true, map = "<C-e>", cmap = "<C-e>" },
        },
        close = { -- *ultimate-autopair-map-close-config*
            enable = true,
            map = "<c-]>", --string or table
            cmap = "<c-]>", --string or table
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
            do_nothing_if_fail = true,
            --add a module so that if close fails
            --then a `)` will not be inserted
        },
        tabout = { -- *ultimate-autopair-map-tabout-config*
            enable = false,
            map = "<A-tab>", --string or table
            cmap = "<A-tab>", --string or table
            conf = {},
            --contains extension config
            multi = false,
            --use multiple configs (|ultimate-autopair-map-multi-config|)
            hopout = false,
            -- (|) > tabout > ()|
            do_nothing_if_fail = true,
            --add a module so that if close fails
            --then a `\t` will not be inserted
        },
        extensions = { -- *ultimate-autopair-extensions-default-config*
            cmdtype = { skip = { "/", "?", "@", "-" }, p = 100 },
            filetype = { p = 90, nft = { "TelescopePrompt" }, tree = true },
            escape = { filter = true, p = 80 },
            utf8 = { p = 70 },
            tsnode = {
                p = 60,
                separate = {
                    "comment",
                    "string",
                    "char",
                    "character",
                    "raw_string", --fish/bash/sh
                    "char_literal",
                    "string_literal", --c/cpp
                    "string_value", --css
                    "str_lit",
                    "char_lit", --clojure/commonlisp
                    "interpreted_string_literal",
                    "raw_string_literal",
                    "rune_literal", --go
                    "quoted_attribute_value", --html
                    "template_string", --javascript
                    "LINESTRING",
                    "STRINGLITERALSINGLE",
                    "CHAR_LITERAL", --zig
                    "string_literals",
                    "character_literal",
                    "line_comment",
                    "block_comment",
                    "nesting_block_comment", --d #62
                },
            },
            cond = { p = 40, filter = true },
            alpha = { p = 30, filter = false, all = false },
            suround = { p = 20 },
            fly = {
                other_char = { " " },
                nofilter = false,
                p = 10,
                undomapconf = {},
                undomap = nil,
                undocmap = nil,
                only_jump_end_pair = false,
            },
        },
        internal_pairs = { -- *ultimate-autopair-pairs-default-pairs*
            { "[", "]", fly = true, dosuround = true, newline = true, space = true },
            { "(", ")", fly = true, dosuround = true, newline = true, space = true },
            { "{", "}", fly = true, dosuround = true, newline = true, space = true },
            { '"', '"', suround = true, multiline = false },
            {
                "'",
                "'",
                suround = true,
                cond = function(fn)
                    return not fn.in_lisp() or fn.in_string()
                end,
                alpha = true,
                nft = { "tex" },
                multiline = false,
            },
            {
                "`",
                "`",
                cond = function(fn)
                    return not fn.in_lisp() or fn.in_string()
                end,
                nft = { "tex" },
                multiline = false,
            },
            { "``", "''", ft = { "tex" } },
            { "```", "```", newline = true, ft = { "markdown" } },
            { "<!--", "-->", ft = { "markdown", "html" }, space = true },
            { '"""', '"""', newline = true, ft = { "python" } },
            { "'''", "'''", newline = true, ft = { "python" } },
        },
        config_internal_pairs = { -- *ultimate-autopair-pairs-configure-default-pairs*
            --configure internal pairs
            --example:
            --{'{','}',suround=true},
        },
    },
})

completion({
    "chrisgrieser/nvim-scissors",
    -- event = "VeryLazy",
    lazy = true,
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    config = function()
        require("scissors").setup({
            snippetDir = vim.fn.stdpath("config") .. "/snippets",
            jsonFormatter = "jq",
        })
    end,
    keys = {
        {
            "<leader>se",
            function()
                require("scissors").editSnippet()
            end,
            desc = "Edit snippet",
            mode = { "n", "x" },
        },
        {
            "<leader>sa",
            function()
                require("scissors").addNewSnippet()
            end,

            desc = "Add new snippet",
            mode = { "n", "x" },
        },
    },
})

completion({
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql" },
    config = function()
        vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
    end,
})

completion({
    "vsedov/vim-sonictemplate",
    cmd = "Template",
    config = conf.vim_sonictemplate,
})
completion({
    "huggingface/hfcc.nvim",
    lazy = true,
    cmd = "StarCoder",
    opts = {
        model = "bigcode/starcoder",
        query_params = {
            max_new_tokens = 200,
        },
    },
    init = function()
        vim.api.nvim_create_user_command("StarCoder", function()
            require("hfcc.completion").complete()
        end, {})
    end,
})
