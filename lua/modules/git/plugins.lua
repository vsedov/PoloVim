local conf = require("modules.git.config")
local git = require("core.pack").package
git({
    "pwntester/octo.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    config = true,
})

git({
    "rawnly/gist.nvim",
    cmd = { "CreateGist" },
})

git({
    "wintermute-cell/gitignore.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    cmd = "Gitignore",
})

git({
    "sindrets/diffview.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
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
    opts = conf.diffview_opts(),
    config = conf.diffview,
})

git({
    "lewis6991/gitsigns.nvim",
    config = conf.gitsigns,
    dependencies = { "nvim-lua/plenary.nvim" },
    module = "gitsigns",
    lazy = true,
})

git({
    "NeogitOrg/neogit", -- keys = {
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
    cmd = { "Neogit" },
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
    },
})

git({
    "akinsho/git-conflict.nvim",
    cmd = {
        "GitConflictChooseOurs",
        "GitConflictChooseTheirs",
        "GitConflictChooseBoth",
        "GitConflictChooseNone",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
        "GitConflictListQf",
    },

    lazy = true,
    opts = { disable_diagnostics = true },
})

-- return git
-- @usage | this is to clone repos, which is interesting
-- you can remove and add repos with this, or temp ones that you can mess
-- around with
git({
    "danielhp95/tmpclone-nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
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

    config = conf.temp_clone,
})
git({
    "2kabhishek/co-author.nvim",
    lazy = true,
    cmd = {
        "GitCoAuthors",
    },
})

git({
    "linrongbin16/gitlinker.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
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
    config = true,
})

-- -- Diff arbitrary blocks of text with each other
git({ "AndrewRadev/linediff.vim", cmd = "Linediff" })
