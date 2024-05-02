local user = require("core.pack").package

user({
    "axieax/urlview.nvim",
    lazy = true,
    keys = {
        { "\\u", vim.cmd.UrlView, desc = "view buffer URLS " },
    },
    config = true,
})

-- Potential Hydra
user({
    "superDross/spellbound.nvim",
    keys = {
        {
            "<c-g>w",
            desc = "toggle spellbound",
        },
        { "<c-g>n", desc = "fix right" },
        { "<c-g>N", desc = "fix left" },
    },
    init = function()
        vim.o.dictionary = "/usr/share/dict/directory-list-2.3-medium.txt"
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

-- Potential Hydra, save those mappings perhaps ?
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
            desc = "Highlight clear",
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

-- # Ngl
-- ngl i do not get why this isnt  hydra actually
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
-- user({
--     "lewis6991/whatthejump.nvim",
--     cond = false,
--     keys = { "<c-i>", "<c-o>" },
-- })
--  ──────────────────────────────────────────────────────────────────────
user({
    "thinca/vim-qfreplace",
    ft = "qf",
    lazy = true,
})

user({
    "creativenull/dotfyle-metadata.nvim",
    cmd = "DotfyleGenerate",
})

user({
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    config = true,
})

-- This is nice
user({
    "Sam-programs/expand.nvim",
    keys = { "<c-Space>" },
    dependencies = { "Sam-Programs/indent.nvim" },
    config = function()
        require("expand").setup({
            filetypes = {
                lua = {
                    -- if we are expanding on an unnamed function might aswell add the pairs
                    { "function\\s*$", { "()", "end" } },
                    { "function", { "", "end" } },
                    { "if", { " then", "end" } },
                    -- regex for a lua variable
                    { "^\\s*\\w\\+\\s*\\w*\\s*=\\s*$", { "{", "}" } },
                    { "", { " do", "end" } },
                },
                sh = {
                    { "elif", { " ;then", "" } },
                    { "if", { " ;then", "if" } },
                    { "case", { "", "esac" } },
                    { "while", { " do", "done" } },
                    { "for", { " do", "done" } },
                    { "", { "{", "}" } },
                },
                bash = {
                    { "elif", { " ;then", "" } },
                    { "if", { " ;then", "if" } },
                    { "case", { "", "esac" } },
                    { "while", { " do", "done" } },
                    { "for", { " do", "done" } },
                    { "", { "{", "}" } },
                },
                zsh = {
                    { "elif", { " then", "" } },
                    { "if", { " then", "if" } },
                    { "case", { "", "esac" } },
                    { "while", { " do", "done" } },
                    { "for", { " do", "done" } },
                    { "", { "{", "}" } },
                },
                c = {
                    { ".*(.*)", { "{", "}" } },
                    { "", { "{", "};" } },
                },
                cpp = {
                    { ".*(.*)", { "{", "}" } },
                    { "", { "{", "};" } },
                },
                python = {
                    {
                        "print",
                        {
                            "(",
                            ")",
                        },
                    },
                    { ".*(.*)", { ":", "" } },
                    { "", { ":", "" } },

                    {

                        "def",
                        {
                            "():",
                            "",
                        },
                    },
                },
            },

            hotkey = "<C-Space>",
        })
    end,
})

user({
    "nkakouros-original/scrollofffraction.nvim",
    event = "BufWinEnter",
    config = function()
        require("scrollofffraction").setup()
    end,
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

user({
    "theKnightsOfRohan/csvlens.nvim",
    dependencies = {
        "akinsho/toggleterm.nvim",
    },
    cmd = "Csvlens",
    config = true,
})
user({

    "neph-iap/easycolor.nvim",
    dependencies = { "stevearc/dressing.nvim" }, -- Optional, but provides better UI for editing the formatting template
    opts = {},
    cmd = {
        "EasyColor",
    },
})

-- TRIAL: (vsedov) (10:51:37 - 13/11/23): I am not sure what to think about this.

user({
    "mangelozzi/nvim-rgflow.lua",
    keys = {
        -- ";rG",
        -- ";rg",
        -- ";ro",
        -- ";ra",
        -- ";rc",
        -- ";rO",
        -- ";r?",

        {
            ";rG",
            desc = "rgflow: open blank",
        },
        {
            ";rg",
            desc = "rgflow: open cword",
        },
        {
            ";ro",
            desc = "rgflow: open paste",
        },
        {
            ";ra",
            desc = "rgflow: open again",
        },
        {
            ";rc",
            desc = "rgflow: abort",
        },
        {
            ";rO",
            desc = "rgflow: print cmd",
        },
        {
            ";r?",
            desc = "rgflow: print status",
        },
    },
    config = function()
        require("rgflow").setup({
            default_trigger_mappings = false,
            default_ui_mappings = true,
            default_quickfix_mappings = true,
            mappings = {
                trigger = {
                    -- Normal mode maps
                    n = {
                        [";rG"] = "open_blank", -- open UI - search pattern = blank
                        [";rg"] = "open_cword", -- open UI - search pattern = <cword>
                        [";ro"] = "open_paste", -- open UI - search pattern = First line of unnamed register as the search pattern
                        [";ra"] = "open_again", -- open UI - search pattern = Previous search pattern
                        [";rc"] = "abort", -- close UI / abort searching / abortadding results
                        [";rO"] = "print_cmd", -- Print a version of last run rip grep that can be pasted into a shell
                        [";r?"] = "print_status", -- Print info about the current state of rgflow (mostly useful for deving on rgflow)
                    },
                    -- Visual/select mode maps
                    x = {
                        [";rg"] = "open_visual", -- open UI - search pattern = current visual selection
                    },
                },
            },
            cmd_flags = "--smart-case --fixed-strings --no-fixed-strings --no-ignore --ignore --max-columns 500",
        })
    end,
})

user({
    "chipsenkbeil/distant.nvim",
    cmd = { "Distant" },
    config = function()
        require("distant"):setup()
    end,
})

user({
    "mrshmllow/open-handlers.nvim",
    -- We modify builtin functions, so be careful lazy loading
    lazy = false,
    cond = vim.ui.open ~= nil,
    config = function()
        local oh = require("open-handlers")

        oh.setup({
            -- In order, each handler is tried.
            -- The first handler to successfully open will be used.
            handlers = {
                oh.issue, -- A builtin which handles github and gitlab issues
                oh.commit, -- A builtin which handles git commits
                oh.native, -- Default native handler. Should always be last
            },
        })
    end,
})

user({
    "ariel-frischer/bmessages.nvim",
    cmd = {
        "Bmessages",
        "BmessagesVS",
        "Bmessagessp",
    },
    opts = {},
})

user({
    "2kabhishek/nerdy.nvim",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
})

-- this is great although it needs some refinement, one of them being that hydra, and heirline would
-- need to be completely reloaded for this to work . meaning an auto command is required so when
-- ever a new colourscheme is loaded from pineapple, you need to reset hydra and heirline, else this
-- is a rather nice plugin.

user({
    "stevearc/aerial.nvim",
    cmd = {
        "AerialPrev",
        "AerialNext",
        "AerialToggle",
        "AerialOpenAll",
        "AerialClose",
        "AerialCloseAll",
        "AerialGo",
        "AerialInfo",
        "AerialNavToggle",
        "AerialNavOpen",
        "AerialNavClose",
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = true,
    keys = {
        {
            "<leader>sw",
            function()
                vim.cmd("AerialToggle")
            end,
            desc = "Aerial Toggle",
        },
    },
})

user({
    "cbochs/portal.nvim",
    dependencies = {
        "ThePrimeagen/harpoon", -- Optional: provides the "harpoon" query item
    },
    opts = {
        window_options = {
            border = "rounded",
            relative = "cursor",
            height = 5,
        },
        select_first = true,
    },
    cmd = "Portal",
    keys = {
        {
            "<C-i>",
            function()
                require("portal.builtin").jumplist.tunnel_forward()
            end,
            desc = "portal fwd",
        },
        {
            "]o",
            function()
                require("portal.builtin").jumplist.tunnel_forward()
            end,
            desc = "portal fwd",
        },

        {
            "[o",
            function()
                require("portal.builtin").jumplist.tunnel_backward()
            end,
            desc = "portal fwd",
        },
        {
            "<C-o>",
            function()
                require("portal.builtin").jumplist.tunnel_backward()
            end,
            desc = "portal bwd",
        },
        -- TODO: use other queries?
    },
})

user({
    "lopi-py/luau-lsp.nvim",
    ft = "lua",
    config = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
})

user({
    "subnut/nvim-ghost.nvim",
    cond = false,
    config = function()
        -- All autocommands should be in 'nvim_ghost_user_autocommands' group
        local augroup_nvim_ghost_user_autocommands = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", {})
        local function addWebsiteSettings(opts) --  {{{
            vim.api.nvim_create_autocmd({ "User" }, {
                group = augroup_nvim_ghost_user_autocommands,
                pattern = opts.pattern,
                desc = opts.desc,
                callback = opts.callback,
            })
        end --  }}}

        addWebsiteSettings({
            pattern = { "www.overleaf.com" },
            desc = "nvim-ghost: set Overleaf settings",
            callback = function() --  {{{
                vim.opt.filetype = "tex"
                vim.opt.foldenable = false
                vim.opt.wrap = true

                -- avoid being overwriten by ftplugin
                vim.schedule(function()
                    vim.opt.textwidth = 0
                    vim.opt.tabstop = 4
                    vim.opt.shiftwidth = 0
                end)

                -- taken from markdown ftplugin
                for _, key in pairs({ "j", "k", "0", "$" }) do
                    vim.keymap.set("n", key, "g" .. key, {
                        desc = string.format("remap %s for better text editing", key),
                    })
                end
            end, --  }}}
        })

        addWebsiteSettings({
            pattern = { "github.com" },
            desc = "nvim-ghost: set GitHub settings",
            callback = function()
                vim.opt.filetype = "markdown"
            end,
        })
    end,
})

user({
    "klafyvel/nvim-smuggler",
    ft = "julia",
    opts = {
        mappings = true, -- set to false to disable all mappings.
        map_smuggle = "<leader>cs", -- Use `[count]<leader>cs` in normal mode to send count lines.
        map_smuggle_range = "<leader>cs", -- Use `<leader>cs` in visual mode to send the current selection.
        map_smuggle_config = "<leader>ce", -- Use `<leader>ce` in normal mode to reconfigure the plugin.
        map_smuggle_operator = "gcs", -- Use `gcs[text object]` to send a text object in normal mode.
    },
    dependencies = { "nvim-neotest/nvim-nio" },
})

user({
    "olimorris/persisted.nvim", -- Session management
    lazy = true,
    opts = {
        use_git_branch = true,
        silent = true,
        -- autoload = true,
        should_autosave = function()
            local excluded_filetypes = {
                "alpha",
                "oil",
                "lazy",
                "",
            }

            for _, filetype in ipairs(excluded_filetypes) do
                if vim.bo.filetype == filetype then
                    return false
                end
            end

            return true
        end,
    },
    cmd = {
        "Sessions",
        "SessionSave",
        "SessionStart",
        "SessionStop",
        "SessionDelete",
        "SessionToggle",
    },
})
user({
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
        require("silicon").setup({
            -- Configuration here, or leave empty to use defaults
            -- # use julia
            output = {
                -- (string) The full path of the file to save to.
                file = "",
                -- (boolean) Whether to copy the image to clipboard instead of saving to file.
                clipboard = true,
                -- (string) Where to save images, defaults to the current directory.
                --  e.g. /home/user/Pictures
                path = ".",
                -- (string) The filename format to use. Can include placeholders for date and time.
                -- https://time-rs.github.io/book/api/format-description.html#components
                format = "silicon_[year][month][day]_[hour][minute][second].png",
            },
            font = "JuliaMono",
            watermark = {
                text = "  Viv",
            },
            window_title = function()
                return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.")
            end,
        })
    end,
})

user({
    "xiyaowong/transparent.nvim",
    config = true,
    cmd = {
        "TransparentEnable",
        "TransparentDisable",
        "TransparentToggle",
    },
})

-- ┌                                          ┐
-- │                                          │
-- │ Very Lazy Scripts that i need to replace │
-- │                                          │
-- └                                          ┘

user({
    "mvllow/modes.nvim",
    cond = true,
    event = "ModeChanged",
    config = true,
})

user({
    "wallpants/github-preview.nvim",
    cmd = { "GithubPreviewToggle" },
    keys = { "<leader>mpt", "<leader>mps", "<leader>mpd" },
    opts = {},
    config = function(_, opts)
        local gpreview = require("github-preview")
        gpreview.setup(opts)

        local fns = gpreview.fns
        vim.keymap.set("n", "<leader>mpt", fns.toggle)
        vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
        vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
    end,
})

user({
    "IndianBoy42/kitty.lua",
    event = "VeryLazy",
    cond = not not vim.env.KITTY_PID,
    config = function()
        require("kitty.terms").setup({
            dont_attach = not not vim.g.kitty_scrollback,
            attach = {
                target_providers = {
                    function(T)
                        T.helloworld = { desc = "Hello world", cmd = "echo hello world" }
                    end,
                    "just",
                    "cargo",
                },
                current_win_setup = {},
                on_attach = function(_, K, _)
                    K.setup_make()
                end,
                bracketed_paste = true,
            },
        })
        local Terms = require("kitty.terms")
        local map = vim.keymap.set
        map("n", ";kk", function()
            Terms.get_terminal(0):run()
        end, { desc = "Kitty Run" })
        map("n", ";kK", function()
            Terms.get_terminal(0):make()
        end, { desc = "Kitty Make" })
        map("n", ";kkk", function()
            Terms.get_terminal(0):make("last")
        end, { desc = "Kitty ReMake" })
        map("n", ";krR", function()
            return Terms.get_terminal(0):send_operator()
        end, { expr = true, desc = "Kitty Send" })
        map("x", ";kR", function()
            return Terms.get_terminal(0):send_operator()
        end, { expr = true, desc = "Kitty Send" })
        map("n", ";krr", function()
            return Terms.get_terminal(0):send_operator({ type = "line", range = "$" })
        end, { expr = true, desc = "Kitty Send Line" })
        map("n", ";ky", function()
            Terms.get_terminal(0):get_selection()
        end, { desc = "Yank From Kitty" })
    end,
    keys = {
        {
            ";kok",
            "<cmd>Kitty<cr>",
            desc = "Kitty Open",
        },
        {
            ";koK",
            "<cmd>KittyOverlay<cr>",
            desc = "Kitty Open",
        },
    },
})
user({
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    config = true,
})
user({
    "jsongerber/thanks.nvim",
    event = "VeryLazy",
    config = true,
})
user({
    "Abstract-IDE/abstract-autocmds",
    lazy = false,
    config = function()
        require("abstract-autocmds").setup({
            auto_resize_splited_window = true,
            remove_whitespace_on_save = true,
            no_autocomment_newline = true,
            clear_last_used_search = true,
            highlight_on_yank = {
                enable = true,
                opts = {
                    timeout = 150,
                },
            },
            give_border = {
                enable = true,
                opts = {
                    pattern = { "null-ls-info", "lspinfo" },
                },
            },
            smart_dd = true,
            visually_codeblock_shift = true,
            move_selected_upndown = true,
            dont_suspend_with_cz = true,
            scroll_from_center = true,
            ctrl_backspace_delete = true,

            -- Binds that i already have that are better than this
            go_back_normal_in_terminal = false,
            smart_visual_paste = false, -- Enable this eventually
            smart_save_in_insert_mode = false,
            open_file_last_position = false,
        })
    end,
})
user({
    "tris203/precognition.nvim",
    cond = lambda.config.if_your_retarded,
    config = {
        startVisible = true,
        hints = {
            ["^"] = { text = "^", prio = 1 },
            ["$"] = { text = "$", prio = 1 },
            ["w"] = { text = "w", prio = 10 },
            ["b"] = { text = "b", prio = 10 },
            ["e"] = { text = "e", prio = 10 },
        },
        gutterHints = {
            --prio is not currentlt used for gutter hints
            ["G"] = { text = "G", prio = 1 },
            ["gg"] = { text = "gg", prio = 1 },
            ["{"] = { text = "{", prio = 1 },
            ["}"] = { text = "}", prio = 1 },
        },
    },
})
