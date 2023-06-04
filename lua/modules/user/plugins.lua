local user = require("core.pack").package
local ui = lambda.highlight
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

-- PetsNew {name}: creates a pet with the style and type defined by the configuration, and name {name}
-- PetsNewCustom {type} {style} {name}: creates a new pet with type, style and name specified in the command
-- PetsList: prints the names of all the pets that are currently alive
-- PetsKill {name}: kills the pet with given name, which will immediately blink out of existence. Forever.
-- PetsKillAll: kills all the pets, poor creatures. Works just as PetsKill but for every pet.
-- PetsPauseToggle: pause/resume animations for all pets, leaving them on screen as cute little statues
-- PetsHideToggle: pause the animation for all pets and hide them / show all the pets again and resume animations
-- PetsIdleToggle/PetsSleepToggle: basically a do-not-disturb mode, pets are still animated but do not move around
--  TODO: (vsedov) (12:44:30 - 01/05/23): Create a command for this
user({
    "giusgad/pets.nvim",
    lazy = true,
    cmd = {
        "PetsNew",
        "PetsNewCustom",
        "PetsList",
        "PetsKill",
        "PetsKillAll",
        "PetsPauseToggle",
        "PetsHideToggle",
        "PetsIdleToggle",
        "PetsSleepToggle",
    },
    dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
    config = true,
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
    init = function()
        vim.o.dictionary = "/usr/share/dict/cracklib-small"

        -- default settings
        vim.g.spellbound_settings = {
            mappings = {
                toggle_map = "\\zS",
                fix_right = "\\zp",
                fix_left = "\\zn",
            },
            language = "en_gb",
            autospell_filetypes = { "*.txt", "*.md", "*.rst" },
            autospell_gitfiles = true,
            number_suggestions = 10,
            return_to_position = false,
        }
    end,
})

user({
    "olimorris/persisted.nvim",
    cond = lambda.config.tools.use_session,
    event = "VeryLazy",
    init = function()
        lambda.command("ListSessions", "Telescope persisted", {})
        lambda.augroup("PersistedEvents", {
            {
                event = "User",
                pattern = "PersistedTelescopeLoadPre",
                command = function()
                    vim.schedule(function()
                        vim.cmd("%bd")
                    end)
                end,
            },
            {
                event = "User",
                pattern = "PersistedSavePre",
                -- Arguments are always persisted in a session and can't be removed using 'sessionoptions'
                -- so remove them when saving a session
                command = function()
                    vim.cmd("%argdelete")
                end,
            },
        })
    end,
    opts = {
        autoload = true,
        use_git_branch = true,
        allowed_dirs = { "/Github" },
        ignored_dirs = { vim.fn.stdpath("data") },
    },
    config = function(_, opts)
        require("persisted").setup(opts)
        require("telescope").load_extension("persisted")
    end,
})

-- Need to add these plugins, But, for now  i have these on hold
-- ○ control-panel.nvim not core
-- ○ leap-search.nvim core
-- ○ leap-wide.nvim core  and its dependencies

