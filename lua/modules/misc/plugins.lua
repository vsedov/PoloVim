local conf = require("modules.misc.config")
local misc = require("core.pack").package

misc({
    "fladson/vim-kitty",
    event = "BufReadPre *.conf",
})

misc({
    "onsails/diaglist.nvim",
    keys = { "<leader>qw", "<leader>qf" },
    cmd = { "Qfa", "Qfb" },
    config = conf.diaglist,
})

--         ╭───────────────────────────────────────────────────────────────────╮
--         │ surr*ound_words             ysiw)           (surround_words)      │
--         │ *make strings               ys$"            "make strings"        │
--         │ [delete ar*ound me!]        ds]             delete around me!     │
--         │ remove <b>HTML t*ags</b>    dst             remove HTML tags      │
--         │ 'change quot*es'            cs'"            "change quotes"       │
--         │ <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1> │
--         │ delete(functi*on calls)     dsf             function calls        │
--         │                                                                   │
--         ╰───────────────────────────────────────────────────────────────────╯

misc({
    "kylechui/nvim-surround",
    lazy = true,
    opts = { move_cursor = true, keymaps = { visual = "s" } },
    event = "InsertEnter",
    config = function(_, opts)
        require("nvim-surround").setup(opts)
        -- surr*ound_words             ysiw)           (surround_words)
        -- *make strings               ys$"            "make strings"
        -- [delete ar*ound me!]        ds]             delete around me!
        -- remove <b>HTML t*ags</b>    dst             remove HTML tags
        -- 'change quot*es'            cs'"            "change quotes"
        -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        -- delete(functi*on calls)     dsf             function calls

        local bind_list = {
            ["surround_word"] = {
                bind = "ysiw)",
                text = "(surround_words)",
            },

            ["*make strings"] = {
                bind = 'ys$"',
                text = '"make strings"',
            },

            ["[delete around me!]"] = {
                bind = "ds]",
                text = "delete around me!",
            },

            ["remove <b>HTML tags</b>"] = {
                bind = "dst",
                text = "remove HTML tags",
            },

            ["'change quotes'"] = {
                bind = "cs'\"",
                text = '"change quotes"',
            },

            ["<b>or tag types</b>"] = {
                bind = "csth1<CR>",
                text = "<h1>or tag types</h1>",
            },

            ["delete(function calls)"] = {
                bind = "dsf",
                text = "function calls",
            },
        }

        -- not make it like info, bind , text in one big text and print it using vim.notify
        table_string = ""
        for k, v in pairs(bind_list) do
            table_string = table_string .. k .. " " .. v.bind .. " " .. v.text .. "\n"
        end

        lambda.command("SurroundBinds", function()
            vim.notify(table_string)
        end)
    end,
})

misc({
    "XXiaoA/ns-textobject.nvim",
    event = "InsertEnter",
    dependencies = { "kylechui/nvim-surround" },
    opts = {
        auto_mapping = {
            -- automatically mapping for nvim-surround's aliases
            aliases = true,
            -- for nvim-surround's surrounds
            surrounds = true,
        },
        disable_builtin_mapping = {
            enabled = true,
            -- list of char which shouldn't mapping by auto_mapping
            chars = { "b", "B", "t", "`", "'", '"', "{", "}", "(", ")", "[", "]", "<", ">" },
        },
    },
})
-- programming spell
misc({
    "psliwka/vim-dirtytalk",
    event = "BufWrite",
    cmd = { "DirtytalkUpdate" },
    config = function()
        vim.defer_fn(function()
            vim.cmd("silent!  DirtytalkUpdate")
            vim.opt.spelllang:append("programming")
        end, 1000)
    end,
})

misc({
    "nyngwang/NeoRoot.lua",
    cmd = { "NeoRootSwitchMode", "NeoRootChange", "NeoRoot" },
    config = function()
        require("neo-root").setup({
            CUR_MODE = 2, -- 1 for file/buffer mode, 2 for proj-mode
        })
    end,
})

misc({
    "ahmedkhalf/project.nvim",
    event = "BufRead",
    config = function()
        require("project_nvim").setup({
            ignore_lsp = { "null-ls" },
            silent_chdir = true,
            patterns = { ".git", ".hg", ".svn", "pyproject.toml" },
        })
    end,
})

misc({
    "gbprod/stay-in-place.nvim",
    keys = {
        { ">", mode = "n" },
        { "<", mode = "n" },
        { "=", mode = "n" },
        { ">>", mode = "n" },
        { "<<", mode = "n" },
        { "==", mode = "n" },
        { ">", mode = "x" },
        { "<", mode = "x" },
        { "=", mode = "x" },
    },
    config = true,
})

misc({
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    config = conf.carbon,
    cmd = "CarbonNow",
})

misc({
    "nacro90/numb.nvim",
    config = true,
    event = "CmdlineEnter",
})

misc({ "tweekmonster/helpful.vim", cmd = "HelpfulVersion", ft = "help" })
-- If there is regex, this seems very nice to work with .
misc({
    "tomiis4/Hypersonic.nvim",
    cmd = "Hypersonic",
    keys = {
        {
            "<leader>R",
            function()
                vim.cmd([[Hypersonic]])
            end,
            mode = "v",
        },
    },
    opts = {
        border = lambda.style.border.type_0,
    },
})
misc({
    "kiran94/maim.nvim",
    config = true,
    cmd = { "Maim", "MaimMarkdown" },
})
misc({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "CursorMoved",
    config = function()
        vim.g.wordmotion_prefix = ","
    end,
})
