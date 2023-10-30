local user = require("core.pack").package
local uv = vim.uv or vim.loop
local api, fn = vim.api, vim.fn

user({
    "axieax/urlview.nvim",
    lazy = true,
    keys = {
        { "\\u", vim.cmd.UrlView, desc = "view buffer URLS " },
    },
    config = true,
})

user({
    "superDross/spellbound.nvim",
    keys = {
        {
            "<c-g>w",
            desc = "toggle spellbound",
        },
        {
            "<c-g>n",
            desc = "fix right",
        },
        {
            "<c-g>p",
            desc = "fix left",
        },
    },
    init = function()
        vim.o.dictionary = "/usr/share/dict/cracklib-small"
        -- default settings
        vim.g.spellbound_settings = {
            mappings = {
                toggle_map = "<c-g>w",
                fix_right = "<c-g>n",
                fix_left = "<c-g>p",
            },
            language = "en_gb",
            autospell_filetypes = { "*.txt", "*.md", "*.rst", "*.norg" },
            autospell_gitfiles = true,
            number_suggestions = 10,
            return_to_position = true,
        }
    end,
})

--  TODO: (vsedov) (22:29:48 - 23/07/23): Make a hydra for this to activate when the mode is !
user({
    "assistcontrol/readline.nvim",
    keys = {
        {
            "<C-k>",
            function()
                require("readline").kill_line()
            end,
            desc = "readline: kill line",
            mode = "!",
        },
        {
            "<C-u>",
            function()
                require("readline").end_of_line()
                require("readline").dwim_backward_kill_line()
            end,
            desc = "readline: backward kill line",
            mode = "!",
        },
        {
            "<M-d>",
            function()
                require("readline").kill_word()
            end,
            desc = "readline: kill word",
            mode = "!",
        },
        {
            "<M-BS>",
            function()
                require("readline").backward_kill_word()
            end,
            desc = "readline: backward kill word",
            mode = "!",
        },
        {
            "<C-r>", -- look in keymap folder
            function()
                require("readline").unix_word_rubout()
            end,
            desc = "readline: unix word rubout",
            mode = "!",
        },
        {
            "<C-a>",
            function()
                require("readline").dwim_beginning_of_line()
            end,
            desc = "readline: beginning of line",
            mode = "!",
        },
        {
            "<C-e>",
            function()
                require("readline").end_of_line()
            end,
            desc = "readline: end of line",
            mode = "!",
        },
        {
            "<M-f>",
            function()
                require("readline").forward_word()
            end,
            desc = "readline: forward word",
            mode = "!",
        },
        {
            "<M-b>",
            function()
                require("readline").backward_word()
            end,
            desc = "readline: backward word",
            mode = "!",
        },
        {
            "<C-f>",
            "<Right>",
            desc = "forward-char",
            mode = "!",
        },
        {
            "<C-b>",
            "<Left>",
            desc = "backward-char",
            mode = "!",
        },
        {
            "<C-n>",
            "<Down>",
            desc = "next-line",
            mode = "!",
        },
        {
            "<C-p>",
            "<Up>",
            desc = "previous-line",
            mode = "!",
        },
    },
})
user({
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    cond = lambda.config.ui.use_dropbar,
    keys = {
        {
            "<leader>wp",
            function()
                require("dropbar.api").pick()
            end,
            desc = "winbar: pick",
        },
    },
    opts = {
        general = {
            update_interval = 100,
            enable = function(buf, win)
                local b, w = vim.bo[buf], vim.wo[win]
                local decor = lambda.style.decorations.get({ ft = b.ft, bt = b.bt, setting = "winbar" })
                return decor.ft ~= false
                    and decor.bt ~= false
                    and b.bt == ""
                    and not w.diff
                    and not api.nvim_win_get_config(win).zindex
                    and api.nvim_buf_get_name(buf) ~= ""
            end,
        },
        icons = {
            ui = { bar = { separator = " " .. lambda.style.icons.misc.arrow_right .. " " } },
        },
        menu = {
            win_configs = {
                border = "single",
                col = function(menu)
                    return menu.prev_menu and menu.prev_menu._win_configs.width + 1 or 0
                end,
            },
        },
    },
})

