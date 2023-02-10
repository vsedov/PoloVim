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
--
user({
    "segeljakt/vim-silicon",
    lazy = true,
    cmd = { "Silicon", "SiliconHighlight" },
    config = function()
        vim.cmd([[
            let s:workhours = {
                  \ 'Monday':    [8, 16],
                  \ 'Tuesday':   [9, 17],
                  \ 'Wednesday': [9, 17],
                  \ 'Thursday':  [9, 17],
                  \ 'Friday':    [9, 15],
                  \ }

            function! s:working()
                let day = strftime('%u')
                if has_key(s:workhours, day)
                  let hour = strftime('%H')
                  let [start_hour, stop_hour] = s:workhours[day]
                  if start_hour <= hour && hour <= stop_hour
                    return "~/Work-Snippets/"
                  endif
                endif
                return "/home/viv/Pictures/Silicon/"
            endfunction

            let g:silicon['output'] = function('s:working')
        ]])
    end,
})

user({
    "tamton-aquib/mpv.nvim",
    lazy = true,
    cmd = "MpvToggle",
    config = { setup_widgets = true, timer = { throttle = 100 } },
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

user({ "alanjcfs/rg.nvim", cmd = "Ripgrep" })

user({
    "0xAdk/full_visual_line.nvim",
    config = true,
})
