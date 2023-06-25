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
    config = {
        general = {
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
        menu = {
            win_configs = {
                border = lambda.style.border.type_0,
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

-- If there is regex, this seems very nice to work with .
user({
    "tomiis4/Hypersonic.nvim",
    cmd = "Hypersonic",
    keys = {
        {
            "<leader>r",
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
user({
    "tversteeg/registers.nvim",
    keys = {
        { '"', mode = { "n", "v" } },
        { "<C-R>", mode = "i" },
    },
    cmd = "Registers",
    config = true,
})
user({
    "haya14busa/vim-edgemotion",
    keys = {
        { "<c-'>", "<Plug>(edgemotion-j)", mode = "" },
        { "<c-#>", "<Plug>(edgemotion-k)", mode = "" },
    },
})
user({
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
        require("terminal").setup()
    end,
})
user({
    "kiran94/maim.nvim",
    config = true,
    cmd = { "Maim", "MaimMarkdown" },
})
