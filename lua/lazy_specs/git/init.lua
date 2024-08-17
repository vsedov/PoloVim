local conf = require("modules.git.config")
return {
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
            conf.diffview(_, conf.diffview_opts)
        end,
    },

    {
        "gitsigns.nvim",
        after = conf.gitsigns,
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
        "tmpclone-nvim",
        keys = {
            { "<leader>xc" },
            { "<leader>xo" },
            { "<leader>xr" },
        },
        cmd = {
            "TmpcloneClone",
            "TmpcloneOpen",
            "TmpcloneRemove",
        },

        after = conf.temp_clone,
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
    },

    -- -- Diff arbitrary blocks of text with each other
    { "linediff.vim", cmd = "Linediff" },
}
