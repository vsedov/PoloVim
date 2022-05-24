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
    require("litee.gh").setup()
end

function config.worktree()
    function git_worktree(arg)
        if arg == "create" then
            require("telescope").extensions.git_worktree.create_git_worktree()
        else
            require("telescope").extensions.git_worktree.git_worktrees()
        end
    end

    require("git-worktree").setup({})
    vim.api.nvim_create_user_command("Worktree", "lua git_worktree(<f-args>)", {
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
end

function config.diffview()
    local cb = require("diffview.config").diffview_callback
    require("diffview").setup({
        diff_binaries = false, -- Show diffs for binaries
        use_icons = true, -- Requires nvim-web-devicons
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        signs = { fold_closed = "", fold_open = "" },
        file_panel = {
            position = "left", -- One of 'left', 'right', 'top', 'bottom'
            width = 35, -- Only applies when position is 'left' or 'right'
            height = 10, -- Only applies when position is 'top' or 'bottom'
        },
        key_bindings = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            view = {
                ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
                ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
                ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
                ["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
            },
            file_panel = {
                ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
                ["<down>"] = cb("next_entry"),
                ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
                ["<up>"] = cb("prev_entry"),
                ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
                ["o"] = cb("select_entry"),
                ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
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

    --  TODO(lewis6991): doesn't work properly
    vim.keymap.set("n", "M", "<cmd>Gitsigns debug_messages<cr>")
    vim.keymap.set("n", "m", "<cmd>Gitsigns dump_cache<cr>")

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
            return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(gitsigns.prev_hunk)
            return "<Ignore>"
        end, { expr = true })

        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", wrap(gitsigns.stage_hunk, { line("."), line("v") }))
        map("v", "<leader>hr", wrap(gitsigns.reset_hunk, { line("."), line("v") }))
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", wrap(gitsigns.blame_line, { full = true }))
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
        map("n", "<leader>hD", wrap(gitsigns.diffthis, "~"))
        map("n", "<leader>td", gitsigns.toggle_deleted)

        map("n", "<leader>hQ", wrap(gitsigns.setqflist, "all"))
        map("n", "<leader>hq", wrap(gitsigns.setqflist))

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
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
        current_line_blame_formatter = " : <author> | <author_time:%Y-%m-%d> | <summary>",
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
        status_formatter = nil, -- Use default
        update_debounce = 0,
        word_diff = true,
        _threaded_diff = true, -- no clue what this does
        diff_opts = { internal = true },
    })
end
function config.neogit()
    require("neogit").setup({
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        auto_refresh = true,
        disable_builtin_notifications = true,
        use_magit_keybindings = true,
        signs = {
            -- { CLOSED, OPENED }
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
                -- Adds a mapping with "B" as key that does the "BranchPopup" command
                ["B"] = "BranchPopup",
                -- Removes the default mapping of "s"
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
            ["n <leader>ga"] = "actions", -- show all commands in telescope
            ["n <leader>ba"] = "buffer_gutter_blame_preview", -- show all blames
            ["n <leader>bp"] = "buffer_blame_preview", -- buffer diff
            ["n <leader>bh"] = "buffer_history_preview", -- buffer commit history DiffviewFileHistory
            ["n <leader>gp"] = "buffer_staged_diff_preview", -- diff for staged changes
            ["n <leader>pd"] = "project_diff_preview", -- diffview is slow
        },
        controller = {
            hunks_enabled = false, -- gitsigns
            blames_enabled = false,
            diff_strategy = "index",
            diff_preference = "vertical",
            predict_hunk_signs = true,
            predict_hunk_throttle_ms = 500,
            predict_hunk_max_lines = 50000,
            blame_line_throttle_ms = 250,
            show_untracked_file_signs = true,
            action_delay_ms = 500,
        },
    })
    require("packer").loader("telescope.nvim")
    -- print('vgit')
    -- require("vgit")._buf_attach()
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
    vim.cmd([[command! -nargs=*  FixUp lua require('fixer/picker/telescope').commit{hunk_only=true, type="fixup"} ]])
    vim.cmd([[command! -nargs=*  Ammend lua require('fixer/picker/telescope').commit{type="amend"} ]])
end
return config
