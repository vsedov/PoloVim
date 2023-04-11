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
    "mrcjkb/haskell-tools.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional
    },
    branch = "1.x.x", -- recommended
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
user({
    "chrisgrieser/nvim-early-retirement",
    cond = true,
    config = true,
    event = "VeryLazy",
})

user({
    "rebelot/terminal.nvim",
    event = "VeryLazy",
    config = function()
        require("terminal").setup()

        local term_map = require("terminal.mappings")
        vim.keymap.set(
            { "n", "x" },
            "<leader>ts",
            term_map.operator_send,
            { expr = true, desc = "Operat1or: send to terminal" }
        )
        vim.keymap.set("n", "<leader>to", term_map.toggle, { desc = "toggle terminal" })
        vim.keymap.set("n", "<leader>tO", term_map.toggle({ open_cmd = "enew" }), { desc = "toggle terminal" })
        vim.keymap.set("n", "<leader>tr", term_map.run, { desc = "run terminal" })
        vim.keymap.set(
            "n",
            "<leader>tR",
            term_map.run(nil, { layout = { open_cmd = "enew" } }),
            { desc = "run terminal" }
        )
        vim.keymap.set("n", "<leader>tk", term_map.kill, { desc = "kill terminal" })
        vim.keymap.set("n", "<leader>t]", term_map.cycle_next, { desc = "cycle terminal" })
        vim.keymap.set("n", "<leader>t[", term_map.cycle_prev, { desc = "cycle terminal" })
        vim.keymap.set("n", "<leader>tl", term_map.move({ open_cmd = "belowright vnew" }), { desc = "move terminal" })
        vim.keymap.set("n", "<leader>tL", term_map.move({ open_cmd = "botright vnew" }), { desc = "move terminal" })
        vim.keymap.set("n", "<leader>th", term_map.move({ open_cmd = "belowright new" }), { desc = "move terminal" })
        vim.keymap.set("n", "<leader>tH", term_map.move({ open_cmd = "botright new" }), { desc = "move terminal" })
        vim.keymap.set("n", "<leader>tf", term_map.move({ open_cmd = "float" }), { desc = "move terminal" })

        local ipython = require("terminal").terminal:new({
            layout = { open_cmd = "botright vertical new" },
            cmd = { "ipython" },
            autoclose = true,
        })

        vim.api.nvim_create_user_command("IPython", function()
            ipython:toggle(nil, true)
            local bufnr = vim.api.nvim_get_current_buf()
            vim.keymap.set("x", "<leader>ts", function()
                vim.api.nvim_feedkeys('"+y', "n", false)
                ipython:send("%paste")
            end, { buffer = bufnr })
            vim.keymap.set("n", "<leader>t?", function()
                ipython:send(vim.fn.expand("<cexpr>") .. "?")
            end, { buffer = bufnr })
        end, {})

        local lazygit = require("terminal").terminal:new({
            layout = { open_cmd = "float", height = 0.9, width = 0.9 },
            cmd = { "lazygit" },
            autoclose = true,
        })

        vim.api.nvim_create_user_command("LazygitTerm", function(args)
            lazygit.cwd = args.args and vim.fn.expand(args.args)
            lazygit:toggle(nil, true)
        end, { nargs = "?" })

        local htop = require("terminal").terminal:new({
            layout = { open_cmd = "float" },
            cmd = { "htop" },
            autoclose = true,
        })
        vim.api.nvim_create_user_command("HtopTerm", function()
            htop:toggle(nil, true)
        end, { nargs = "?" })

        vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
            callback = function(args)
                if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
                    vim.cmd("startinsert")
                end
            end,
        })
        vim.api.nvim_create_autocmd("TermOpen", {
            command = [[setlocal nonumber norelativenumber winhl=Normal:NormalFloat]],
        })
    end,
})

user({
    "monaqa/nvim-treesitter-clipping",
    lazy = true,
    keys = { "<leader>cc" },
    dependencies = { "thinca/vim-partedit" },
    config = function()
        vim.keymap.set("n", "<leader>cc", "<Plug>(ts-clipping-clip)")
    end,
})

user({
    "m-demare/attempt.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("attempt").setup()
        require("telescope").load_extension("attempt")
    end,
})

user({
    "bignos/bookmacro",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        -- Load a macro
        {
            ";ml",
            vim.cmd.MacroSelect,
            desc = "Load a macro to a registry",
        },

        -- Execute a macro
        {
            ";mx",
            vim.cmd.MacroExec,
            desc = "Execute a macro from BookMacro",
        },

        -- Add a macro
        {
            ";ma",
            vim.cmd.MacroAdd,
            desc = "Add a macro to BookMacro",
        },
        -- Edit a macro
        {
            ";me",
            vim.cmd.MacroEdit,
            desc = "Edit a macro from BookMacro",
        },
        -- Edit the description of a macro
        {
            ";mD",
            vim.cmd.MacroDescEdit,
            desc = "Edit a description of a macro from BookMacro",
        },

        -- Edit a register
        {
            ";mr",
            vim.cmd.MacroRegEdit,
            desc = "Edit a macro from register",
        },

        -- Delete a macro
        {
            ";md",
            vim.cmd.MacroDel,
            desc = "Delete a macro from BookMacro",
        },

        -- Export BookMacro
        {
            ";mE",
            vim.cmd.MacroExport,
            desc = "Export BookMacro to a JSON file",
        },

        -- Export a Macro
        {
            ";mz",
            vim.cmd.MacroExportTo,
            desc = "Export a macro to a JSON file",
        },

        -- Import a BookMacro
        {
            ";mI",
            vim.cmd.MacroImport,
            desc = "Import BookMacro with a JSON file",
        },

        -- Import a macro
        {
            ";mZ",
            vim.cmd.MacroImportFrom,
            desc = "Import a macro from a JSON file",
        },

        -- Erase BookMacro
        {
            "<leader>ME",
            vim.cmd.MacroErase,
            desc = "Erase all macros from The Book",
        },
    },
    config = function()
        require("bookmacro").setup()
    end,
})
user({
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
})