user({
    "linty-org/readline.nvim",
    keys = {
        {
            "<M-f>",
            function()
                require("readline").forward_word()
            end,
            mode = "!",
        },
        {
            "<M-b>",
            function()
                require("readline").backward_word()
            end,
            mode = "!",
        },
        {
            "<C-a>",
            function()
                require("readline").beginning_of_line()
            end,
            mode = "!",
        },
        {
            "<C-e>",
            function()
                require("readline").end_of_line()
            end,
            mode = "!",
        },
        {
            "<M-d>",

            function()
                require("readline").kill_word()
            end,
            mode = "!",
        },
        {
            "<M-BS>",
            function()
                require("readline").backward_kill_word()
            end,
            mode = "!",
        },
        {
            "<C-w>",
            function()
                require("readline").unix_word_rubout()
            end,
            mode = "!",
        },
        {
            "<C-u>",

            function()
                require("readline").backward_kill_line()
            end,
            mode = "!",
        },
    },
})
user({
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = { "onsails/lspkind.nvim" },
    keys = {
        {
            "<leader>wp",
            function()
                require("dropbar.api").pick()
            end,
            desc = "winbar: pick",
        },
    },
    config = function()
        require("dropbar").setup({
            general = {
                enable = function(buf, win)
                    local b, w = vim.bo[buf], vim.wo[win]
                    local decor = lambda.style.decorations.get({ ft = b.ft, bt = b.bt, setting = "winbar" })

                    return decor.ft ~= false
                        and b.bt == ""
                        and not w.diff
                        and not vim.api.nvim_win_get_config(win).zindex
                        and vim.api.nvim_buf_get_name(buf) ~= ""
                end,
            },
            icons = {
                ui = { bar = { separator = " " .. lambda.style.icons.misc.arrow_right .. " " } },
                kinds = {
                    symbols = vim.tbl_map(function(value)
                        return value .. " "
                    end, require("lspkind").symbol_map),
                },
            },
            menu = {
                win_configs = {
                    border = lambda.style.border.type_0,
                    col = function(menu)
                        return menu.parent_menu and menu.parent_menu._win_configs.width + 1 or 0
                    end,
                },
            },
        })
    end,
})

--  TODO: (vsedov) (07:41:40 - 03/06/23): I am not sure if i need this yet
user({
    "yagiziskirik/AirSupport.nvim",
    requires = {
        { "nvim-telescope/telescope.nvim" },
        { "nvim-lua/plenary.nvim" },
    },
    keys = {
        {
            "<leader>?",
            function()
                vim.cmd([[AirSupport]])
            end,
            mode = "n",
        },
    },
    config = true,
})
user({
    "FluxxField/bionic-reading.nvim",
    event = "VeryLazy",
    config = true,
})
user({
    "milanglacier/yarepl.nvim",
    lazy = true,
    cmd = {

        "REPLStart",
        "REPLAttachBufferToREPL",
        "REPLDetachBufferToREPL",
        "REPLCleanup",
        "REPLFocus",
        "REPLHide",
        "REPLClose",
        "REPLSwap",
        "REPLSendVisual",
        "REPLSendLine",
        "REPLSendMotion",
    },
    init = function()
        lambda.augroup("REPL", {
            {
                event = { "FileType" },
                pattern = { "quarto", "markdown", "markdown.pandoc", "rmd", "python", "sh", "REPL" },
                desc = "set up REPL keymap",
                command = function()
                    local utils = require("modules.editor.hydra.repl_utils")
                    vim.keymap.set("n", "<localleader>r", function()
                        utils.run_cmd_with_count("REPLStart " .. utils.ft_to_repl[vim.bo.filetype])()
                        local data = require("hydra")(require("modules.editor.hydra.normal.repl"))
                        data:activate()
                        vim.schedule_wrap(data:activate())
                    end, { desc = "Start an REPL", buffer = 0 })
                    vim.keymap.set("n", "<localleader>sc", utils.send_a_code_chunk, {
                        desc = "send a code chunk",
                        expr = true,
                        buffer = 0,
                    })
                end,
            },
        })
    end,
    config = function()
        vim.g.REPL_use_floatwin = 0
        require("yarepl").setup({
            wincmd = function(bufnr, name)
                if vim.g.REPL_use_floatwin == 1 then
                    vim.api.nvim_open_win(bufnr, true, {
                        relative = "editor",
                        row = math.floor(vim.o.lines * 0.25),
                        col = math.floor(vim.o.columns * 0.25),
                        width = math.floor(vim.o.columns * 0.5),
                        height = math.floor(vim.o.lines * 0.5),
                        style = "minimal",
                        title = name,
                        border = "rounded",
                        title_pos = "center",
                    })
                else
                    vim.cmd([[belowright 15 split]])
                    vim.api.nvim_set_current_buf(bufnr)
                end
            end,
        })
    end,
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
