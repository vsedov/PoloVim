local config = {}

function config.octo()
    require("octo").setup()
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
    vim.api.nvim_create_user_command("Worktree", "lua require'modules.git.config'.worktree(<f-args>)", {
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
    -- vim.cmd[[ Lazy load telescope.nvim]]
    -- require("telescope").load_extension("git_worktree")
end
function config.diffview_opts()
    return {
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
end

function config.diffview(_, opts)
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
end

function config.gitsigns()
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
        _extmark_signs = true,
        _threaded_diff = true,
        word_diff = true,
    })
end

function config.neogit()
    vim.cmd([[Lazy load diffview.nvim]])
    lambda.highlight.plugin("neogit", { -- NOTE: highlights must be set AFTER neogit's setup
        { NeogitDiffAdd = { link = "DiffAdd" } },
        { NeogitDiffDelete = { link = "DiffDelete" } },
        { NeogitDiffAddHighlight = { link = "DiffAdd" } },
        { NeogitDiffDeleteHighlight = { link = "DiffDelete" } },
        { NeogitDiffContextHighlight = { link = "NormalFloat" } },
        { NeogitHunkHeader = { link = "TabLine" } },
        { NeogitHunkHeaderHighlight = { link = "DiffText" } },
    })
    local neogit = require("neogit")
    pcall(require("plenary"))
    neogit.setup({
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false, -- nah i like this
        disable_hint = false,
        auto_refresh = true,
        disable_builtin_notifications = true,
        use_magit_keybindings = true,
        disable_insert_on_commit = false,
        signs = {
            section = { "", "" }, -- "", ""
            item = { "▸", "▾" },
            hunk = { "樂", "" },
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
end

function config.git_conflict()
    require("git-conflict").setup()
end
-- TODO(vsedov) (21:49:12 - 23/08/22): Add this to Hydra
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

    lambda.command("Fixup", function()
        require("fixer/picker/telescope").commit({ hunk_only = true, type = "fixup" })
    end, { bang = true })

    lambda.command("Amend", function()
        require("fixer/picker/telescope").commit({ type = "amend" })
    end, { bang = true })

    lambda.command("Squash", function()
        require("fixer/picker/telescope").commit({ type = "squash" })
    end, { bang = true })
    lambda.command("Reword", function()
        require("fixer/picker/telescope").commit({ type = "reword" })
    end, { bang = true })

    lambda.command("Commit", function()
        require("fixer").commit_hunk()
    end, {})
end

function config.temp_clone()
    require("tmpclone").setup()
    vim.keymap.set("n", "<leader>xc", [[<cmd>TmpcloneClone<cr>]], {})
    vim.keymap.set("n", "<leader>xo", [[<cmd>TmpcloneOpen<cr>]], {})
    vim.keymap.set("n", "<leader>xr", [[<cmd>TmpcloneRemove]], {})
end

function config.gitlens()
    require("gitlens").setup({
        ui = {
            username = "vsedov",
        },
    })
end

return config
