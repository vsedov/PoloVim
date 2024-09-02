return {
    -- UI
    -- SEARCH
    {
        "ssr.nvim",
        opt = true,
        after = function()
            require("ssr").setup({
                min_width = 50,
                min_height = 5,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_all = "<cr>",
                },
            })
        end,
    },
    -- EDITOR
    -- treesj = {rev = "scm", opt = true}
    -- "dial.nvim" = {rev = "0.4.0", opt =true}
    -- "comment-box.nvim" = {rev = "1.0.2", opt = true}
    -- "comment.nvim" = {rev = "0.8.0", opt = true}
    -- # sibling-swap.nvim
    {
        "treesj",
        keys = {
            {
                "<leader>j",
                ":TSJToggle<cr>",
                desc = "TSJToggle",
                silent = true,
            },
        },
        after = function()
            local opts = {
                use_default_keymaps = false,
                check_syntax_error = true,
                max_join_length = 9999999,
            }
            require("treesj").setup(opts)
        end,
    },
    {
        "dial.nvim",
        keys = {
            { "<c-a>", mode = "n" },
            { "<c-x>", mode = "n" },
            { "g<c-a>", mode = "n" },
            { "g<c-x>", mode = "n" },
            { "<c-a>", mode = "v" },
            { "<c-x>", mode = "v" },
            { "g<c-a>", mode = "v" },
            { "g<c-x>", mode = "v" },
        },
        after = require("plugins.editor.config").dial,
    },
    {
        "comment-box.nvim",
        opt = true,
        after = require("plugins.editor.config").comment_box,
    },
    {
        "comment.nvim",
        keys = {
            {
                "g",
                mode = { "v", "n" },
            },
            {
                "gcc",
                mode = "v",
            },
            {
                "gc",
                mode = "v",
            },
        },
        after = require("plugins.editor.config").comment,
    },
    -- "telescope.nvim",
    -- "telescope-fzf-native.nvim",
    -- "telescope-file-browser.nvim",
    -- "telescope-frecency.nvim",
    -- "telescope-sg",
    -- "telescope-zoxide",
    -- "telescope-live-grep-args.nvim",
    -- "telescope-egrepify.nvim",
    -- "telescope-bookmarks.nvim",
    -- "smart-open.nvim",
    -- "easypick.nvim",
    {
        "easypic.nvim",
        cmd = "Easypick",

        after = function()
            local easypick = require("easypick")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local base_branch = "main"
            local list = [[
    << EOF
    :Easypick changed_files
    :Easypick conflicts
    :Easypick config_files
    EOF
    ]]
            local custom_pickers = {
                {
                    name = "ls",
                    command = "ls",
                    previewer = easypick.previewers.default(),
                },
                {
                    name = "changed_files",
                    command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
                    previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
                },
                {
                    name = "conflicts",
                    command = "git diff --name-only --diff-filter=U --relative",
                    previewer = easypick.previewers.file_diff(),
                },
                {
                    name = "config_files",
                    command = "fd -i -t=f --search-path=" .. vim.fn.expand("$NVIM_CONFIG"),
                    previewer = easypick.previewers.default(),
                },
                {
                    name = "command_palette",
                    command = "cat " .. list,
                    action = easypick.actions.run_nvim_command,
                    opts = require("telescope.themes").get_dropdown({}),
                },
            }

            easypick.setup({ pickers = custom_pickers })
        end,
    },
}
