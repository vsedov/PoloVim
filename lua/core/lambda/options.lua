--    ╭────────────────────────────────────────────────────────────────────╮
--    │                                                                    │
--    │                   Toggles for AI functionality:                    │
--    │                                                                    │
--    ╰────────────────────────────────────────────────────────────────────╯

local use_codium = false
local use_codium_cmp = true

local use_tabnine = true
local use_tabnine_cmp = true

local use_copilot = true -- We really do sell our souls for this thing eh

-- toggle core values within the list
lambda.config = {
    use_hydra = true,
    -- innter treesitter, although this can be changed
    do_you_want_lag = true, -- Enable Extra regex, -- Fuck it

    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    record_your_self = true, -- waka time track , me.
    neorg_auto_commit = false,
    loaded_confirm_quit = true,
    save_clipboard_on_exit = true,
    rooter_or_project = true, --- @usage  true | nvim-rooter - false | for project.nvim, if you want None : Then turn to True for nvim -- rooter as that has
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_gitsigns = true,
    use_wrapping = true, -- I am not sure if this is causing me to segfault.
    use_luasnip_brackets = false, --  REVISIT: (vsedov) (03:43:32 - 27/10/22): This is not good enough , Need something smarter
    main_file_types = { "python", "norg", "tex", "lua", "c", "cpp", "rust" },
}
lambda.config.ai = {
    model = "gpt-4",
    codeium = {
        use_codeium = use_codium,
        use_codeium_cmp = use_codium_cmp,
        use_codium_insert = not use_codium_cmp,
        cmp = {
            codium_priority = 10,
        },
    },
    tabnine = {
        use_tabnine = use_tabnine,
        use_tabnine_cmp = use_tabnine_cmp,
        use_tabnine_insert = not use_tabnine_cmp,
        cmp = {
            tabnine_sort = false, -- I am not sure how i feel about if i want tabnine to actively sort stuff for me.
            tabnine_bottom_sort = true,
            tabnine_prefetch = true,
            tabnine_priority = 1, -- 10 if you want god mode, else reduce this down to what ever you think is right for you
        },
    },
    sell_your_soul = use_copilot,
}

lambda.config.extra_search = {
    enable = true,
    providers = {
        use_azy = true,

        use_fzf_lua = true, -- This is nice, to have, when required.|| Activates Azy.nvim < which is very fast.
    },
}
lambda.config.buffer = {
    use_tabscope = true,
    use_sticky_buf = true,

    use_bufignore = true,
    use_early_retirement = true,
    use_hbac = true,
}
lambda.config.editor = {
    use_smart_q = true,
}

lambda.config.treesitter = {
    indent = {
        use_indent_O_matic = false,
        use_guess_indent = true,
        use_yati = false,
    },
    use_matchup = true,
    use_extra_highlight = true,
    better_ts_highlights = false, -- This needs a direct toggle i think markid -- Markid
    use_highpairs = true,
    use_context_vt = true,
}

lambda.config.abbrev = {
    enable = true,
    coding_support = true, -- system wide
    globals = {
        -- dictionaries that ive defined to be global, you may not want this idk .
        ["spelling_support"] = true, -- i wonder if this would help reduce the lag
        ["month_date"] = true,
    },
    languages = {
        "python", -- current support is python.
    },
}

lambda.config.cmp = {
    buffer = true,
    luasnip = {
        luasnip_choice = false,
        luasnip = {
            enable = true,
            priority = 6,
        },
    },
    cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
}

