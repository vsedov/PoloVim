-- pick random  item form dark but based on its probability
lambda.config = {
    do_you_want_lag = false, -- Enable Extra regex,
    better_ts_highlights = true,
    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    simple_notify = false, -- notifier.nvim = true , else use nvim-notif
    record_your_self = false, -- waka time
    neorg_auto_commit = false,
    loaded_confirm_quit = true,
    save_clipboard_on_exit = true,
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
    rooter_or_project = true, --- @usage  true | nvim-rooter - false | for project.nvim, if you want None : Then turn to True for nvim -- rooter as that has
    --[[ manual control ]]
    tabby_or_bufferline = false, -- false: Bufferline , true for tabby
    sell_your_soul = false, -- set to true to sell your soul to microsoft
    extra_search = {
        enable = true,
        providers = {
            use_azy = true,
            use_fzf_lua = false, -- This is nice, to have, when required.|| Activates Azy.nvim < which is very fast.
            use_command_t = false, -- If this is active, the hydra will be activated
        },
    },
    use_dashboard = false, -- set to false to not see this
    use_session = false, -- set to false to disable session
    use_clock = false, -- set to true to  see timer for config
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_guess_indent = true,
    use_gitsigns = true,
    use_hlchunk = true,
    main_file_types = { "python", "norg", "tex", "lua", "c", "cpp", "rust" },
}
lambda.config.colourscheme = {
    dim_background = false,
    change_kitty_bg = false,
    --- @usage "main"' | '"moon"
    rose = "main",
    --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
    catppuccin_flavour = "mocha",
    -- @usage theme_name : percentage chance
    themes = {
        dark = {
            core_themes = {
                "kanagawa.nvim",
                "rose",
                "catppuccin",
                "tokyonight.nvim",
                "nvim-tundra",
            },
            others = {
                "horizon.nvim",
                "vim-dogrun",
                "doom-one.nvim",
            },
        },
    },
}
lambda.config.cmp = {
    tabnine = {
        use_tabnine = true,
        tabnine_sort = true, -- I am not sure how i feel about if i want tabnine to actively sort stuff for me.
        tabnine_prefetch = true,
        tabnine_priority = 9,
    },
    use_rg = false,
    cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
}

lambda.config.lsp = {
    use_lsp_signature = false,
    latex = "texlab", -- texlab | ltex
    python = {
        lint = { "flake8" }, -- pylint, pyflake, and other linters
        format = { "isort", "yapf" }, -- black
        -- jedis documentation is better though
        lsp = "jedi", -- jedi pylsp and pyright pylance
        pylance_pyright = {
            use_inlay_hints = false,
        },
    },
}
