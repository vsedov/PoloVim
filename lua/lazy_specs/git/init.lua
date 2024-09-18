return {
    {
        "octo.nvim",
        cmd = "Octo",
        after = function()
            require("octo").setup({})
        end,
    },
    {
        "gist.nvim",
        cmd = { "CreateGist" },
    },

    {
        "gitignore.nvim",
        cmd = "Gitignore",
    },

    {
        "diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
        },
        keys = {
            { "<localleader>gd", "<Cmd>DiffviewOpen<CR>", desc = "diffview: open", mode = "n" },
            { "gh", [[:'<'>DiffviewFileHistory<CR>]], desc = "diffview: file history", mode = "v" },
            {
                "<localleader>gh",
                "<Cmd>DiffviewFileHistory<CR>",
                desc = "diffview: file history",
                mode = "n",
            },
        },
        after = function()
            opts = {
                default_args = { DiffviewFileHistory = { "%" } },
                enhanced_diff_hl = true,
                hooks = {
                    diff_buf_read = function()
                        local opt = vim.opt_local
                        opt.wrap, opt.list, opt.relativenumber = false, false, false
                        opt.colorcolumn = ""
                    end,
                },
                keymaps = {
                    view = { q = "<Cmd>DiffviewClose<CR>" },
                    file_panel = { q = "<Cmd>DiffviewClose<CR>" },
                    file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
                },
            }
            lambda.highlight.plugin("diffview", {
                { DiffAddedChar = { bg = "NONE", fg = { from = "diffAdded", attr = "bg", alter = 0.3 } } },
                { DiffChangedChar = { bg = "NONE", fg = { from = "diffChanged", attr = "bg", alter = 0.3 } } },
                { DiffviewStatusAdded = { link = "DiffAddedChar" } },
                { DiffviewStatusModified = { link = "DiffChangedChar" } },
                { DiffviewStatusRenamed = { link = "DiffChangedChar" } },
                { DiffviewStatusUnmerged = { link = "DiffChangedChar" } },
                { DiffviewStatusUntracked = { link = "DiffAddedChar" } },
            })
            require("diffview").setup(opts)
        end,
    },

    {
        "gitsigns.nvim",
        after = function()
            local gitsigns = require("gitsigns")
            local cwd = vim.fn.getcwd()
            local function on_attach(bufnr)
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(gitsigns.next_hunk)
                    return "<ignore>"
                end, { expr = true })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(gitsigns.prev_hunk)
                    return "<ignore>"
                end, { expr = true })

                -- map("n", "<leader>tb", gitsigns.toggle_current_line_blame)

                -- map({ "o", "x" }, "ih", ":<c-u>gitsigns select_hunk<cr>")
            end

            gitsigns.setup({
                debug_mode = false,
                max_file_length = 1000000000,
                signs = {
                    add = { hl = "GitSignsAdd", text = "▌" },
                    change = { hl = "GitSignsChange", text = "▌" },
                    delete = { hl = "GitSignsDelete", text = "▌" },
                    topdelete = { hl = "GitSignsDelete", text = "▌" },
                    changedelete = { hl = "GitSignsChange", text = "▌" },
                },
                on_attach = on_attach,
                preview_config = {
                    border = lambda.style.border.type_0,
                },
                current_line_blame = not cwd:match("personal") and not cwd:match("nvim"),
                current_line_blame_formatter = " : <author> | <author_time:%d-%m-%y> | <summary>",
                current_line_blame_formatter_opts = {
                    relative_time = true,
                },
                current_line_blame_opts = {
                    delay = 50,
                },
                count_chars = {
                    "⒈",
                    "⒉",
                    "⒊",
                    "⒋",
                    "⒌",
                    "⒍",
                    "⒎",
                    "⒏",
                    "⒐",
                    "⒑",
                    "⒒",
                    "⒓",
                    "⒔",
                    "⒕",
                    "⒖",
                    "⒗",
                    "⒘",
                    "⒙",
                    "⒚",
                    "⒛",
                },
                update_debounce = 50,
                _threaded_diff = true,
                word_diff = true,
            })
        end,
    },

    {
        "neogit", -- keys = {
        cmd = { "Neogit" },
        after = function()
            opts = {
                telescope_sorter = function()
                    return require("telescope").extensions.fzf.native_fzf_sorter()
                end,
                signs = {
                    section = { "", "" }, -- "", ""
                    item = { "▸", "▾" },
                    hunk = { "樂", "" },
                },
                integrations = {
                    telescope = true,
                    diffview = true,
                },
            }
            require("neogit").setup(opts)
        end,
    },

    {
        "git-conflict.nvim",
        cmd = {
            "GitConflictChooseOurs",
            "GitConflictChooseTheirs",
            "GitConflictChooseBoth",
            "GitConflictChooseNone",
            "GitConflictNextConflict",
            "GitConflictPrevConflict",
            "GitConflictListQf",
        },
    },
    {
        "co-author.nvim",
        cmd = {
            "GitCoAuthors",
        },
    },

    {
        "gitlinker.nvim",
        keys = {
            {
                "<leader>gl",
                mode = { "v", "n" },
            },
            {
                "<leader>gL",
                mode = { "v", "n" },
            },
        },
        after = function()
            require("gitlinker").setup()
        end,
    },

    -- -- Diff arbitrary blocks of text with each other
    { "linediff.vim", cmd = "Linediff" },
}
