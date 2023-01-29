-- pick random  item form dark but based on its probability
local noice_enabled = false
local use_noice_docs = false -- this creats an error for some reason , though im not sure why | It is nice to have though

local use_lightspeed = true --  So the tldr here is when this is false, both lightspeed and leap are active, but when this is true only lightspeed will be active
local use_ts_yeti = true
local use_glance = true

local ruff_lsp = true
local py_lang = "jedi"

lambda.config = {
    use_flirt = false,
    use_hydra = true,
    overwrite_colours_use_styler = false,
    do_you_want_lag = false, -- Enable Extra regex, -- Fuck it
    better_ts_highlights = false, -- This needs a direct toggle i think
    telescope_theme = "float_all_borders", -- custom_bottom_no_borders float_all_borders
    simple_notify = false, -- notifier.nvim = true , else use nvim-notif
    record_your_self = true, -- waka time track , me.
    neorg_auto_commit = false,
    loaded_confirm_quit = false, --  not noice_enabled, -- not when noice is active, as that causes some stupid issue w
    save_clipboard_on_exit = true,
    rooter_or_project = true, --- @usage  true | nvim-rooter - false | for project.nvim, if you want None : Then turn to True for nvim -- rooter as that has
    tabby_or_bufferline = false, -- false: Bufferline , true for tabby
    sell_your_soul = false, -- set to true to sell your soul to microsoft
    use_session = true, -- set to false to disable session
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_gitsigns = true,
    use_lightspeed = false, -- if false then leap.nvim will be used.
    use_both_leap_light_speed = true,
    use_leap = true,
    use_quick_scope = false,
    use_use_hiPairs = true,
    use_music = false,
    use_scope = true, -- really fucks with neogit window
    use_scroll = false,
    use_ufo = true, --  REVISIT: (vsedov) (03:43:35 - 16/11/22): Come back to this
    use_wrapping = true, -- I am not sure if this is causing me to segfault.
    use_unception = true,
    use_code_window = false,
    use_luasnip_brackets = false, --  REVISIT: (vsedov) (03:43:32 - 27/10/22): This is not good enough , Need something smarter
    use_clock = false, -- set to true to  see timer for config
    use_pet = false,
    use_beacon = false,
    use_fidget = false,
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
                -- "palenightfall.nvim",
                -- -- "oh-lucy.nvim",
                "catppuccin",
                -- -- "mellifluous.nvim",
                -- "nvim-tundra",
                -- "tokyonight.nvim", -- allot
                -- "rose", -- TSMethod'
                -- "vim-dogrun",
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
    use_guess_indent = false,
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
    tabnine = {
        use_tabnine = true,
        tabnine_sort = false, -- I am not sure how i feel about if i want tabnine to actively sort stuff for me.
        tabnine_overwrite_sort = true,
        tabnine_prefetch = true,
        tabnine_priority = 3, -- 10 if you want god mode, else reduce this down to what ever you think is right for you
    },
    use_rg = false, -- this will induce lag , so use this on your own risk
    cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
}

lambda.config.lsp = {
    use_ruff_lsp = ruff_lsp,
    use_rcd = false,
    use_lsp_lines = false,
    use_lsp_signature = true,
    use_typos = true,
    latex = "texlab", -- texlab | ltex
    python = {
        lint = { "flake8" }, -- pylint, pyflake, and other linters
        format = { "isort", "black" }, -- black -- Need to make it so it knows what formater to use :think:
        lsp = py_lang, -- jedi pylsp and pyright pylance , Jedi does not work well with 3.10 and will require pylance for that : kinda annyoing
        use_semantic_token = true,
        use_inlay_hints = true,
    },
}

lambda.config.ui = {
    use_illuminate = true,
    use_murmur = false, -- Do not use both illuminate and murmur
    use_modes = true,
    use_heirline = false,
    noice = {
        enable = noice_enabled,
        lsp = {
            use_noice_signature = use_noice_docs, -- I would very much like to use this,l but for now this is broken
            use_noice_hover = use_noice_docs,
            use_markdown = {
                convert_input_to_markdown_lines = use_noice_docs,
                stylize_markdown = use_noice_docs, --  If use_noice_signature is false , then these boys have to be disabled too interested
                get_documentation = use_noice_docs, --
            },
        },
    },
}
