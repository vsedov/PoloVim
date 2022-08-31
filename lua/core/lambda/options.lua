-- pick random  item form dark but based on its probability
lambda.config = {
    colourscheme = {
        dim_background = false,
        change_kitty_bg = false,
        --- @usage "main"' | '"moon"
        rose = "main",
        --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
        catppuccin_flavour = "mocha",
        -- @usage theme_name : percentage chance
        themes = {
            dark = {
                "kanagawa.nvim",
                "rose",
                "catppuccin",
                "horizon.nvim",
                "vim-dogrun",
                "doom-one.nvim",
                "poimandres.nvim",
                "tokyonight.nvim",
            },
        },
    },
    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    simple_notify = true, -- notifier.nvim = true , else use nvim-notif
    record_your_self = true, -- waka time
    neorg_auto_commit = true,
    loaded_confirm_quit = true,
    save_clipboard_on_exit = true,
    cmp_theme = "border", --- @usage "border" | "no-border" | "extra"
    abbrev = {
        enable = true,
        coding_support = true, -- system wide
        globals = { -- dictionaries that ive defined to be global, you may not want this idk .
            ["spelling_support"] = true,
            ["month_date"] = true,
        },
        languages = {
            "python", -- current support is python.
        },
    },

    rooter_or_project = true, --- @usage  true | nvim-rooter - false | for project.nvim, if you want None : Then turn to Ture for nvim -- rooter as that has
    --[[ manual control ]]
    tabby_or_bufferline = false, -- false: Bufferline , true for tabby
    sell_your_soul = false, -- set to true to sell your soul to microsoft
    use_fzf_lua = true, -- This is nice, to have, when required.
    use_dashboard = true, -- set to false to not see this
    use_session = true, -- set to false to disable session
    use_clock = false, -- set to true to  see timer for config
    use_saga_diagnostic_jump = false, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_guess_indent = true,
    use_gitsigns = true,
    lsp = {
        -- this seems to cause lag, though im not sure about that. Will have to see if that is the
        -- case or not
        use_semantic_token = true,
        latex = "texlab", -- texlab | ltex
        python = {
            lint = "flake8", -- pylint, pyflake, and other linters
            -- jedis documentation is better though
            lsp = "jedi", -- jedi pylsp and pyright pylance
            pylance_pyright = {
                use_inlay_hints = true,
            },
            format = "yapf", -- black
        },
    },
    main_file_types = { "python", "norg", "tex", "lua", "c", "cpp", "rust" },
}
