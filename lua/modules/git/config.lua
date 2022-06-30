local config = {}

function config.octo()
    require("octo").setup()
    require("which-key").register({
        O = {
            name = "+octo",
            p = {
                name = "+pr",
                l = { "<Cmd>Octo pr list<CR>", "pull requests List" },
                e = { "<Cmd>Octo pr edit<CR>", "pull requests edit" },
            },
            i = {
                name = "+issues",
                l = { "<Cmd>Octo issue list<CR>", "Issue List" },
                c = { "<Cmd>Octo issue create<CR>", "Issue Create" },
                e = { "<Cmd>Octo issue edit<CR>", "Issue Edit" },
            },
        },
    }, { prefix = "<leader>" })
end

function config.gh()
    require("litee.lib").setup()

    local wk = require("which-key")
    wk.register({
        g = {
            name = "+Git",
            h = {
                name = "+Github",
                c = {
                    name = "+Commits",
                    c = { "<cmd>GHCloseCommit<cr>", "Close" },
                    e = { "<cmd>GHExpandCommit<cr>", "Expand" },
                    o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
                    p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
                    z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
                },
                i = {
                    name = "+Issues",
                    p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
                },
                l = {
                    name = "+Litee",
                    t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
                },
                r = {
                    name = "+Review",
                    b = { "<cmd>GHStartReview<cr>", "Begin" },
                    c = { "<cmd>GHCloseReview<cr>", "Close" },
                    d = { "<cmd>GHDeleteReview<cr>", "Delete" },
                    e = { "<cmd>GHExpandReview<cr>", "Expand" },
                    s = { "<cmd>GHSubmitReview<cr>", "Submit" },
                    z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
                },
                p = {
                    name = "+Pull Request",
                    c = { "<cmd>GHClosePR<cr>", "Close" },
                    d = { "<cmd>GHPRDetails<cr>", "Details" },
                    e = { "<cmd>GHExpandPR<cr>", "Expand" },
                    o = { "<cmd>GHOpenPR<cr>", "Open" },
                    p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
                    r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
                    t = { "<cmd>GHOpenToPR<cr>", "Open To" },
                    z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
                },
                t = {
                    name = "+Threads",
                    c = { "<cmd>GHCreateThread<cr>", "Create" },
                    n = { "<cmd>GHNextThread<cr>", "Next" },
                    t = { "<cmd>GHToggleThread<cr>", "Toggle" },
                },
            },
        },
    }, { prefix = "<leader>" })
    require("litee.gh").setup()
end

function config.worktree()
    local function git_worktree(arg)
        if arg == "create" then
            require("telescope").extensions.git_worktree.create_git_worktree()
        else
            require("telescope").extensions.git_worktree.git_worktrees()
        end
    end

    require("git-worktree").setup({})
    vim.api.nvim_create_user_command("Worktree", "lua require'modules.git.config'.worktree()(<f-args>)", {
        nargs = "*",
        complete = function()
            return { "create" }
        end,
    })

    local Worktree = require("git-worktree")
    Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
            print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
        end

        if op == Worktree.Operations.Create then
            print("Create worktree " .. metadata.path)
        end

        if op == Worktree.Operations.Delete then
            print("Delete worktree " .. metadata.path)
        end
    end)
    return { git_worktree = git_worktree }
end