lambda.config.lsp = {
    use_hover = false, -- Saga is better for this one
    use_typos = false, -- this was getting annoying
    only_severe_diagnostics = false,
    use_format_modifcation = false,
    use_lsp_saga = false,
    lsp_sig = {
        use_lsp_signature = true,
        use_floating_window = false,
        use_floating_window_above_cur_line = true,
        fix_pos = true,
    },
    diagnostics = {
        use_error_lens = false,
        use_lsp_lines = false,
        use_rcd = true, -- the least intrusive of the bunch
    },
    null_ls = {
        diagnostic = {
            "cppcheck",
            "djlint",
            "eslint_d",
            "golangci_lint",
            "ktlint",
            "markdownlint",
            "misspell",
            "phpcs",
            "staticcheck",
            "stylelint",
            "write_good",
            "luacheck",
        },
        formatter = {
            "scalafmt",
            "stylish_haskell",
            "djlint",
            "fish_indent",
            "ktlint",
            "markdownlint",
            "phpcbf",
            "pint",
            "prettierd",
            "shellharden",
            "shfmt",
            "stylelint",
            "stylua",
            "trim_newlines",
            "trim_whitespace",
            "pyflyby",
        },
        code_action = { "eslint_d", "gitrebase", "refactoring" },
    },

    --    ╭────────────────────────────────────────────────────────────────────╮
    --    │     languages                                                      │
    --    ╰────────────────────────────────────────────────────────────────────╯
    latex = "texlab", -- texlab | ltex
    python = {
        lint = { "ruff" }, -- pylint, pyflake, and other linters
        -- Keep this distinct from pylsp
        format = { "ruff", "black" }, -- black -- Need to make it so it knows what formater to use :think:
        lsp = { "pylsp", "sourcery" }, -- pylyzer, jedi pylsp and pyright pylance , Jedi does not work well with 3.10 and will require pylance for that : kinda annyoing
        -- Sourcery is nice to have, great little refactoring improvements
        -- Pylsp offers more than jedi does, with rope so why not .
    },
}

lambda.config.ui = {
    use_virtcol = true,
    use_murmur = false, -- this causes issues with my yanky config -
    use_illuminate = true,
    use_ufo = true, --  REVISIT: (vsedov) (03:43:35 - 16/11/22): Come back to this
    use_tint = true, -- Might not be great for certain colourschemes
    use_hlsearch = true,
    use_dropbar = true,
    use_beacon = true,
    use_mini_animate = false,
    heirline = {
        use_statuscol = false,
        use_heirline = true,
    },
    noice = {
        enable = true,
        lsp = {
            use_noice_signature = true, -- I would very much like to use this,l but for now this is broken
            use_noice_hover = true, -- Navigator really does not like this
            use_markdown = true,
            use_documentation = true,
        },
    },
    indent_lines = {
        use_indent_blankline = false,
        use_hlchunk = false,
        use_mini_indent_scope = true,
    },
    scroll_bar = {
        use_scroll = true, -- for now im using mini animate - this might need a more advanced toglge for this to work
        use_scrollbar = false,
    },
}
lambda.config.fun = {
    use_pet = false,
}
lambda.config.colourscheme = {
    enable_transparent = false,
    dim_background = false,
    change_kitty_bg = false,
    --- @usage "main"' | '"moon"
    rose = "main",
    --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
    catppuccin_flavour = "mocha",
    -- @usage theme_name : percentage chance
    kanagawa_flavour = "wave", -- {dragon, waave}, lotus-> white
    use_wal = true,
    themes = {
        dark = {
            core_themes = {
                "tokyonight.nvim",
                "catppuccin",
                "rose", -- TSMethod'
                -- -- "kanagawa.nvim",
                -- "vim-dogrun",
                -- "palenightfall.nvim", -- do not like this colourscheme
                -- "sweetie.nvim",
                -- "poimandres.nvim",
                -- "nvim-tundra",
                -- "mellifluous.nvim", -- BORKED
                -- "tokyonight.nvim", -- allot
                -- "nvim-tundra", -- TSProperty'
                -- "mellow.nvim",
            },
            others = {
                "doom-one.nvim",
            },
        },
    },
}

lambda.config.movement = {
    movement_type = "flash", -- flash : leap
    use_lasterisk = true, -- for leap and flash,
    use_asterisk = false, -- if lasterisk is on, asterisk should be disable.d
    use_accelerated_jk = true,
    harpoon = {
        goto_harpoon = false,
        use_tmux_or_normal = "nvim", -- nvim
    },
}
lambda.config.tools = {
    session = {
        use_persisted = false,
        use_resession = true,
    },
    use_fundo = true, -- forgot the reason for why this was disabled
    use_flatten = true,
    use_live_command = true,
}

-- NOTE: (vsedov) (15:08:34 - 25/06/23): DO NOT CHANGE - Only change this if you are using tmux
-- Tmux binding is not set properly for this yet.
lambda.config.windows = {
    use_wrapping = true,
    flirt = {
        use_flirt = true,
        use_flirt_override = false,
        move_mappings = false, -- if you  do not want to use  smart split
    },
    use_navigator = false,
    use_smart_splits = true,
}
