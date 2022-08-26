local config = {}

-- TODO(vsedov) (03:11:32 - 20/08/22): Make sure that hydra modules
-- are loaded based on this ,
function config.git_setup(package_name)
    lambda.augroup("InGit", {
        event = { "BufAdd", "VimEnter" },
        pattern = "*",
        command = function()
            local function onexit(code, _)
                if code == 0 then
                    vim.schedule(function()
                        require("packer").loader(package_name)
                    end)
                end
            end
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            if lines ~= { "" } then
                vim.loop.spawn("git", {
                    args = {
                        "ls-files",
                        "--error-unmatch",
                        vim.fn.expand("%"),
                    },
                }, onexit)
            end
        end,
    })
end

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
    vim.cmd([[packadd litee.nvim]])
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
    -- vim.cmd[[packadd telescope.nvim]]
    -- require("telescope").load_extension("git_worktree")
end

function config.diffview()
local actions = require("diffview.actions")

require("diffview").setup({
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" },      -- The git executable followed by default args.
  use_icons = true,         -- Requires nvim-web-devicons
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = {                      -- See ':h diffview-config-win_config'
      position = "left",
      width = 35,
    },
  },
  file_history_panel = {
    log_options = {   -- See ':h diffview-config-log_options'
      single_file = {
        diff_merges = "combined",
      },
      multi_file = {
        diff_merges = "first-parent",
      },
    },
    win_config = {    -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
    },
  },
  commit_log_panel = {
    win_config = {},  -- See ':h diffview-config-win_config'
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      ["<tab>"]      = actions.select_next_entry, -- Open the diff for the next file
      ["<s-tab>"]    = actions.select_prev_entry, -- Open the diff for the previous file
      ["gf"]         = actions.goto_file,         -- Open the file in a new split in the previous tabpage
      ["<C-w><C-f>"] = actions.goto_file_split,   -- Open the file in a new split
      ["<C-w>gf"]    = actions.goto_file_tab,     -- Open the file in a new tabpage
      ["<leader>e"]  = actions.focus_files,       -- Bring focus to the files panel
      ["<leader>b"]  = actions.toggle_files,      -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
      ["<down>"]        = actions.next_entry,
      ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
      ["<up>"]          = actions.prev_entry,
      ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
      ["o"]             = actions.select_entry,
      ["<2-LeftMouse>"] = actions.select_entry,
      ["-"]             = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
      ["S"]             = actions.stage_all,          -- Stage all entries.
      ["U"]             = actions.unstage_all,        -- Unstage all entries.
      ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
      ["R"]             = actions.refresh_files,      -- Update stats and entries in the file list.
      ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
      ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
      ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
      ["<tab>"]         = actions.select_next_entry,
      ["<s-tab>"]       = actions.select_prev_entry,
      ["gf"]            = actions.goto_file,
      ["<C-w><C-f>"]    = actions.goto_file_split,
      ["<C-w>gf"]       = actions.goto_file_tab,
      ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
      ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
      ["<leader>e"]     = actions.focus_files,
      ["<leader>b"]     = actions.toggle_files,
    },
    file_history_panel = {
      ["g!"]            = actions.options,          -- Open the option panel
      ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
      ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
      ["L"]             = actions.open_commit_log,
      ["zR"]            = actions.open_all_folds,
      ["zM"]            = actions.close_all_folds,
      ["j"]             = actions.next_entry,
      ["<down>"]        = actions.next_entry,
      ["k"]             = actions.prev_entry,
      ["<up>"]          = actions.prev_entry,
      ["<cr>"]          = actions.select_entry,
      ["o"]             = actions.select_entry,
      ["<2-LeftMouse>"] = actions.select_entry,
      ["<c-b>"]         = actions.scroll_view(-0.25),
      ["<c-f>"]         = actions.scroll_view(0.25),
      ["<tab>"]         = actions.select_next_entry,
      ["<s-tab>"]       = actions.select_prev_entry,
      ["gf"]            = actions.goto_file,
      ["<C-w><C-f>"]    = actions.goto_file_split,
      ["<C-w>gf"]       = actions.goto_file_tab,
      ["<leader>e"]     = actions.focus_files,
      ["<leader>b"]     = actions.toggle_files,
    },
    option_panel = {
      ["<tab>"] = actions.select_entry,
      ["q"]     = actions.close,
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

        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)

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
        current_line_blame_formatter = " : <author> | <author_time:%d-%m-%y> | <summary>",
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

    vim.keymap.set("n", "<localleader>gs", function()
        neogit.open()
    end, {})
    vim.keymap.set("n", "<localleader>gc", function()
        neogit.open({ "commit" }, {})
    end)
    vim.keymap.set("n", "<localleader>gl", neogit.popups.pull.create, {})
    vim.keymap.set("n", "<localleader>gp", neogit.popups.push.create, {})
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
return config
