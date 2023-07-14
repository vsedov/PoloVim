local conf = require("modules.git.config")
local git = require("core.pack").package

local function browser_open()
    return { action_callback = require("gitlinker.actions").open_in_browser }
end

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
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
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
    opts = conf.diffview_opts,
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
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = conf.neogit,
    cmd = { "Neogit" },
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
            "<localleader>gu",
            function()
                require("gitlinker").get_buf_range_url("n")
            end,
            desc = "gitlinker: copy line to clipboard",
            mode = "n",
        },
        {
            "<localleader>gu",
            function()
                require("gitlinker").get_buf_range_url("v")
            end,
            desc = "gitlinker: copy range to clipboard",
            mode = "v",
        },
        {
            "<localleader>go",
            function()
                require("gitlinker").get_repo_url(browser_open())
            end,
            desc = "gitlinker: open in browser",
        },
        {
            "<localleader>go",
            function()
                require("gitlinker").get_buf_range_url("n", browser_open())
            end,
            desc = "gitlinker: open current line in browser",
        },
        {
            "<localleader>go",
            function()
                require("gitlinker").get_buf_range_url("v", browser_open())
            end,
            desc = "gitlinker: open current selection in browser",
            mode = "v",
        },
    },
    opts = {
        mappings = nil,
        callbacks = {
            ["github-work"] = function(url_data) -- Resolve the host for work repositories
                url_data.host = "github.com"
                return require("gitlinker.hosts").get_github_type_url(url_data)
            end,
        },
    },
})
-- -- Diff arbitrary blocks of text with each other
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
