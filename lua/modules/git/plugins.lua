local git = {}
local conf = require("modules.git.config")

-- github GH ui
git["pwntester/octo.nvim"] = {
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = { "<Leader>Op", "<Leader>Opl", "<Leader>Ope", "<Leader>Oil", "<Leader>Oic", "<Leader>Oie" },
    config = conf.octo,
}

git["ldelossa/gh.nvim"] = {
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
    requires = { "ldelossa/litee.nvim", opt = true, after = "gh.nvim" },
    config = conf.gh,
}

git["ThePrimeagen/git-worktree.nvim"] = {
    event = { "CmdwinEnter", "CmdlineEnter" },
    config = conf.worktree,
}

git["sindrets/diffview.nvim"] = {
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewFocusFiles",
        "DiffviewToggleFiles",
        "DiffviewRefresh",
    },
    config = conf.diffview,
}

git["lewis6991/gitsigns.nvim"] = {
    config = conf.gitsigns,
    -- keys = {']c', '[c'},  -- load by lazy.lua
    opt = true,
}

git["TimUntersberger/neogit"] = {
    opt = true,
    cmd = { "Neogit" },
    config = conf.neogit,
}

git["ruifm/gitlinker.nvim"] = {
    keys = { "<leader>gy" },
    config = conf.gitlinker,
}

git["tanvirtin/vgit.nvim"] = { -- gitsign has similar features
    setup = function()
        vim.o.updatetime = 2000
    end,
    cmd = { "VGit" },
    -- after = {"telescope.nvim"},
    opt = true,
    config = conf.vgit,
}

git["akinsho/git-conflict.nvim"] = {
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
}

git["tpope/vim-fugitive"] = {
    cmd = { "Gvsplit", "Git", "Gedit", "Gstatus", "Gdiffsplit", "Gvdiffsplit" },
    opt = true,
}

git["LhKipp/nvim-git-fixer"] = {
    cmd = { "FixUp", "Ammend" },
    opt = true,
    config = conf.git_fixer,
}

return git
