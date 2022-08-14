lambda.config = {
    colourscheme = {
        change_kitty_bg = false,
        --- @usage "main"' | '"moon"
        rose = "main",
        --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
        catppuccin_flavour = "mocha",
        -- @usage theme_name : percentage chance
        themes = {
            dark = {
                { "kanagawa.nvim", 0.4 },
                { "rose", 0.9 },
                { "catppuccin", 0.2 },
                { "horizon.nvim", 0.1 },
                { "vim-dogrun", 0.3 },
                { "doom-one.nvim", 0.5 },
            },
            light = {},
        },
    },
    record_your_self = false, -- waka time
    neorg_auto_commit = true,
    loaded_confirm_quit = true,
    save_clipboard_on_exit = true,
    cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
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
    tabby_or_bufferline = true, -- false: Bufferline , true for tabby
    sell_your_soul = false, -- set to true to sell your soul to microsoft
    use_fzf_lua = false, -- This is nice, to have, when required.
    use_dashboard = false, -- set to false to not see this
    use_session = true, -- set to false to disable session
    use_clock = false, -- set to true to  see timer for config
    use_saga_diagnostic_jump = false, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_guess_indent = true,
    use_gitsigns = true,
    lsp = {
        -- this seems to cause lag, though im not sure about that. Will have to see if that is the
        -- case or not
        use_semantic_token = false,
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
}
