-- pick random  item form dark but based on its probability
lambda.config = {
    leader = {
        -- TODO: (vsedov) (21:18:41 - 03/09/22): My entire keymap config
        -- will need to be refactored , soon , so to do so , im preping in advice:
        -- i might get rid of this though , im not sure.
        leader = "<leader>",
        local_leader = "<localleader",
        leader_s_colon = ";",
        leader_c_space = "<C-<leader>>",
    },
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
                -- "horizon.nvim",
                -- "vim-dogrun",
                "nvim-tundra",
                -- "doom-one.nvim",
                "tokyonight.nvim",
            },
        },
    },
    do_you_want_lag = false, -- Enable Extra regex,
    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    -- TODO: (vsedov) (09:58:51 - 31/08/22): Use simple notify based on filetpe or project
    -- and use record your self based on if you are in multiple projects or not , as i think
    -- this also causes lag when codoing which can get very annoying
    simple_notify = false, -- notifier.nvim = true , else use nvim-notif
    record_your_self = false, -- waka time
    neorg_auto_commit = false,
    loaded_confirm_quit = true,
    cmp = {
        use_tabnine = false,
        use_rg = false,
        tabnine_sort = false,
        cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
    },
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
    use_fzf_lua = false, -- This is nice, to have, when required.
    use_command_T = true,
    use_dashboard = false, -- set to false to not see this
    use_session = false, -- set to false to disable session
    use_clock = false, -- set to true to  see timer for config
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_guess_indent = true,
    use_gitsigns = true,
    lsp = {
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
    },
    main_file_types = { "python", "norg", "tex", "lua", "c", "cpp", "rust" },
}

-- Complte refactor for how python might be loaded
