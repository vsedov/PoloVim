--    ╭────────────────────────────────────────────────────────────────────╮
--    │                                                                    │
--    │                   Toggles for AI functionality:                    │
--    │                                                                    │
--    ╰────────────────────────────────────────────────────────────────────╯

local use_noice = true

local use_codium = false -- Want to see what this would be like without codeium, ; but just the lsp support
local use_codium_cmp = false

local use_tabnine = true -- i mean i pay for this so why in the blue green fuck am i not using this ?
local use_tabnine_cmp = true

local use_copilot = true -- We really do sell our souls for this thing eh

-- toggle core values within th list
lambda.config = {
    use_adv_snip = true,
    use_lastplace = true,
    do_you_want_lag = false, -- Enable Extra regex, -- Fuck it
    telescope_theme = "custom_no_borders", -- custom_bottom_no_borders float_all_borders
    record_your_self = false, -- waka time track, also might not be needed
    neorg_auto_commit = false,
    loaded_confirm_quit = false, -- this is not needed
    --  ──────────────────────────────────────────────────────────────────────
    save_clipboard_on_exit = false,
    use_saga_diagnostic_jump = true, -- toggle between diagnostics, if u want to use saga or not, still think , my main diagnostics are better
    use_saga_maps = true, -- Like lspsaga definition or something, or code actions ...
    use_gitsigns = true,
    use_wrapping = true, -- I am not sure if this is causing me to segfault.
    main_file_types = { "python", "norg", "tex", "lua", "c", "cpp", "rust" },
}
lambda.config.custom = {
    custom_save_clipboard = false,
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
    copilot = {
        autotrigger = true,
        use_cmp_trigger = true, -- if this is false, then copilot is active,  but you are using something else
    },
    tabnine = {
        use_sort = false,
        use_tabnine = use_tabnine,
        use_tabnine_cmp = use_tabnine_cmp,
        use_tabnine_insert = not use_tabnine_cmp,
        cmp = {
            tabnine_sort = true, -- I am not sure how i feel about if i want tabnine to actively sort stuff for me.
            tabnine_bottom_sort = false,
            tabnine_prefetch = true,
            tabnine_priority = 4, -- 10 if you want god mode, else reduce this down to what ever you think is right for you
        },
    },
    sell_your_soul = use_copilot,
}

lambda.config.extra_search = {
    enable = true,
    providers = {
        use_fzf_lua = true, -- This is nice, to have, when required.|| Activates Azy.nvim < which is very fast.
    },
}
lambda.config.buffer = {
    use_bufferline = false,
    use_tabscope = false, -- we are going to use scope.nvim
    use_sticky_buf = true,
    use_hbac = false,
}
lambda.config.editor = {
    hydra = {
        use_hydra = true,
        load_normal = true,
        load_api = true,
    },
    use_smart_q = true,
}

lambda.config.treesitter = {
    hipairs = false, -- this could be interumpting something important and i dont wan thtis to get involved; this will be disabled

    indent = {
        use_guess_indent = true,
    },
    use_matchup = true,
    better_ts_highlights = false, -- This needs a direct toggle i think markid -- Markid
    use_rainbow = true,
    use_highpairs = false,
    use_extra_highlight = false,
    use_context_vt = false,
}

lambda.config.abbrev = {
    enable = true, -- All abbrvs are disables for the time .
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
    use_cmp = true,
    use_tabout = true,
    buffer = true,
    use_ghost = true,
    luasnip = {
        luasnip = {
            enable = true,
            priority = 8,
        },
    },
    cmp_theme = "extra", --- @usage "border" | "no-border" | "extra"
}

lambda.config.lsp = {
    use_sg = true,
    use_hover = false, -- Saga is better for this one
    use_typos = false, -- this was getting annoying
    only_severe_diagnostics = false, -- NOTE: (vsedov) (18:08:54 - 24/07/23): Revert here
    use_lsp_saga = true,
    use_lsp_dim = true, -- i forgot what this does
    ----------------------------------------------------------------------------------------------------
    --  Lsp Signiture, but im suing lazy for this for the time
    ----------------------------------------------------------------------------------------------------

    lsp_sig = {
        use_lsp_signature = false,
        use_floating_window = true,
        use_floating_window_above_cur_line = true,
        fix_pos = true,
    },
    lint_formatting = {
        use_ale = false,
        use_null_ls = true, -- Disable this for the time .  There could be something wrong with this
        use_conform = false,
    },
    diagnostics = {
        use_lsp_lines = false, -- Going to start using this as well
        use_rcd = false, -- the least intrusive of the bunch
        use_trouble_some = true,
    },
    -- considering that this imght no longer be supported; mightbe best to get rid of this
    -- just in case
    null_ls = {
        diagnostic = { "selene" },
        formatter = { "stylua" },
        code_action = { "refactoring", "ts_node_action" },
    },

    --    ╭────────────────────────────────────────────────────────────────────╮
    --    │     languages                                                      │
    --    ╰────────────────────────────────────────────────────────────────────╯
    latex = "texlab", -- texlab | ltex
    python = {
        lint = {}, -- We use ruff_ls for linting and formating as well, both can handle it i think
        format = {
            "isort",
            "yapf",
        },
        -- black -- Need to make it so it knows what formater to use :think:
        lsp = {
            "sourcery",
            "ruff_lsp",
            "pylsp",
            -- "jedi_language_server",
            -- "pylance",
            -- "basedpyright",
            -- "python-language-server",
            -- "pylyzer"
            -- pylyzer, jedi_language_server pylsp and pyright pylance , Jedi does not work well with 3.10 and will require pylance for that : kinda annyoing
        },
    },
}

