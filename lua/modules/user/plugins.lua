local user = require("core.pack").package
local api, fn = vim.api, vim.fn
user({
    "Dhanus3133/LeetBuddy.nvim",

    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    cmd = {

        "LBQuestions",
        "LBQuestion",
        "LBReset",
        "LBTest",
        "LBSubmit",
        "LeetActivate",
    },
    config = function()
        require("leetbuddy").setup({ language = "py" })
        lambda.command("LeetActivate", function()
            local binds = {
                ["<leader>lq"] = ":LBQuestions<cr>",
                ["<leader>ll"] = ":LBQuestion<cr>",
                ["<leader>lr"] = ":LBReset<cr>",
                ["<leader>lt"] = ":LBTest<cr>",
                ["<leader>ls"] = ":LBSubmit<cr>",
            }
            for x, v in pairs(binds) do
                vim.keymap.set("n", x, v, { noremap = true, silent = true })
            end
        end, {})
    end,
})

user({
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    opts = { setup_widgets = true, timer = { throttle = 100 } },
})

user({
    "krivahtoo/silicon.nvim",
    lazy = true,
    build = "./install.sh build",
    cmd = { "Silicon" },
    config = function()
        require("silicon").setup({
            font = "FantasqueSansMono Nerd Font=16",
            theme = "Monokai Extended",
        })
    end,
})

-- :NR  - Open the selected region in a new narrowed window
-- :NW  - Open the current visual window in a new narrowed window
-- :WR  - (In the narrowed window) write the changes back to the original buffer.
-- :NRV - Open the narrowed window for the region that was last visually selected.
-- :NUD - (In a unified diff) open the selected diff in 2 Narrowed windows
-- :NRP - Mark a region for a Multi narrowed window
-- :NRM - Create a new Multi narrowed window (after :NRP) - experimental!
-- :NRS - Enable Syncing the buffer content back (default on)
-- :NRN - Disable Syncing the buffer content back
-- :NRL - Reselect the last selected region and open it again in a narrowed window
user({
    "chrisbra/NrrwRgn",
    lazy = true,
    cmd = {
        "NR",
        "NW",
        "WR",
        "NRV",
        "NUD",
        "NRP",
        "NRM",
        "NRS",
        "NRN",
        "NRL",
    },
    init = function()
        vim.g.nrrw_rgn_vert = 1
        vim.g.nrrw_rgn_resize_window = "relative"
        vim.g.nrrw_rgn_wdth = 20
        vim.g.nrrw_rgn_rel_min = 50
        vim.g.nrrw_rgn_rel_max = 50
        vim.g.nrrw_rgn_nomap_nr = 1
        vim.g.nrrw_rgn_nomap_Nr = 1
    end,
})

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
    event = "VeryLazy",
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

user({
    "linty-org/readline.nvim",
    lazy = true,
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
                require("readline").backward_kill_line()
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
            "<C-d>",
            "<Delete>",
            desc = "delete-char",
            mode = "!",
        },
        {
            "<C-h>",
            "<BS>",
            desc = "backward-delete-char",
            mode = "!",
        },
        {
            "<C-a>",
            function()
                require("readline").beginning_of_line()
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
    init = function()
        lambda.highlight.plugin("DropBar", {
            { DropBarIconUISeparator = { link = "Delimiter" } },
            { DropBarMenuNormalFloat = { inherit = "Pmenu" } },
        })
    end,
    config = {
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
                border = "shadow",
                col = function(menu)
                    return menu.prev_menu and menu.prev_menu._win_configs.width + 1 or 0
                end,
            },
        },
    },
})

-- First of all, :Sayonara or :Sayonara!
-- will only delete the buffer, if it isn't shown in any other window.
-- Otherwise :bdelete would close these windows as well.
-- Therefore both commands always only affect the current window.
-- This is what the user expects and is easy reason about.
user({
    "akdevservices/vim-sayonara",
    branch = "confirmations",
    keys = {
        {
            "<leader>Q",
            function()
                vim.cmd([[Sayonara!]])
            end,
            desc = "Sayonara!",
        },
    },
    cmd = { "Sayonara" },
})

