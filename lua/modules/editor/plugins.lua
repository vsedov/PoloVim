local conf = require("modules.editor.config")
local editor = require("core.pack").package
editor({

    "nvim-neorg/neorg",
    branch = "main",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        { "max397574/neorg-kanban", ft = "norg" },
    },
    -- after = "nvim-treesitter" ,
    opt = true,
    config = conf.norg,
})

editor({
    "AckslD/nvim-FeMaco.lua",
    opt = true,
    ft = { "norg", "markdown" },
    config = conf.femaco,
    cmd = "FeMaco",
})

editor({
    "Pocco81/true-zen.nvim",
    opt = true,
    requires = { "folke/twilight.nvim", opt = true, config = conf.twilight },
    cmd = { "TZAtaraxis", "TZMinimalist", "TZNarrow", "TZFocus" },
    module = "zen-mode",
    config = conf.zen,
})

editor({ "rainbowhxch/accelerated-jk.nvim", keys = {
    "j",
    "k",
}, config = conf.acc_jk })

editor({
    "gbprod/yanky.nvim",
    event = { "CursorMoved", "CmdlineEnter" },
    setup = conf.setup_yanky,
    config = conf.config_yanky,
    requires = "telescope.nvim",
})

-- -- -- NORMAL mode:
-- -- -- `gcc` - Toggles the current line using linewise comment
-- -- -- `gbc` - Toggles the current line using blockwise comment
-- -- -- `[count]gcc` - Toggles the number of line given as a prefix-count
-- -- -- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- -- -- `gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

-- -- -- VISUAL mode:
-- -- -- `gc` - Toggles the region using linewise comment
-- -- -- `gb` - Toggles the region using blockwise comment

-- -- -- NORMAL mode
-- -- -- `gco` - Insert comment to the next line and enters INSERT mode
-- -- -- `gcO` - Insert comment to the previous line and enters INSERT mode
-- -- -- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- -- -- NORMAL mode
-- -- -- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- -- -- `g>c` - Comments the current line using linewise comment
-- -- -- `g>b` - Comments the current line using blockwise comment
-- -- -- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- -- -- `g<c` - Uncomments the current line using linewise comment
-- -- -- `g<b`- Uncomments the current line using blockwise comment

-- -- -- VISUAL mode
-- -- -- `g>` - Comments the region using single line
-- -- -- `g<` - Unomments the region using single line

-- -- -- `gcw` - Toggle from the current cursor position to the next word
-- -- -- `gc$` - Toggle from the current cursor position to the end of line
-- -- -- `gc}` - Toggle until the next blank line
-- -- -- `gc5l` - Toggle 5 lines after the current cursor position
-- -- -- `gc8k` - Toggle 8 lines before the current cursor position
-- -- -- `gcip` - Toggle inside of paragraph
-- -- -- `gca}` - Toggle around curly brackets

-- -- -- # Blockwise

-- -- -- `gb2}` - Toggle until the 2 next blank line
-- -- -- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- -- -- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

editor({ "numToStr/Comment.nvim", keys = { "g", "<ESC>" }, config = conf.comment })

editor({
    "LudoPinelli/comment-box.nvim",
    keys = { "<Leader>cb", "<Leader>cc", "<Leader>cl", "<M-p>" },
    cmd = { "CBlbox", "CBcbox", "CBline", "CBcatalog" },
    opt = true,
    config = conf.comment_box,
})

-- trying to figure out why this does not work .

editor({
    "chaoren/vim-wordmotion",
    keys = {
        { "n", "<Plug>WordMotion_" },
        { "x", "<Plug>WordMotion_" },
        { "o", "<Plug>WordMotion_" },
        { "c", "<Plug>WordMotion_" },
    },
    setup = function()
        vim.g.wordmotion_uppercase_spaces = { "-" }
        vim.g.wordmotion_nomap = 1
        for _, key in ipairs({ "e", "b", "w", "E", "B", "W", "ge", "gE" }) do
            vim.keymap.set({ "n", "x", "o" }, key, "<Plug>WordMotion_" .. key)
        end
        vim.keymap.set({ "x", "o" }, "aW", "<Plug>WordMotion_aW")
        vim.keymap.set({ "x", "o" }, "iW", "<Plug>WordMotion_iW")
        vim.keymap.set("c", "<C-R><C-W>", "<Plug>WordMotion_<C-R><C-W>")
        vim.keymap.set("c", "<C-R><C-A>", "<Plug>WordMotion_<C-R><C-A>")
    end,
})
editor({
    "anuvyklack/vim-smartword",
    keys = {
        "<Plug>(smartword-w)",
        "<Plug>(smartword-b)",
        "<Plug>(smartword-e)",
        "<Plug>(smartword-ge)",
    },
})
editor({ "sindrets/winshift.nvim", cmd = "WinShift", opt = true, config = conf.win_shift })

-- -- Currently needs to be calle , not sure if i have to lazy load this or not.
editor({ "andweeb/presence.nvim", opt = true, config = conf.discord })

editor({ "monaqa/dial.nvim", keys = { "<C-a>", "<C-x>" }, opt = true, config = conf.dial })

editor({
    "m-demare/hlargs.nvim",
    brach = "expected_lua_number",
    ft = {
        "c",
        "cpp",
        "python",
        "java",
        "lua",
        "rust",
        "go",
        "vim",
        "zig",
    },
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
})

editor({
    "max397574/which-key.nvim",
    opt = true,
    after = "nvim-treesitter",
    config = function()
        require("modules.editor.which_key")
    end,
})

editor({
    "anuvyklack/hydra.nvim",
    requires = "anuvyklack/keymap-layer.nvim",
    config = conf.hydra,
    opt = true,
})

-- temp
editor({
    "szw/vim-maximizer",
    cmd = "MaximizerToggle!",
})

editor({
    "mrjones2014/smart-splits.nvim",
    module = "smart-splits",
})

editor({
    "gbprod/substitute.nvim",
    require = "gbprod/yanky.nvim",
    keys = {
        -- normal sub
        { "n", "<leader>L" },
        { "n", "Ll" },
        { "n", "LL" },
        { "x", "L" },
        -- range
        { "n", "<leader>l" },
        { "x", "<leader>l" },
        { "n", "<leader>lr" },
        -- Sub
        { "n", "Lx" },
        { "n", "Lxx" },
        { "x", "Lx" },
        { "n", "Lxc" },
    },
    config = conf.substitute,
})

-- start = "gm", -- Mark word / region
-- start_and_edit = "gM", -- Mark word / region and also edit
-- start_and_edit_word = "g!M", -- Mark word / region and also edit.  Edit only full word.
-- start_word = "g!m", -- Mark word / region. Edit only full word
-- apply_substitute_and_next = "\\m", -- Start substitution / Go to next substitution
-- apply_substitute_and_prev = "\p", -- same as M but backwards
-- apply_substitute_all = "\l", -- Substitute all
editor({
    "otavioschwanck/cool-substitute.nvim",
    keys = {
        "gm",
        "gM",
        "g!M",
        "g!m",
        "\\m",
        "\\p",
        "\\l",
    },
    config = conf.cool_sub,
})

editor({
    "mg979/vim-visual-multi",
    keys = {
        "<Ctrl>",
        "<M>",
        "<C-n>",
        "<C-n>",
        "<M-n>",
        "<S-Down>",
        "<S-Up>",
        "<M-Left>",
        "<M-i>",
        "<M-Right>",
        "<M-D>",
        "<M-Down>",
        "<C-d>",
        "<C-Down>",
        "<S-Right>",
        "<C-LeftMouse>",
        "<M-LeftMouse>",
        "<M-C-RightMouse>",
    },
    opt = true,
    setup = conf.vmulti,
})

editor({
    "johmsalas/text-case.nvim",
    keys = {
        "ga",
        "gau",
        "gal",
        "gas",
        "gad",
        "gan",
        "gad",
        "gaa",
        "gac",
        "gap",
        "gat",
        "gaf",
        "gaU",
        "gaL",
        "gaS",
        "gaD",
        "gaN",
        "gaD",
        "gaA",
        "gaC",
        "gaP",
        "gaT",
        "gaF",
        "geu",
        "gel",
        "ges",
        "ged",
        "gen",
        "ged",
        "gea",
        "gec",
        "gep",
        "get",
        "gef",
        "ga.",
        "gaw",
        "gaW",
    },
    config = conf.text_case,
})

editor({
    "nicwest/vim-camelsnek",
    opt = true,
    cmd = { "Snek", "Camel", "CamelB", "Kebab" },
})

-- editor({
--     "knubie/vim-kitty-navigator",
--     opt = true,
--     run = "cp ./*.py ~/.config/kitty/",
--     keys = { "<c-j>", "<c-k>", "<c-h>", "<c-l>" },
--     cond = function()
--         return vim.env.TMUX == nil
--     end,
-- })

editor({
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
    keys = { "_q" },
    config = conf.bbye,
})

editor({
    "jbyuki/venn.nvim",
    opt = true,
})

-- editor({
--     "andymass/vim-matchup",
--     opt = true,
--     event = { "InsertEnter" },
--     keys = "<leader><leader><leader>",
--     cmd = { "MatchupWhereAmI?", "MatchupShowTimes", "MatchupWhereAmI??" },
--     after = "nvim-treesitter",
--     config = conf.matchup,
-- })

editor({
    "ojroques/nvim-osc52",
    keys = { { "x", "\\y" }, { "n", "\\y" } },
    config = function()
        require("osc52").setup({
            max_length = 0, -- Maximum length of selection (0 for no limit)
            silent = false, -- Disable message on successful copy
            trim = false, -- Trim text before copy
        })
        vim.keymap.set("n", "\\y", require("osc52").copy_operator, { expr = true })
        vim.keymap.set("x", "\\y", require("osc52").copy_visual)
    end,
})
editor({
    "AckslD/nvim-trevJ.lua",
    module = "trevj",
    keys = "<leader>j",
    setup = function()
        vim.keymap.set("n", "<leader>j", function()
            require("trevj").format_at_cursor()
        end)
    end,
    config = function()
        require("trevj").setup()
    end,
})

editor({
    "linty-org/readline.nvim",
    event = "CmdlineEnter",
    config = conf.readline,
})
