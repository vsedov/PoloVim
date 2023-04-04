local user = require("core.pack").package

user({
    "p00f/cphelper.nvim",
    cmd = {
        "CphReceive",
        "CphTest",
        "CphReTest",
        "CphEdit",
        "CphDelete",
    },

    lazy = true,
    config = function()
        vim.g["cph#lang"] = "python"
        vim.g["cph#border"] = lambda.style.border.type_0
    end,
})

user({
    "jackMort/pommodoro-clock.nvim",
    lazy = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    keys = {
        ";1",
        ";2",
        ";3",
        ";4",
        ";5",
    },
    config = function()
        require("pommodoro-clock").setup({})
        vim.keymap.set("n", ";1", function()
            require("pommodoro-clock").toggle_pause()
        end)

        vim.keymap.set("n", ";2", function()
            require("pommodoro-clock").start("work")
        end)
        vim.keymap.set("n", ";3", function()
            require("pommodoro-clock").start("short_break")
        end)
        vim.keymap.set("n", ";4", function()
            require("pommodoro-clock").start("long_break")
        end)
        vim.keymap.set("n", ";5", function()
            require("pommodoro-clock").close()
        end)
    end,
})
--
user({
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    opts = { setup_widgets = true, timer = { throttle = 100 } },
})

user({
    "mskelton/local-yokel.nvim",
    lazy = true,
    cmd = { "E" },
    config = true,
})

user({
    "kwakzalver/duckytype.nvim",
    lazy = true,
    cmd = {
        "PythonSpell",
        "EnglishSpell",
        "DuckyType",
    },
    opts = {
        {
            expected = "python_keywords",
            number_of_words = 42,
            average_word_length = 5.69,
        },
    },
    init = function()
        lambda.command("EnglishSpell", function()
            require("duckytype").Start("english_common")
        end, {})
        lambda.command("PythonSpell", function()
            require("duckytype").Start("python_keywords")
        end, {})
    end,
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

--
-- PetsNew {name}: creates a pet with the style and type defined by the configuration, and name {name}
-- PetsNewCustom {type} {style} {name}: creates a new pet with type, style and name specified in the command
-- PetsList: prints the names of all the pets that are currently alive
-- PetsKill {name}: kills the pet with given name, which will immediately blink out of existence. Forever.
-- PetsKillAll: kills all the pets, poor creatures. Works just as PetsKill but for every pet.
-- PetsPauseToggle: pause/resume animations for all pets, leaving them on screen as cute little statues
-- PetsHideToggle: pause the animation for all pets and hide them / show all the pets again and resume animations
-- PetsIdleToggle/PetsSleepToggle: basically a do-not-disturb mode, pets are still animated but do not move around
user({
    "giusgad/pets.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
    config = function()
        require("pets").setup({
            -- your options here
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
    event = "VeryLazy",
    init = function()
        vim.g.nrrw_rgn_vert = 1
        -- Set the size (absolute=rows or cols, relative=percentage)
        vim.g.nrrw_rgn_resize_window = "relative"
        -- Set the new buffer size
        vim.g.nrrw_rgn_wdth = 20
        vim.g.nrrw_rgn_rel_min = 50
        vim.g.nrrw_rgn_rel_max = 50
    end,
})

user({
    "axieax/urlview.nvim",
    keys = { "\\u", "\\U" },
    cmd = { "UrlView" },
    config = function()
        require("urlview").setup({})
        vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
        vim.keymap.set("n", "\\U", "<Cmd>UrlView lazy<CR>", { desc = "view plugin URLs" })
    end,
})

user({
    "kiyoon/haskell-scope-highlighting.nvim",
    lazy = true,
    ft = { "haskell" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    init = function()
        -- Consider disabling other highlighting
        vim.cmd([[autocmd FileType haskell syntax off]])
        vim.cmd([[autocmd FileType haskell TSDIsable highlight]])
    end,
})

user({
    "mikesmithgh/render.nvim",
    cmd = { "Render", "RenderClean", "RenderQuickfix" },
    lazy = true,
    cond = false,
    enable = false,
    config = true,
})
user({
    "JosefLitos/reform.nvim",
    cond = false,
    event = "VeryLazy",
    build = "make",
    config = true, -- automatically call reform.setup(), use [opts] to customize passed table
})
user({
    "glepnir/nerdicons.nvim",
    cmd = "NerdIcons",
    config = true,
})
user({
    "letieu/hacker.nvim",
    cmd = { "Hack", "HackFollow" },
    config = function()
        require("hacker").setup({
            content = [[
local plenary_dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"
local is_not_a_directory = vim.fn.isdirectory(plenary_dir) == 0
if is_not_a_directory then
  vim.fn.system({ "git", "clone", "https://github.com/nvim-lua/plenary.nvim", plenary_dir })
end

vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_dir)

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")

            ]], -- The code snippet that show when typing
            filetype = "lua", -- filetype of code snippet
            speed = { -- characters insert each time, random from min -> max
                min = 2,
                max = 10,
            },
            is_popup = false, -- show random float window when typing
            popup_after = 5,
        })
    end,
})