-- might be useful, im not sure.
user({
    "thinca/vim-partedit",
    cmd = "Partedit",
    init = function()
        vim.g["partedit#opener"] = "vsplit"
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
user({
    "azabiong/vim-highlighter",
    keys = {
        {
            "m<cr>",
            desc = "Mark word",
        },
        {
            "m<bs>",
            desc = "Mark delete",
        },
        {
            "mD>",
            desc = "Mark clear",
        },
        {
            "M<cr>",
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
    "Aasim-A/scrollEOF.nvim",
    event = "VeryLazy",
    config = true,
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
    init = function()
        local wk = require("which-key")
        wk.register({
            mode = { "n" },
            [",t"] = { name = "+TreePin" },
        })
    end,
    opts = {
        seperator = "▔",
    },
})
user({
    "lewis6991/whatthejump.nvim",
    keys = { "<c-i>", "<c-o>" },
})
user({
    "smoka7/multicursors.nvim",
    opts = function()
        local N = require("multicursors.normal_mode")
        local I = require("multicursors.insert_mode")
        return {
            normal_keys = {
                -- to change default lhs of key mapping change the key
                ["b"] = {
                    -- assigning nil to method exits from multi cursor mode
                    method = N.clear_others,
                    -- description to show in hint window
                    desc = "Clear others",
                },
            },
            insert_keys = {
                -- to change default lhs of key mapping change the key
                ["<CR>"] = {
                    -- assigning nil to method exits from multi cursor mode
                    method = I.Cr_method,
                    -- description to show in hint window
                    desc = "new line",
                },
            },
            -- accepted values:
            -- -1 true: generate hints
            -- -2 false: don't generate hints
            -- -3 [[multi line string]] provide your own hints
            generate_hints = {
                normal = true,
                insert = true,
                extend = true,
            },
        }
    end,
    keys = {
        {
            "<Leader>m",
            "<cmd>MCstart<cr>",
            desc = "Create a selection for word under the cursor",
        },
    },
})

--  ──────────────────────────────────────────────────────────────────────
user({
    "thinca/vim-qfreplace",
    ft = "qf",
    lazy = true,
})
--  ──────────────────────────────────────────────────────────────────────
user({ -- https://github.com/fregante/GhostText
    "subnut/nvim-ghost.nvim",
    build = ":call nvim_ghost#installer#install()",
    lazy = false,
    config = function()
        vim.g.nvim_ghost_super_quiet = 1
        vim.cmd([[
				augroup nvim_ghost_user_autocommands
					au User *github.com,*stackoverflow.com,*reddit.com setfiletype markdown
					au User *github.com,*stackoverflow.com,*reddit.com let b:copilot_enabled=1
					au User *github.com,*stackoverflow.com,*reddit.com setlocal spell
				augroup END
			]])
    end,
})
--  ──────────────────────────────────────────────────────────────────────
--  TODO: (vsedov) (04:19:41 - 20/07/23): this can be a potential hydra: But im not sure if the usecase meets the need.
user({
    "RutaTang/quicknote.nvim",
    branch = "custom_filetype",

    keys = {
        ";q",
    },
    init = function()
        local quicknote_path = vim.fn.stdpath("state") .. "/quicknote"
        if not vim.loop.fs_stat(quicknote_path) then
            vim.fn.system({ "mkdir", quicknote_path })
        end
    end,
    opts = {
        filetype = "norg",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
        require("quicknote").setup(opts)
        require("quicknote").ShowNoteSigns()
        -- NOTE: (vsedov) (04:55:24 - 20/07/23): Need to be revamped the binds arent the best and
        -- there are some intrusive things about this that i think could be improved.

        vim.defer_fn(function()
            local make_hydra = require("modules.editor.hydra.make_hydra").make_hydra
            local config = {
                QuickNote = {
                    color = "red",
                    body = ";q",
                    mode = { "n" },
                    on_key = function()
                        vim.wait(50)
                    end,

                    ["<ESC>"] = { nil, { exit = true } },
                    n = {
                        function()
                            require("quicknote").OpenNoteAtCurrentLine()
                        end,
                        { exit = true, desc = "New Sign" },
                    },
                    ["<cr>"] = {
                        function()
                            require("quicknote").NewNoteAtCurrentLine()
                            require("quicknote").ShowNoteSigns()
                            require("quicknote").OpenNoteAtCurrentLine()
                        end,
                        { exit = true, desc = "Open at line" },
                    },
                    d = {
                        function()
                            require("quicknote").DeleteNoteAtCurrentLine()
                        end,
                        { exit = false, desc = "Delete at line" },
                    },
                    l = {
                        function()
                            require("quicknote").ListNotesForCurrentBuffer()
                        end,
                        { exit = true, desc = "List C buffer" },
                    },
                    j = {
                        function()
                            require("quicknote").JumpToNextNote()
                        end,
                        { exit = false, desc = "Jump to next note" },
                    },
                    k = {
                        function()
                            require("quicknote").JumpToPreviousNote()
                        end,
                        { exit = false, desc = "Jump to previous note" },
                    },
                    s = {
                        function()
                            require("quicknote").ToggleNoteSigns()
                        end,
                        { exit = false, desc = "Toggle note signs" },
                    },
                    m = {
                        function()
                            require("quicknote").ToggleMode()
                        end,
                        { exit = true, desc = "Toggle mode" },
                    },
                    i = {
                        function()
                            require("quicknote").ImportNotesForCurrentBuffer()
                        end,
                        { exit = true, desc = "Import C buffer" },
                    },
                    x = {
                        function()
                            require("quicknote").ExportNotesForCurrentBuffer()
                        end,
                        { exit = true, desc = "Export C buffer" },
                    },
                    -- Using uppercase letters
                    N = {
                        function()
                            require("quicknote").NewNoteAtCWD()
                        end,
                        { exit = true, desc = "New at CWD" },
                    },
                    ["<leader>"] = {
                        function()
                            require("quicknote").OpenNoteAtCWD()
                        end,
                        { exit = true, desc = "Open at CWD" },
                    },
                    D = {
                        function()
                            require("quicknote").DeleteNoteAtCWD()
                        end,
                        { exit = true, desc = "Delete at CWD" },
                    },
                    L = {
                        function()
                            require("quicknote").ListNotesForCWD()
                        end,
                        { exit = true, desc = "List for CWD" },
                    },
                    I = {
                        function()
                            require("quicknote").ImportNotesForCWD()
                        end,
                        { exit = true, desc = "Import for CWD" },
                    },
                    X = {
                        function()
                            require("quicknote").ExportNotesForCWD()
                        end,
                        { exit = true, desc = "Export for CWD" },
                    },

                    G = {
                        function()
                            require("quicknote").SwitchToResidentMode()
                            -- Use the mode switch functions according to the current mode
                        end,
                        { exit = true, desc = "Switch to Resident Mode" },
                    },
                    P = {
                        function()
                            require("quicknote").SwitchToPortableMode()
                            -- Use the mode switch functions according to the current mode
                        end,
                        { exit = true, desc = "Switch to Portable Mode" },
                    },
                },
            }
            make_hydra({
                config,
                "QuickNote",
                { { "<leader>", "N", "D", "L" }, { "I", "X", "G", "P" }, { "m", "i", "x" } },
                { "<cr>", "n", "d", "j", "k", "s", "l" },
            })
        end, 500)
    end,
})
-- --[[ This thing causes issues with respect to cmdheight=0 ]]
user({
    "chaoren/vim-wordmotion",
    lazy = true,
    event = "VeryLazy",
    config = function()
        vim.g.wordmotion_prefix = ","
    end,
})
user({
    "mrshmllow/open-handlers.nvim",
    lazy = false,
    event = "VeryLazy",
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
