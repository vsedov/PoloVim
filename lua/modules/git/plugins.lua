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
    setup = conf.git_setup("diffview.nvim"),
    opt = true,
    config = conf.diffview,
})

git({
    "lewis6991/gitsigns.nvim",
    config = conf.gitsigns,
    -- keys = {']c', '[c'},  -- load by lazy.lua
    opt = true,
})

git({
    "TimUntersberger/neogit",
    keys = {
        "<localleader>gs",
        "<localleader>gc",
        "<localleader>gl",
        "<localleader>gp",
    },
    opt = true,
    setup = conf.git_setup("neogit"),
    cmd = { "Neogit" },
    config = conf.neogit,
})

git({ "ruifm/gitlinker.nvim", module = "gitlinker", config = conf.gitlinker })

--  I think this gets loaded in the first place
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
    opt = true,
    config = conf.git_conflict,
})

--[[ My work flow requires me to use both neogit and fugative, so what i think  ]]
--[[ i will do is load this if Neogit is loaded as well, just to be in the same thing ]]
git({
    "tpope/vim-fugitive",
    setup = conf.git_setup("vim-fugitive"),
    opt = true,
})

git({
    "LhKipp/nvim-git-fixer",
    cmd = { "Fixup", "Amend", "Squash", "Commit", "Reword" },
    setup = conf.git_setup("nvim-git-fixer"),
    requires = {
        "telescope.nvim",
        "tpope/vim-fugitive",
        "lewis6991/gitsigns.nvim",
    },
    opt = true,
    config = conf.git_fixer,
})

git({ "rbong/vim-flog", requires = "vim-fugitive", cmd = { "Flog", "Flogsplit" }, opt = true })
-- return git

-- @usage | this is to clone repos, which is interesting
-- you can remove and add repos with this, or temp ones that you can mess
-- around with
git({
    "danielhp95/tmpclone-nvim",
    requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
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
