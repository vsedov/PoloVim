local conf = require("modules.editor.config")
local editor = require("core.pack").package
editor({

    "nvim-neorg/neorg",
    --[[ branch = "main", ]]
    tags = "*",
    run = ":Neorg sync-parsers",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-treesitter",
    },
    after = { "telescope.nvim" },
    config = conf.norg,
})

editor({
    "hisbaan/jot.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "Jot" },
    config = function()
        require("jot").setup({
            search_dir = "~/neorg/",
            search_depth = 10,
            hide_search_dir = false,
            post_open_hook = function() end,
        })
    end,
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

--[[ This thing causes issues with respect to cmdheight=0 ]]
--[[ editor({ ]]
--[[     "chaoren/vim-wordmotion", ]]
--[[     keys = { ]]
--[[         { "n", "<Plug>WordMotion_" }, ]]
--[[         { "x", "<Plug>WordMotion_" }, ]]
--[[         { "o", "<Plug>WordMotion_" }, ]]
--[[         { "c", "<Plug>WordMotion_" }, ]]
--[[     }, ]]
--[[     setup = function() ]]
--[[         vim.g.wordmotion_uppercase_spaces = { "-" } ]]
--[[         vim.g.wordmotion_nomap = 1 ]]
--[[         for _, key in ipairs({ "e", "b", "w", "E", "B", "W", "ge", "gE" }) do ]]
--[[             vim.keymap.set({ "n", "x", "o" }, key, "<Plug>WordMotion_" .. key) ]]
--[[         end ]]
--[[         vim.keymap.set({ "x", "o" }, "aW", "<Plug>WordMotion_aW") ]]
--[[         vim.keymap.set({ "x", "o" }, "iW", "<Plug>WordMotion_iW") ]]
--[[         vim.keymap.set("c", "<C-R><C-W>", "<Plug>WordMotion_<C-R><C-W>") ]]
--[[         vim.keymap.set("c", "<C-R><C-A>", "<Plug>WordMotion_<C-R><C-A>") ]]
--[[     end, ]]
--[[ }) ]]
--[[]]
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
editor({
    "anuvyklack/windows.nvim",
    requires = {
        { "anuvyklack/middleclass", opt = true },
        { "anuvyklack/animation.nvim", opt = true },
    },
    opt = true,
    cmd = {

        "WindowsMaximize",
        "WindowsMaximize!",
        "WindowsToggleAutowidth",
        "WindowsEnableAutowidth",
        "WindowsDisableAutowidth",
    },
    keys = {
        "<c-w>z",
        ";z",
    },
    config = function()
        vim.cmd([[packadd middleclass]])
        vim.cmd([[packadd animation.nvim]])
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require("windows").setup()
        vim.keymap.set("n", ";z", "<Cmd>WindowsMaximize<CR>")
    end,
})
-- -- Currently needs to be calle , not sure if i have to lazy load this or not.
editor({ "andweeb/presence.nvim", opt = true, config = conf.discord })

editor({ "monaqa/dial.nvim", keys = { "<C-a>", "<C-x>" }, opt = true, config = conf.dial })

editor({
    "m-demare/hlargs.nvim",
    ft = {
        "c",
        "cpp",
        "go",
        "java",
        "javascript",
        "jsx",
        "lua",
        "php",
        "python",
        "r",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "zig",
    },
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
})

editor({
    "David-Kunz/markid",
    after = "nvim-treesitter",
})

editor({
    "folke/which-key.nvim",
    module = "which-key",
    requires = "nvim-treesitter",
    config = function()
        require("modules.editor.which_key")
    end,
})

editor({
    "anuvyklack/hydra.nvim",
    requires = "anuvyklack/keymap-layer.nvim",
    config = conf.hydra,
    event = "BufEnter",
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
        "\\\\a",
        "g!!",
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
    "edluffy/hologram.nvim",
    ft = {
        "norg",
        "md",
        "org",
        "latex",
    },
    config = function()
        require("hologram").setup({
            auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
        })
    end,
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
    cmd = "Venn",
    config = function()
        local function noremap(mode, lhs, rhs)
            vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, { noremap = true })
        end

        local function unmap(mode, lhs)
            vim.api.nvim_buf_del_keymap(0, mode, lhs)
        end

        -- venn.nvim: enable or disable keymappings
        local toggle = function()
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == "nil" then
                vim.b.venn_enabled = true

                vim.b.venn_ve = vim.api.nvim_get_option("virtualedit")
                vim.api.nvim_set_option("virtualedit", "all")

                noremap("n", "<Down>", "<C-v>j:VBox<CR>")
                noremap("n", "<Up>", "<C-v>k:VBox<CR>")
                noremap("n", "<Left>", "<C-v>h:VBox<CR>")
                noremap("n", "<Right>", "<C-v>l:VBox<CR>")
                noremap("v", "<CR>", ":VBox<CR>")

                print("Enabled Venn mode. Press <CR> in visual mode to create box.")
            else
                vim.api.nvim_set_option("virtualedit", vim.b.venn_ve)

                unmap("n", "<Down>")
                unmap("n", "<Up>")
                unmap("n", "<Left>")
                unmap("n", "<Right>")
                unmap("v", "<CR>")

                vim.b.venn_enabled = nil

                print("Disabled Venn mode.")
            end
        end

        lambda.command("Venn", function()
            vim.g.venn_ve = nil
            vim.g.venn_enabled = false
            toggle()
        end, { bang = true })
    end,
})

editor({
    "andymass/vim-matchup",
    event = { "CursorMoved", "CursorMovedI" },
    after = "nvim-treesitter", --[[ Load this after nvim treesitter ]]
    cmd = { "MatchupWhereAmI?" },
    config = conf.matchup,
})

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
    "aarondiel/spread.nvim",
    after = "nvim-treesitter",
    module = "spread",
    keys = {
        "<leader>J",
        "<leader>j",
    },
    config = function()
        vim.keymap.set("n", "<leader>J", function()
            require("spread").out()
        end, { desc = "spread: expand" })
        vim.keymap.set("n", "<leader>j", function()
            require("spread").combine()
        end, { desc = "spread: combine" })
    end,
})

