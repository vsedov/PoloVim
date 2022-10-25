-- pick random  item form dark but based on its probability
lambda.config = {
    do_you_want_lag = false, -- Enable Extra regex,
    better_ts_highlights = true,
    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    simple_notify = false, -- notifier.nvim = true , else use nvim-notif
    record_your_self = true, -- waka time
    neorg_auto_commit = true,
    loaded_confirm_quit = false, -- not when noice is active, as that causes some stupid issue w
    save_clipboard_on_exit = true,
    rooter_or_project = true, --- @usage  true | nvim-rooter - false | for project.nvim, if you want None : Then turn to True for nvim -- rooter as that has
    tabby_or_bufferline = false, -- false: Bufferline , true for tabby
    sell_your_soul = false, -- set to true to sell your soul to microsoft
    use_session = false, -- set to false to disable session
    use_clock = false, -- set to true to  see timer for config
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_guess_indent = true,
    use_gitsigns = true,
    use_hlchunk = false,
    use_pet = true,
    use_lightspeed = true, -- if false then leap.nvim will be used.
    use_noice = false,
    use_music = true,
    use_scope = false, -- really fucks with neogit window
    use_wrapping = false, -- I am not sure if this is causing me to segfault.
    use_scroll = false,
    use_beacon = false,
    use_dashboard = false, -- set to false to not see this
    use_unception = true,
    use_mini = true,
    use_lexima = true,
    use_hi_pairs = true,
    main_file_types = { "python", "norg", "tex", "lua", "c", "cpp", "rust" },
}

lambda.config.extra_search = {
    enable = true,
    providers = {
        use_azy = true,
        use_fzf_lua = false, -- This is nice, to have, when required.|| Activates Azy.nvim < which is very fast.
    },
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
                "catppuccin",
                "mellow.nvim",
                -- "rose", -- TSMethod'
                -- "tokyonight.nvim3", -- allot
                -- "vim-dogrun"
            },
            others = {
                "horizon.nvim",
                "nvim-tundra", -- TSProperty'
                "doom-one.nvim",
            },
        },
    },
}

lambda.config.abbrev = {
    enable = true,
    coding_support = true, -- system wide
    globals = { -- dictionaries that ive defined to be global, you may not want this idk .
        ["spelling_support"] = true,
        ["month_date"] = true,
    },
    languages = {
        "python", -- current support is python.
    },
}

lambda.config.cmp = {
    tabnine = {
        use_tabnine = true,
        tabnine_sort = false, -- I am not sure how i feel about if i want tabnine to actively sort stuff for me.
        tabnine_prefetch = true,
        tabnine_priority = 3, -- 10 if you want god mode, else reduce this down to what ever you think is right for you
    },
    use_rg = false, -- this will induce lag , so use this on your own risk
    cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
}

lambda.config.lsp = {
    use_lsp_signature = true,
    use_lsp_format_modifications = true,
    latex = "ltex", -- texlab | ltex
    python = {
        lint = { "flake8" }, -- pylint, pyflake, and other linters
        format = { "isort", "yapf" }, -- black -- Need to make it so it knows what formater to use :think:
        -- jedis documentation is better though
        lsp = "jedi", -- jedi pylsp and pyright pylance , Jedi does not work well with 3.10 and will require pylance for that : kinda annyoing
        pylance_pyright = {
            use_inlay_hints = true,
        },
    },
}
