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
    dependencies = { "stevearc/dressing.nvim", cond = false }, -- Optional, but provides better UI for editing the formatting template
    config = true,
    cmd = {
        "EasyColor",
    },
})

-- TRIAL: (vsedov) (10:51:37 - 13/11/23): I am not sure what to think about this.

user({
    "mangelozzi/nvim-rgflow.lua",
    keys = {
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
        { "stevearc/dressing.nvim", cond = false },
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
    "wallpants/github-preview.nvim",
    cmd = { "GithubPreviewToggle" },
    keys = { "<leader>Mpt", "<leader>Mps", "<leader>Mpd" },
    opts = {},
    config = function(_, opts)
        local gpreview = require("github-preview")
        gpreview.setup(opts)

        local fns = gpreview.fns
        vim.keymap.set("n", "<leader>Mpt", fns.toggle)
        vim.keymap.set("n", "<leader>Mps", fns.single_file_toggle)
        vim.keymap.set("n", "<leader>Mpd", fns.details_tags_toggle)
    end,
})

user({
    "Pheon-Dev/buffalo-nvim",
    keys = {
        ";;;",
        ";;<leader>",
    },
    config = function()
        -- Keymaps
        local opts = { noremap = true }
        local map = vim.keymap.set
        local buffalo = require("buffalo.ui")
        map({ "t", "n" }, ";;;", buffalo.toggle_buf_menu, opts)
        map({ "t", "n" }, ";;<leader>", buffalo.toggle_tab_menu, opts)
        require("buffalo").setup()
    end,
})

user({
    "vzze/calculator.nvim",
    opt = true,
    config = function()
        vim.api.nvim_create_user_command(
            "Calculate",
            'lua require("calculator").calculate()',
            { ["range"] = 1, ["nargs"] = 0 }
        )
    end,
    cmd = { "Calculate" },
})
user({
    "zeioth/none-ls-autoload.nvim",
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason.nvim",
        "zeioth/none-ls-external-sources.nvim", -- To install a external sources library.
    },
    opts = {},
})

user({
    "Isrothy/neominimap.nvim",
    init = function()
        vim.opt.wrap = false -- Recommended
        vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
        vim.g.neominimap = {
            -- Enable the plugin by default
            auto_enable = true,
            minimap_width = 14,

            -- Log level
            log_level = vim.log.levels.OFF,

            -- Notification level
            notification_level = vim.log.levels.INFO,

            -- Path to the log file
            log_path = vim.fn.stdpath("data") .. "/neominimap.log",

            -- Minimap will not be created for buffers of these types
            exclude_filetypes = { "help" },

            -- Minimap will not be created for buffers of these types
            exclude_buftypes = {
                "nofile",
                "nowrite",
                "quickfix",
                "terminal",
                "prompt",
            },
            -- Diagnostic integration
            diagnostic = {
                enabled = true,
                severity = vim.diagnostic.severity.WARN,
                priority = {
                    ERROR = 100,
                    WARN = 90,
                    INFO = 80,
                    HINT = 70,
                },
            },

            treesitter = {
                enabled = true,
                priority = 200,
            },
            -- Border style of the floating window
            -- Accepts all usual border style options (e.g., "single", "double")
            window_border = "single",
        }
    end,
})
user({
    "svampkorg/moody.nvim",
    cond = true,
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    opts = {
        -- you can set different blend values for your different modes.
        -- Some colours might look better more dark, so set a higher value
        -- will result in a darker shade.
        blends = {
            normal = 0.2,
            insert = 0.2,
            visual = 0.25,
            command = 0.2,
            operator = 0.2,
            replace = 0.2,
            select = 0.2,
            terminal = 0.2,
            terminal_n = 0.2,
        },
        disabled_filetypes = { "TelescopePrompt" },
        bold_nr = true,
    },
})
user({
    "mvllow/modes.nvim",
    cond = false,
    event = "ModeChanged",
    config = true,
})
user({
    "tristone13th/lspmark.nvim",
    config = function()
        require("lspmark").setup()
        require("telescope").load_extension("lspmark")
    end,
    keys = {
        { "<leader>m", "", desc = "Bookmark" },
        { "<leader>mb", "<cmd>Telescope lspmark<cr>", desc = "Bookmark" },
        {
            "<leader>mn",
            function()
                require("lspmark.bookmarks").toggle_bookmark({ with_comment = false })
            end,
            desc = "Bookmark",
        },
        {
            "<leader>mc",
            function()
                require("lspmark.bookmarks").toggle_bookmark({ with_comment = true })
            end,
            desc = "Bookmark With Comment",
        },
        {
            "<leader>ms",
            function()
                vim.cmd([[lua require("lspmark.bookmarks").show_comment()]])
            end,
            desc = "Show Comment",
        },
        {
            "<leader>me",
            function()
                require("lspmark.bookmarks").modify_comment()
            end,
            desc = "Modify Comment",
        },
        {
            "<leader>md",
            function()
                require("lspmark.bookmarks").delete_line()
            end,
            desc = "Delete Line",
        },
        {
            "<leader>mv",
            function()
                require("lspmark.bookmarks").delete_visual_selection()
            end,
            desc = "Delete Selection",
        },
        {
            "<leader>mp",
            function()
                require("lspmark.bookmarks").paste_text()
            end,
            desc = "Paste Text",
        },
    },
})
user({
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    config = function()
        require("hunk").setup()
    end,
})
user({
    "fouladi/toggle-overlength.nvim",
    cmd = "ToggleHiOverLength",
    config = function()
        require("toggle-overlength").setup({})
    end,
})

user({
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
        vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("gx").setup({
            open_browser_app = "waterfox", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
            -- open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
            handlers = {
                plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
                github = true, -- open github issues
                brewfile = true, -- open Homebrew formulaes and casks
                package_json = true, -- open dependencies from package.json
                search = true, -- search the web/selection on the web if nothing else is found
                go = true, -- open pkg.go.dev from an import statement (uses treesitter)
                jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
                    name = "jira", -- set name of handler
                    handle = function(mode, line, _)
                        local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
                        if ticket and #ticket < 20 then
                            return "http://jira.company.com/browse/" .. ticket
                        end
                    end,
                },
                rust = { -- custom handler to open rust's cargo packages
                    name = "rust", -- set name of handler
                    filetype = { "toml" }, -- you can also set the required filetype for this handler
                    filename = "Cargo.toml", -- or the necessary filename
                    handle = function(mode, line, _)
                        local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

                        if crate then
                            return "https://crates.io/crates/" .. crate
                        end
                    end,
                },
            },
            handler_options = {
                search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
                select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link
                git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
                git_remote_push = function(fname) -- you can also pass in a function
                    return fname:match("myproject")
                end,
            },
        })
    end,
})
