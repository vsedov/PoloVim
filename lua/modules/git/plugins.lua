local conf = require("modules.git.config")
local git = require("core.pack").package

-- github GH ui
git({
    "pwntester/octo.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = { "<Leader>Op", "<Leader>Opl", "<Leader>Ope", "<Leader>Oil", "<Leader>Oic", "<Leader>Oie" },
    config = conf.octo,
})

git({
    "ldelossa/gh.nvim",
    cmd = {
        "GHOpenPR",
        "GHClosePR",
        "GHADDLabel",
        "GHExpandPR",
        "GHOpenToPR",
        "GHPopOutPR",
        "GHPRDetails",
        "GHRefreshPR",
        "GHCollapsePR",
        "GHNextThread",
        "GHCloseCommit",
        "GHCloseReview",
        "GHStartReview",
        "GHCreateThread",
        "GHDeleteReview",
        "GHExpandCommit",
        "GHExpandReview",
        "GHOpenToCommit",
        "GHPopOutCommit",
        "GHPreviewIssue",
        "GHSubmitReview",
        "GHToggleThreads",
        "GhCollapseCommit",
        "GHRefreshComments",
    },
    opt = true,
    requires = { "ldelossa/litee.nvim" },
    config = conf.gh,
})

git({ "ThePrimeagen/git-worktree.nvim", event = { "CmdwinEnter", "CmdlineEnter" }, config = conf.worktree })

git({
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewFocusFiles",
        "DiffviewToggleFiles",
        "DiffviewRefresh",
    },
    config = conf.diffview,
})

git({
    "lewis6991/gitsigns.nvim",
    config = conf.gitsigns,
    -- keys = {']c', '[c'},  -- load by lazy.lua
    opt = true,
})

git({ "TimUntersberger/neogit", opt = true, cmd = { "Neogit" }, setup = conf.neogit_setup, config = conf.neogit })

git({ "ruifm/gitlinker.nvim", module = "gitlinker", config = conf.gitlinker })

git({
    "tanvirtin/vgit.nvim", -- gitsign has similar features
    cmd = { "VGit" },
    -- after = {"telescope.nvim"},
    opt = true,
    config = conf.vgit,
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
    config = conf.git_conflict,
})

git({
    "tpope/vim-fugitive",
    cmd = { "Gvsplit", "Git", "Gedit", "Gstatus", "Gdiffsplit", "Gvdiffsplit" },
    opt = true,
})

git({ "LhKipp/nvim-git-fixer", cmd = { "FixUp", "Ammend" }, opt = true, config = conf.git_fixer })

git({ "rbong/vim-flog", requires = "vim-fugitive", cmd = { "Flog", "Flogsplit" }, opt = true })
-- return git
