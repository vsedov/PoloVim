local conf = require("modules.editor.config")
local editor = require("core.pack").package
editor({
    "nvim-neorg/neorg",
    branch = "main",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        { "max397574/neorg-kanban", ft = "norg" },
    },
    config = conf.norg,
})

editor({
    "folke/zen-mode.nvim",
    opt = true,
    requires = { "folke/twilight.nvim", opt = true, config = conf.twilight },
    cmd = { "ZenMode" },
    config = conf.zen,
})

editor({ "rainbowhxch/accelerated-jk.nvim", keys = {
    "j",
    "k",
}, config = conf.acc_jk })

editor({
    "gbprod/yanky.nvim",
    keys = {
        { "n", "y" },
        { "x", "y" },

        { "n", "p" },
        { "n", "P" },
        { "x", "p" },
        { "x", "P" },

        { "n", "gp" },
        { "n", "gP" },
        { "x", "gp" },
        { "x", "gP" },

        { "n", "<Leader>n" },
        { "n", "<Leader>N" },
    },
    -- event = { "CursorMoved", "CmdlineEnter" },
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
editor({ "nyngwang/NeoNoName.lua", cmd = "NeoNoName", opt = true })

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

editor({ "sindrets/winshift.nvim", cmd = "WinShift", opt = true, config = conf.win_shift })

-- temp
editor({
    "declancm/cinnamon.nvim",
    keys = {
        "<C-U>",
        "<C-D>",
        "<C-B>",
        "<C-F>",
        "gg",
        "G",
    },
    config = conf.neoscroll,
})

-- -- Currently needs to be calle , not sure if i have to lazy load this or not.
editor({ "andweeb/presence.nvim", opt = true, config = conf.discord })

editor({ "monaqa/dial.nvim", keys = { "<C-a>", "<C-x>" }, opt = true, config = conf.dial })

editor({
    "m-demare/hlargs.nvim",
    brach = "expected_lua_number",
    ft = { "python", "c", "cpp", "java", "lua", "rust", "go" },
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
    keys = { "<leader>b", "<leader>f", "<c-w>", "\\z", "<leader>h" },
    config = conf.hydra,
    opt = true,
})

editor({
    "gbprod/substitute.nvim",
    require = "gbprod/yanky.nvim",
    keys = { "_", "L_" },
    config = conf.substitute,
})

editor({
    "knubie/vim-kitty-navigator",
    run = "cp ./*.py ~/.config/kitty/",
    cond = function()
        return vim.env.TMUX == nil
    end,
})