editor({
    "linty-org/readline.nvim",
    event = "CmdlineEnter",
    config = conf.readline,
})

-- What tf is this plugin ?
editor({
    "andrewferrier/wrapping.nvim",
    event = "BufEnter",
    config = function()
        require("wrapping").setup()
    end,
})
-- fix terminal colofr
editor({
    "norcalli/nvim-terminal.lua",
    opt = true,
    ft = { "log", "terminal" },
    config = function()
        require("terminal").setup()
    end,
})

editor({
    "haya14busa/vim-asterisk",
    opt = true,
    keys = {
        { "n", "*" },
        { "n", "#" },
        { "n", "g*" },
        { "n", "g#" },
        { "n", "z*" },
        { "n", "gz*" },
        { "n", "z#" },
        { "n", "gz#" },
    },
    setup = conf.asterisk_setup,
})

editor({
    "ethanholz/nvim-lastplace",
    event = "BufEnter",
    config = function()
        require("nvim-lastplace").setup({
            lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
            lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
            lastplace_open_folds = true,
        })
    end,
})

editor({
    "kevinhwang91/nvim-hclipboard",
    event = "InsertCharPre",
    config = function()
        require("hclipboard").start()
    end,
})

editor({
    "monkoose/matchparen.nvim",
    opt = true,
    config = function()
        require("matchparen").setup()
    end,
})

editor({
    "marklcrns/vim-smartq",
    keys = {
        "Q",
        "q",
    },
    cmd = {
        "SmartQ",
        "SmartQ!",
        "SmartQSave",
        "SmartQWipeEmpty",
        "SmartQWipeEmpty!",
        "SmartQCloseSplits",
    },
    config = function()
        vim.g.smartq_goyo_integration = 0
        vim.g.smartq_zenmode_integration = 0
    end,
})

editor({
    "ja-ford/delaytrain.nvim",
    setup = function()
        lambda.setup_plugin("BufEnter", "delaytrain.nvim", lambda.config.use_delay_train)
    end,
    config = function()
        require("delaytrain").setup()
    end,
})