user({
    "Zeioth/markmap.nvim",
    lazy = true,
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
        html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
        hide_toolbar = false, -- (default)
        grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts)
        require("markmap").setup(opts)
    end,
})
user({
    "azabiong/vim-highlighter",
    keys = {
        {
            "m<cr>",
            desc = "Highlight word",
        },
        {
            "m<bs>",
            desc = "Highlight delete",
        },
        {
            "mD>",
            desc = "Higlihgt clear",
        },
        {
            "m;",
            "<cmd>Hi}<cr>",
        },
    },
    init = function()
        vim.cmd("let HiSet = 'm<cr>'")

        vim.cmd("let HiErase = 'm<bs>'")
        vim.cmd("let HiClear = 'mD'")
    end,
})

user({
    "KaitlynEthylia/TreePin",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = {
        "TPPin",
        "TPRoot",
        "TPGrow",
        "TPShrink",
        "TPClear",
        "TPGo",
        "TpHide",
        "TPToggle",
    },
    keys = {
        { ",tp", "<cmd>TPPin<CR>", desc = "TreePin Pin" },
        { ",tc", "<cmd>TPClear<CR>", desc = "TreePin Clear" },
        { ",tt", "<cmd>TPToggle<CR>", desc = "TreePin Toggle" },
        { ",tr", "<cmd>TPRoot<CR>", desc = "TreePin Root" },
        { ",tj", "<cmd>TPGrow<CR>", desc = "TreePin Grow" },
        { ",tk", "<cmd>TPShrink<CR>", desc = "TreePin Shrink" },
        {
            ",tg",
            function()
                vim.cmd("normal! m'")
                vim.cmd("TPGo")
            end,
            desc = "TreePin Go",
        },
        { ",ts", "<cmd>TPShow<CR>", desc = "TreePin Show" },
        { ",th", "<cmd>TPHide<CR>", desc = "TreePin Hide" },
    },
    opts = {
        seperator = "▔",
    },
})
user({
    "lewis6991/whatthejump.nvim",
    cond = false,
    keys = { "<c-i>", "<c-o>" },
})
--  ──────────────────────────────────────────────────────────────────────
user({
    "thinca/vim-qfreplace",
    ft = "qf",
    lazy = true,
})
--  ──────────────────────────────────────────────────────────────────────

user({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "VeryLazy",
    config = function()
        vim.g.wordmotion_prefix = ","
    end,
})

user({
    "creativenull/dotfyle-metadata.nvim",
    cmd = "DotfyleGenerate",
})

user({
    "roobert/f-string-toggle.nvim",
    ft = "python",
    config = function()
        require("f-string-toggle").setup({
            key_binding = "\\f",
            key_binding_desc = "Toggle f-string",
        })
    end,
})

user({
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    config = function()
        require("kitty-scrollback").setup({
            checkhealth = true,
        })
    end,
})

user({
    "Sam-programs/expand.nvim",
    event = "VeryLazy",
    dependencies = { "Sam-Programs/indent.nvim" },
    config = true,
})

user({
    "sychen52/smart-term-esc.nvim",
    event = "TermEnter",
    config = function()
        require("smart-term-esc").setup({
            key = "<Esc>",
            except = { "nvim", "fzf" },
        })
    end,
})
user({
    "Aasim-A/scrollEOF.nvim",
    event = "VeryLazy",
    config = true,
})

user({
    "vidocqh/data-viewer.nvim",
    ft = {
        "csv",
        "tsv",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "kkharji/sqlite.lua", -- Optional, sqlite support
    },
    config = true,
    cmd = {

        "DataViewer",
        "DataViewerNextTable",
        "DataViewerPrevTable",
        "DataViewerClose",
    },
})