function config.diffview()
    local cb = require("diffview.config").diffview_callback
    require("diffview").setup({
        diff_binaries = false, -- show diffs for binaries
        use_icons = true, -- requires nvim-web-devicons
        enhanced_diff_hl = false, -- see ':h diffview-config-enhanced_diff_hl'
        signs = { fold_closed = "", fold_open = "" },
        file_panel = {
            position = "left", -- one of 'left', 'right', 'top', 'bottom'
            width = 35, -- only applies when position is 'left' or 'right'
            height = 10, -- only applies when position is 'top' or 'bottom'
        },
        key_bindings = {
            -- the `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a diffview.
            view = {
                ["<tab>"] = cb("select_next_entry"), -- open the diff for the next file
                ["<s-tab>"] = cb("select_prev_entry"), -- open the diff for the previous file
                ["<leader>e"] = cb("focus_files"), -- bring focus to the files panel
                ["<leader>b"] = cb("toggle_files"), -- toggle the files panel.
            },
            file_panel = {
                ["j"] = cb("next_entry"), -- bring the cursor to the next file entry
                ["<down>"] = cb("next_entry"),
                ["k"] = cb("prev_entry"), -- bring the cursor to the previous file entry.
                ["<up>"] = cb("prev_entry"),
                ["<cr>"] = cb("select_entry"), -- open the diff for the selected entry.
                ["o"] = cb("select_entry"),
                ["r"] = cb("refresh_files"), -- update stats and entries in the file list.
                ["<tab>"] = cb("select_next_entry"),
                ["<s-tab>"] = cb("select_prev_entry"),
                ["<leader>e"] = cb("focus_files"),
                ["<leader>b"] = cb("toggle_files"),
            },
        },
    })
end
function config.gitsigns()
    if not packer_plugins["plenary.nvim"].loaded then
        require("packer").loader("plenary.nvim")
    end
    local gitsigns = require("gitsigns")

    local line = vim.fn.line

    local function wrap(fn, ...)
        local args = { ... }
        local nargs = select("#", ...)
        return function()
            fn(unpack(args, nargs))
        end
    end
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

        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", wrap(gitsigns.stage_hunk, { line("."), line("v") }))
        map("v", "<leader>hr", wrap(gitsigns.reset_hunk, { line("."), line("v") }))
        map("n", "<leader>hs", gitsigns.stage_buffer)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", wrap(gitsigns.blame_line, { full = true }))
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
        map("n", "<leader>hd", wrap(gitsigns.diffthis, "~"))
        map("n", "<leader>td", gitsigns.toggle_deleted)

        map("n", "<leader>hq", wrap(gitsigns.setqflist, "all"))
        map("n", "<leader>hq", wrap(gitsigns.setqflist))

        map({ "o", "x" }, "ih", ":<c-u>gitsigns select_hunk<cr>")
    end
    gitsigns.setup({
        debug_mode = true,
        max_file_length = 1000000000,
        signs = {
            add = { show_count = false, text = "│" },
            change = { show_count = false, text = "│" },
            delete = { show_count = true, text = "ﬠ" },
            topdelete = { show_count = true, text = "ﬢ" },
            changedelete = { show_count = true, text = "┊" },
        },
        on_attach = on_attach,
        preview_config = {
            border = "rounded",
        },
        current_line_blame = true,
        current_line_blame_formatter = " : <author> | <author_time:%y-%m-%d> | <summary>",
        current_line_blame_formatter_opts = {
            relative_time = true,
        },
        current_line_blame_opts = {
            delay = 0,
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
        _refresh_staged_on_update = false,
        watch_gitdir = { interval = 1000, follow_files = true },
        sign_priority = 6,
        status_formatter = nil, -- use default
        update_debounce = 0,
        word_diff = true,
        _threaded_diff = true, -- no clue what this does
        diff_opts = { internal = true },
    })
end
function config.neogit()
    vim.cmd([[packadd diffview.nvim]])
    require("neogit").setup({
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        auto_refresh = true,
        disable_builtin_notifications = true,
        use_magit_keybindings = true,
        signs = {
            -- { closed, opened }
            section = { ">", "v" },
            item = { ">", "v" },
            hunk = { "", "" },
        },
        integrations = {
            diffview = true,
        },
        -- override/add mappings
        mappings = {
            -- modify status buffer mappings
            status = {
                -- adds a mapping with "b" as key that does the "branchpopup" command
                ["b"] = "branchpopup",
                -- removes the default mapping of "s"
            },
        },
    })
end
function config.gitlinker()
    require("gitlinker").setup()
end

function config.vgit()
    -- use this as a diff tool (faster than Diffview)
    -- there are overlaps with gitgutter. following are nice features
    require("vgit").setup({
        keymaps = {
            -- ["n <leader>ga"] = "actions", -- show all commands in telescope
            -- ["n <leader>ba"] = "buffer_gutter_blame_preview", -- show all blames
            -- ["n <leader>bp"] = "buffer_blame_preview", -- buffer diff
            -- ["n <leader>bh"] = "buffer_history_preview", -- buffer commit history DiffviewFileHistory
            -- ["n <leader>gp"] = "buffer_staged_diff_preview", -- diff for staged changes
            -- ["n <leader>pd"] = "project_diff_preview", -- diffview is slow
        },
        settings = {
            live_gutter = {
                enabled = false,
                edge_navigation = false, -- This allows users to navigate within a hunk
            },
            scene = {
                diff_preference = "unified",
            },
            live_blame = {
                enabled = false,
            },
            authorship_code_lens = {
                enabled = false,
            },
            diff_preview = {
                keymaps = {
                    buffer_stage = "S",
                    buffer_unstage = "U",
                    buffer_hunk_stage = "s",
                    buffer_hunk_unstage = "u",
                    toggle_view = "t",
                },
            },
        },
    })
    require("packer").loader("telescope.nvim")
end

function config.git_conflict()
    require("git-conflict").setup()
end

function config.git_fixer()
    -- defaults shown --
    require("fixer").setup({
        stage_hunk_action = function()
            require("gitsigns").stage_hunk()
        end,
        undo_stage_hunk_action = function()
            require("gitsigns").undo_stage_hunk()
        end,
        refresh_hunks_action = function()
            require("gitsigns").refresh()
        end,
    })
    vim.cmd([[command! -nargs=*  fixup lua require('fixer/picker/telescope').commit{hunk_only=true, type="fixup"} ]])
    vim.cmd([[command! -nargs=*  ammend lua require('fixer/picker/telescope').commit{type="amend"} ]])
end
return config
