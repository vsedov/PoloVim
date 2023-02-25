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
user({
    "giusgad/pets.nvim",
    cmd = {
        "PetsNew",
        "PetsNewCustom",
        "PetsList",
        "PetsKill",
        "PetsKillAll",
        "PetsPauseToggle",
        "PetsHideToggle",
        "PetsSleepToggle",
    },
    dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
    opts = {
        default_pet = "aloof",
        default_style = "black",
    },
    config = true,
})

user({
    "Davidyz/lsp-location-handler.nvim",
    lazy = true,
    event = "LspAttach",
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
        event = "VeryLazy",

    init = function()
        vim.g.nrrw_rgn_vert = 1
        -- Set the size (absolute=rows or cols, relative=percentage)
        vim.g.nrrw_rgn_resize_window = 'relative'
        -- Set the new buffer size
        vim.g.nrrw_rgn_wdth = 20
        vim.g.nrrw_rgn_rel_min = 50
        vim.g.nrrw_rgn_rel_max = 50
    end,
})


user({
    "axieax/urlview.nvim", 
    keys = {"\\u", "\\U"},
    cmd = {"UrlView"},
    config = function()
        require("urlview").setup({})
        vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
        vim.keymap.set("n", "\\U", "<Cmd>UrlView lazy<CR>", { desc = "view plugin URLs" })
    end
})