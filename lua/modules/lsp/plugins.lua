local conf = require("modules.lsp.config")
local lsp = require("core.pack").package

--  TODO: (vsedov) (20:18:05 - 03/01/23): Figure out how to properly lazy load this scondif, as there
--  are a few issues with this right now and im not sure why this does not work.
lsp({
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "VeryLazy",
    init = conf.nvim_lsp_setup,
    config = conf.nvim_lsp,
})

lsp({
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "poljar/typos.nvim", config = true },

        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        require("mason-null-ls").setup({
            automatic_installation = false,
        })
    end,
})
lsp({
    "williamboman/mason.nvim",
    -- event = "VeryLazy",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
    },
    config = conf.mason_setup,
})

lsp({ "ii14/lsp-command", lazy = true, cmd = { "Lsp" } })

lsp({
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    dependencies = "nvim-lspconfig",
    config = conf.clangd,
})

lsp({ "folke/neodev.nvim", lazy = true, ft = "lua", dependencies = "neovim/nvim-lspconfig", config = conf.luadev })

lsp({ "lewis6991/hover.nvim", lazy = true, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    cmd = { "Lspsaga" },
    lazy = true,
    config = conf.saga,
    dependencies = "neovim/nvim-lspconfig",
})

lsp({
    "ray-x/lsp_signature.nvim",
    lazy = true,
    event = "VeryLazy",
    config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    lazy = true,
    keys = {
        "\\;",
    },
    config = function()
        require("actions-preview").setup({
            -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
            diff = {
                ctxlen = 3,
            },
            backend = { "telescope", "nui" },
            -- options for telescope.nvim: https://github.com/nvim-telescope/telescope.nvim#themes
            telescope = require("telescope.themes").get_dropdown(),
        })

        vim.keymap.set({ "v", "n" }, "\\;", require("actions-preview").code_actions)
    end,
})

lsp({
    "joechrisellis/lsp-format-modifications.nvim",
    lazy = true,
})

lsp({
    "smjonas/inc-rename.nvim",
    lazy = true,
    opts = { hl_group = "Visual", preview_empty_name = true },
    keys = {
        {
            "<leader>gr",
            function()
                return string.format(":IncRename %s", vim.fn.expand("<cword>"))
            end,
            expr = true,
            silent = false,
            desc = "lsp: incremental rename",
        },
    },
})

lsp({ "SmiteshP/nvim-navic", event = "VeryLazy", after = "nvim-lspconfig", config = conf.navic })

lsp({ "cseickel/diagnostic-window.nvim", cmd = "DiagWindowShow", dependencies = { "MunifTanjim/nui.nvim" } })
lsp({

    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    config = conf.vista,
})

--  TODO: (vsedov) (02:14:46 - 02/06/23): This might not be neaded due to glance
lsp({
    "rmagatti/goto-preview",
    lazy = true,
    config = conf.goto_preview,
})

lsp({
    "dnlhc/glance.nvim",
    lazy = true,
    cmd = "Glance",
    config = conf.glance,
})

lsp({
    "SmiteshP/nvim-navbuddy",
    lazy = true,
    cond = lambda.config.lsp.use_navbuddy,
    dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "numToStr/Comment.nvim", -- Optional
        "nvim-telescope/telescope.nvim", -- Optional
    },
    opts = { lsp = { auto_attach = false } },
})

lsp({
    "chikko80/error-lens.nvim",
    cond = lambda.config.lsp.use_error_lens,
    lazy = true,
    event = "LspAttach",
    config = true,
})

lsp({
    "santigo-zero/right-corner-diagnostics.nvim",
    cond = lambda.config.lsp.use_rcd,
    event = "LspAttach",
    config = true,
}) -- this could be  casing lag, im not sure

lsp({
    "VidocqH/lsp-lens.nvim",
    lazy = true,
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    opts = {
        enable = false, -- enable through lsp
        include_declaration = true, -- Reference include declaration
        sections = { -- Enable / Disable specific request
            definition = true,
            references = true,
            implementation = true,
        },
        ignore_filetype = {
            "prisma",
        },
    },
})

lsp({
    "KostkaBrukowa/definition-or-references.nvim",
    lazy = true,
    config = function()
        local make_entry = require("telescope.make_entry")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")

        local function filter_entries(results)
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_line = vim.api.nvim_win_get_cursor(0)[1]

            local function should_include_entry(entry)
                -- if entry is on the same line
                if entry.filename == current_file and entry.lnum == current_line then
                    return false
                end

                -- if entry is closing tag - just before it there is a closing tag syntax '</'
                if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == "</" then
                    return false
                end

                return true
            end

            return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
        end

        local function handle_references_response(result)
            local locations = vim.lsp.util.locations_to_items(result, "utf-8")
            local filtered_entries = filter_entries(locations)
            pickers
                .new({}, {
                    prompt_title = "LSP References",
                    finder = finders.new_table({
                        results = filtered_entries,
                        entry_maker = make_entry.gen_from_quickfix(),
                    }),
                    previewer = require("telescope.config").values.qflist_previewer({}),
                    sorter = require("telescope.config").values.generic_sorter({}),
                    push_cursor_on_edit = true,
                    push_tagstack_on_edit = true,
                    initial_mode = "normal",
                })
                :find()
        end

        require("definition-or-references").setup({
            on_references_result = handle_references_response,
        })
    end,
})
lsp({
    "lvimuser/lsp-inlayhints.nvim",
    cond = lambda.config.lsp.use_inlay_hints,
    lazy = true,
    branch = "anticonceal",
    init = function()
        if lambda.config.lsp.use_inlay_hints then
            lambda.augroup("InlayHintsSetup", {
                {
                    event = "LspAttach",
                    command = function(args)
                        local id = vim.tbl_get(args, "data", "client_id") --[[@as lsp.Client]]
                        if not id then
                            return
                        end
                        local client = vim.lsp.get_client_by_id(id)
                        require("lsp-inlayhints").on_attach(client, args.buf)
                    end,
                },
            })
            lambda.highlight.plugin("inlayHints", { { LspInlayHint = { inherit = "Comment", italic = false } } })
        end
    end,
    opts = {
        inlay_hints = { priority = vim.highlight.priorities.user + 1 },
    },
})

lsp({
    "neovim/nvimdev.nvim",
    lazy = true,
    ft = "lua",
    config = conf.nvimdev,
})
