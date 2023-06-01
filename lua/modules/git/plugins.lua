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
    "rawnly/gist.nvim",
    cmd = { "CreateGist" },
})

git({
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
})
-- need to find a usecase for this
git({ "ThePrimeagen/git-worktree.nvim", lazy = true, config = conf.worktree })

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
    config = conf.diffview,
})

git({
    "lewis6991/gitsigns.nvim",
    config = conf.gitsigns,
    dependencies = { "nvim-lua/plenary.nvim" },
    module = "gitsigns",
    lazy = true,
})

-- -- --  TODO: (vsedov) (20:55:15 - 26/10/22): Fix NeoGit is not a command.
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
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },

    cmd = { "Neogit" },
    config = conf.neogit,
})

-- --  I think this gets loaded in the first place
git({
    "tanvirtin/vgit.nvim", -- gitsign has similar features
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
    opts = { disable_diagnostics = true },
})

-- --[[ My work flow requires me to use both neogit and fugative, so what i think  ]]
-- --[[ i will do is load this if Neogit is loaded as well, just to be in the same thing ]]
-- -- get loaded through hydra
git({
    "tpope/vim-fugitive",
    lazy = true,
    cmd = "Git",
})

git({
    "LhKipp/nvim-git-fixer",
    cmd = { "Fixup", "Amend", "Squash", "Commit", "Reword" },
    dependencies = {
        "telescope.nvim",
        "tpope/vim-fugitive",
        "lewis6991/gitsigns.nvim",
    },
    lazy = true,
    config = conf.git_fixer,
})

git({ "rbong/vim-flog", cmd = { "Flog", "Flogsplit" }, lazy = true })
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
    "ruifm/gitlinker.nvim",
    lazy = true,
    opts = {
        mappings = nil,
    },
    config = true,
})
-- Diff arbitrary blocks of text with each other
git({ "AndrewRadev/linediff.vim", cmd = "Linediff" })
git({
    "topaxi/gh-actions.nvim",
    cmd = "GhActions",
    keys = {
        { "<leader>gh", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    opts = {},
    config = function(_, opts)
        require("gh-actions").setup(opts)
    end,
})