-- if lambda.config.lsp.python.lsp
if vim.tbl_contains(lambda.config.lsp.python.lsp, "pylsp") then
    lambda.config.lsp.python.lint = {}
end

lambda.config.ui = {
    use_fidgit = true,
    use_illuminate = true,
    use_ufo = true, --  REVISIT: (vsedov) (03:43:35 - 16/11/22): Come back to this
    use_tint = false, -- sunglasses, tint -- Might not be great for certain colourschemes -- remove any distractions there we can use twilight instead.
    use_dropbar = true,
    mini_animate = {
        use_animate = false,
        use_cursor = false,
        use_scroll = false,
        use_resize = false,
        use_close = false,
    },
    use_hlslens = true,
    heirline = {
        use_heirline = true,
    },
    indent_lines = {
        use_hlchunk = false,
        use_indent_blankline = false, -- we shall keep this for now, seems rather nice
        use_mini_indent_scope = true,
    },
}
lambda.config.fun = {
    use_pet = false,
}
lambda.config.colourscheme = {
    use_light_theme = false,
    enable_transparent = false, -- this can get annoying i guess, so theres not point for this -- this can get annoying i guess, so theres not point for this

    dim_background = true,
    change_kitty_bg = false,
    --- @usage "main"' | '"moon"
    rose = "main",
    --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
    catppuccin_flavour = "mocha",
    -- @usage theme_name : percentage chance
    kanagawa_flavour = "dragon", -- {dragon, waave}, lotus-> white
    tokyonight_flavour = "night",
    themes = {
        light = {

            --"tokyonight.nvim",
            -- "sweetie.nvim",
            -- "catppuccin",
            "kanagawa.nvim",
        },
        dark = {
            -- "tokyonight.nvim",
            -- "catppuccin",
            -- "sweetie.nvim",
            -- "rose", -- TSMethod'
            --"doom-one.nvim",
            -- "vim-dogrun",
            "kanagawa.nvim",
            "onedarkpro.nvim",
            -- "nvim-tundra", -- TSProperty'
            -- "mellow.nvim",
        },
        others = {
            "vim-dogrun",
            "palenightfall.nvim", -- do not like this colourscheme
            "poimandres.nvim",
            "nvim-tundra",
            "mellifluous.nvim", -- BORKED
            "tokyonight.nvim", -- allot
            "nvim-tundra", -- TSProperty'
            "mellow.nvim",
        },
    },
}

if lambda.config.colourscheme.use_light_theme then
    vim.opt.background = "light"
    --- @usage "main"' | '"moon"
    lambda.config.colourscheme.rose = "moon"
    --- @usage  "latte" | "frappe" | "macchiato" | "mocha"
    lambda.config.colourscheme.catppuccin_flavour = "latte"
    -- @usage theme_name : percentage chance

    lambda.config.colourscheme.kanagawa_flavour = "lotus" -- {dragon, waave}, lotus-> white
    lambda.config.colourscheme.tokyonight_flavour = "day"
end

lambda.config.movement = {
    movement_type = "flash", -- flash : leap
    use_lasterisk = true, -- for leap and flash,
    use_asterisk = false, -- if lasterisk is on, asterisk should be disable.d
    use_accelerated_jk = true, -- we will remove this for the time, i think buffer search might be better.
    harpoon = {
        goto_harpoon = true,
        use_tmux_or_normal = "nvim", -- nvim
    },
}
-- right i think its best we disables these
lambda.config.tools = {
    use_which_key_or_use_mini_clue = "which", -- "which or mini"
    session = {
        -- use_resession = true,  this does not exist anymore
    },
    use_fundo = true, -- forgot the reason for why this was disabled
    use_flatten = false,
    use_live_command = false, -- Disabled due to large files, this might noe be nice to have
}

-- NOTE: (vsedov) (15:08:34 - 25/06/23): DO NOT CHANGE - Only change this if you are using tmux
-- Tmux binding is not set properly for this yet.
lambda.config.windows = {
    use_focus = false,
    use_wrapping = true,
    flirt = {
        use_flirt = false,
        use_flirt_override = false,
        move_mappings = false, -- if you  do not want to use  smart split
    },
    use_smart_splits = true,
}
lambda.config.folke = {
    noice = {
        enable = use_noice,
        lsp = {
            use_noice_signature = true, -- I would very much like to use this,l but for now this is broken
            use_noice_hover = true,
            use_markdown = true,
            use_documentation = true,
        },
    },
    edge = {
        enable = true,
        use_animate = false,
    },
}

if not use_noice then
    lambda.config.folke.noice.enable = false
    lambda.config.folke.noice.lsp.use_noice_signature = false
    lambda.config.folke.noice.lsp.use_noice_hover = false
    lambda.config.folke.noice.lsp.use_markdown = false
    lambda.config.folke.noice.lsp.use_documentation = false
end
