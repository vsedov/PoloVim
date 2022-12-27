local conf = require("modules.git.config")
local git = require("core.pack").package

-- -- github GH ui
git({
    "pwntester/octo.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
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
    lazy = true,
    dependencies = { "ldelossa/litee.nvim" },
    config = conf.gh,
})

git({ "ThePrimeagen/git-worktree.nvim", event = { "CmdwinEnter", "CmdlineEnter" }, config = conf.worktree })

git({
    "sindrets/diffview.nvim",
    init = conf.git_setup("diffview.nvim"),
    lazy = true,
    config = conf.diffview,
})

git({
    "lewis6991/gitsigns.nvim",
    config = conf.gitsigns,
    dependencies = {"nvim-lua/plenary.nvim"},
    lazy = true,
})

-- --  TODO: (vsedov) (20:55:15 - 26/10/22): Fix NeoGit is not a command.
-- -- "TimUntersberger/neogit",ten3roberts
git({
    "TimUntersberger/neogit",
    -- branch = "git-escapes",
    keys = {
        "<localleader>gs",
        "<localleader>gc",
        "<localleader>gl",
        "<localleader>gp",
    },
    lazy = true,
    cmd = { "Neogit" },
    config = conf.neogit,
})

git({
    "ruifm/gitlinker.nvim",
    keys = {
        { "n", "<leader>gT" },
        { "v", "<leader>gT" },
        { "n", "<leader>gY" },
        { "n", "<leader>gB" },
    },
    config = conf.gitlinker,
})

--  I think this gets loaded in the first place
git({
    "tanvirtin/vgit.nvim", -- gitsign has similar features
    modules = "vgit",
    lazy = true,
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
    lazy = true,
    config = conf.git_conflict,
})

-- --[[ My work flow requires me to use both neogit and fugative, so what i think  ]]
-- --[[ i will do is load this if Neogit is loaded as well, just to be in the same thing ]]
-- -- get loaded through hydra
git({
    "tpope/vim-fugitive",
    lazy = true,
})

git({
    "LhKipp/nvim-git-fixer",
    cmd = { "Fixup", "Amend", "Squash", "Commit", "Reword" },
    init = conf.git_setup("nvim-git-fixer"),
    dependencies = {
        "telescope.nvim",
        "tpope/vim-fugitive",
        "lewis6991/gitsigns.nvim",
    },
    lazy = true,
    config = conf.git_fixer,
})

git({ "rbong/vim-flog", requires = "vim-fugitive", cmd = { "Flog", "Flogsplit" }, lazy = true })
-- return git

-- @usage | this is to clone repos, which is interesting
-- you can remove and add repos with this, or temp ones that you can mess
-- around with
git({
    "danielhp95/tmpclone-nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
        { "n", "<leader>xc" },
        { "n", "<leader>xo" },
        { "n", "<leader>xr" },
    },
    cmd = {
        "TmpcloneClone",
        "TmpcloneOpen",
        "TmpcloneRemove",
    },

    config = conf.temp_clone,
})
