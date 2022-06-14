local git = {}
local conf = require("modules.git.config")
local package = require("core.pack").package

-- github GH ui
package({
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

package({
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
    requires = { "ldelossa/litee.nvim", opt = true, after = "gh.nvim" },
    config = conf.gh,
})

package({ "ThePrimeagen/git-worktree.nvim", event = { "CmdwinEnter", "CmdlineEnter" }, config = conf.worktree })

package({
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

package({
    "lewis6991/gitsigns.nvim",
    config = conf.gitsigns,
    -- keys = {']c', '[c'},  -- load by lazy.lua
    opt = true,
})

package({ "TimUntersberger/neogit", opt = true, cmd = { "Neogit" }, config = conf.neogit })

package({ "ruifm/gitlinker.nvim", keys = { "<leader>gy" }, config = conf.gitlinker })

package({
    "tanvirtin/vgit.nvim", -- gitsign has similar features
    setup = function()
        vim.o.updatetime = 2000
    end,
    cmd = { "VGit" },
    -- after = {"telescope.nvim"},
    opt = true,
    config = conf.vgit,
})

package({
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

package({
    "tpope/vim-fugitive",
    cmd = { "Gvsplit", "Git", "Gedit", "Gstatus", "Gdiffsplit", "Gvdiffsplit" },
    opt = true,
})

package({ "LhKipp/nvim-git-fixer", cmd = { "FixUp", "Ammend" }, opt = true, config = conf.git_fixer })

-- return git
