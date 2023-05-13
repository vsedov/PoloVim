-- pick random  item form dark but based on its probability
local noice_enabled = false
local use_ts_yeti = true

--    ╭────────────────────────────────────────────────────────────────────╮
--    │                                                                    │
--    │                   Toggles for AI functionality:                    │
--    │                                                                    │
--    ╰────────────────────────────────────────────────────────────────────╯

local use_codium_cmp = true
local use_codium = true

local use_tabnine = true
local use_tabnine_cmp = true
local use_copilot = true

-- toggle core values within the list

lambda.config = {
    use_hydra = true,
    do_you_want_lag = true, -- Enable Extra regex, -- Fuck it
    better_ts_highlights = false, -- This needs a direct toggle i think
    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    record_your_self = true, -- waka time track , me.
    neorg_auto_commit = false,
    loaded_confirm_quit = true,
    save_clipboard_on_exit = true,
    rooter_or_project = true, --- @usage  true | nvim-rooter - false | for project.nvim, if you want None : Then turn to True for nvim -- rooter as that has
    use_session = true, -- set to false to disable session
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_gitsigns = true,
    use_quick_scope = false,
    use_use_hiPairs = true,
    use_music = false,
    use_scope = true, -- really fucks with neogit window
    use_wrapping = true, -- I am not sure if this is causing me to segfault.
    use_unception = true,
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

lambda.config.colourscheme = {
    enable_transparent = false,
    dim_background = true,
    change_kitty_bg = false,
    --- @usage "main"' | '"moon"
    rose = "main",
    --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
    catppuccin_flavour = "mocha",
    -- @usage theme_name : percentage chance
    kanagawa_flavour = "dragon", -- dragon, lotus-> white
    use_wal = true,
    themes = {
        dark = {
            core_themes = {
                -- "kanagawa.nvim",
                "catppuccin",
                -- "sweetie.nvim",
                -- "vim-dogrun",
                -- "poimandres.nvim",
                -- "nvim-tundra",
                -- "palenightfall.nvim",
                -- "oh-lucy.nvim",
                -- "mellifluous.nvim",
                -- "tokyonight.nvim", -- allot
                -- "rose", -- TSMethod'
                -- "mellow.nvim",
            },
            others = {
                "horizon.nvim",
                "nvim-tundra", -- TSProperty'
                "doom-one.nvim",
            },
        },
    },
}

lambda.config.treesitter = {
    use_guess_indent = not use_ts_yeti,
    use_yeti = use_ts_yeti,
}

lambda.config.abbrev = {
    enable = true,
    coding_support = true, -- system wide
    globals = { -- dictionaries that ive defined to be global, you may not want this idk .
        ["spelling_support"] = true, -- i wonder if this would help reduce the lag
        ["month_date"] = true,
    },
    languages = {
        "python", -- current support is python.
    },
}

lambda.config.cmp = {
    rg = {
        use_rg = false, -- this will induce lag , so use this on your own risk
        keyword_length = 3,
        depth = 6,
    },
    luasnip = {
        luasnip_choice = false,
        luasnip = {
            enable = true,
            priority = 8,
        },
    },
    buffer = false,
    cmp_theme = "borderv2", --- @usage "border" | "no-border" | "extra"
}

lambda.config.lsp = {
    use_ruff_lsp = true,
    use_rcd = true,
    use_lsp_lines = false,
    use_lsp_signature = true,
    use_typos = true,
    use_format_modifcation = false,
    latex = "texlab", -- texlab | ltex
    python = {
        lint = { "flake8" }, -- pylint, pyflake, and other linters
        format = { "isort", "black" }, -- black -- Need to make it so it knows what formater to use :think:
        lsp = "jedi", -- jedi pylsp and pyright pylance , Jedi does not work well with 3.10 and will require pylance for that : kinda annyoing
        use_semantic_token = true,
        use_inlay_hints = true,
    },
}

lambda.config.ui = {
    use_illuminate = false,
    use_murmur = false, -- this causes issues with my yanky config -
    use_heirline = false,
    use_ufo = true, --  REVISIT: (vsedov) (03:43:35 - 16/11/22): Come back to this
    use_scroll = false,
    use_tint = false,
    use_pet = false,

    noice = {
        enable = noice_enabled,
        lsp = {
            use_noice_signature = false, -- I would very much like to use this,l but for now this is broken
            use_noice_hover = false,
        },
    },
    heirline = {
        cava = {
            use_cava = false,
            fps = "240",
            bars = "30",
            audio = "stereo", --average, stero left right
        },
    },
    flirt = {
        use_flirt = true,
        use_flirt_override = false,
    },
}

lambda.config.movement = {
    harpoon = {
        goto_harpoon = false,
        use_tmux_or_normal = "nvim", -- nvim
    },
}
