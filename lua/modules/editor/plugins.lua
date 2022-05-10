local editor = {}
local conf = require("modules.editor.config")

-- alternatives: steelsojka/pears.nvim
-- windwp/nvim-ts-autotag  'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue'
-- windwp/nvim-autopairs

editor["rainbowhxch/accelerated-jk.nvim"] = {
    keys = {
        "j",
        "k",
    },
    config = function()
        require("accelerated-jk").setup({
            mode = "time_driven",
            enable_deceleration = false,
            acceleration_limit = 150,
            acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
            deceleration_table = { { 150, 9999 } },
        })
        vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", {})
        vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", {})
    end,
}
editor["rainbowhxch/beacon.nvim"] = {
    cmd = { "Beacon", "BeaconToggle" },
    confg = conf.beacon,
}

editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }

editor["szw/vim-maximizer"] = { opt = true, cmd = { "MaximizerToggle" } }

editor["windwp/nvim-autopairs"] = {
    -- keys = {{'i', '('}},
    after = { "nvim-cmp" }, -- "nvim-treesitter", nvim-cmp "nvim-treesitter", coq_nvim
    -- event = "InsertEnter",  --InsertCharPre
    -- after = "hrsh7th/nvim-compe",
    config = conf.autopairs,
    opt = true,
}

-- TODO: Lazy Load this
editor["max397574/dyn_help.nvim"] = {}

-- I like this plugin, but 1) offscreen context is slow
-- 2) it not friendly to lazyload and treesitter startup
editor["andymass/vim-matchup"] = {
    opt = true,
    keys = { "%", "<c-s>k" },
    -- event = { "CursorMoved", "CursorMovedI" },
    cmd = { "MatchupWhereAmI?" },
    after = "nvim-treesitter",
    config = function()
        vim.g.matchup_enabled = 1
        vim.g.matchup_surround_enabled = 1
        -- vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.keymap.set("n", "<c-s>k", "<cmd><c-u>MatchupWhereAmI?<CR>")
        -- vim.cmd([[nnoremap <c-s-k> :<c-u>MatchupWhereAmI?<cr>]])
        require("nvim-treesitter.configs").setup({
            matchup = {
                enable = true, -- mandatory, false will disable the whole extension
                disable = { "ruby" }, -- optional, list of language that will be disabled
                -- [options]
            },
        })
    end,
}

editor["gbprod/yanky.nvim"] = {
    keys = {
        "<C-v>",
        "<Plug>(YankyYank)",
        "<Plug>(YankyPutAfter)",
        "<Plug>(YankyPutBefore)",
        "<Plug>(YankyPutAfter)",
        "<Plug>(YankyPutBefore)",

        "<Plug>(YankyGPutAfter)",
        "<Plug>(YankyGPutBefore)",
        "<Plug>(YankyGPutAfter)",
        "<Plug>(YankyGPutBefore)",

        "<Plug>(YankyCycleForward)",
        "<Plug>(YankyCycleBackward)",
    },
    setup = function()
        local default_keymaps = {
            { "n", "y", "<Plug>(YankyYank)" },
            { "x", "y", "<Plug>(YankyYank)" },

            { "n", "p", "<Plug>(YankyPutAfter)" },
            { "n", "P", "<Plug>(YankyPutBefore)" },

            { "x", "p", "<Plug>(YankyPutAfter)" },
            { "x", "P", "<Plug>(YankyPutBefore)" },

            { "n", "gp", "<Plug>(YankyGPutAfter)" },
            { "n", "gP", "<Plug>(YankyGPutBefore)" },

            { "x", "gp", "<Plug>(YankyGPutAfter)" },
            { "x", "gP", "<Plug>(YankyGPutBefore)" },

            { "n", "<Leader>n", "<Plug>(YankyCycleForward)" },
            { "n", "<Leader>N", "<Plug>(YankyCycleBackward)" },
        }
        for _, m in ipairs(default_keymaps) do
            vim.keymap.set(m[1], m[2], m[3], {})
        end
    end,
    config = function()
        require("yanky").setup({
            preserve_cursor_position = {
                enabled = true,
            },
            system_clipboard = {
                sync_with_ring = true,
            },
            ring = {
                history_length = 10,
                storage = "shada",
                sync_with_numbered_registers = true,
            },
        })
    end,
}

editor["ggandor/lightspeed.nvim"] = {
    setup = function()
        local default_keymaps = {
            { "n", "<M-s>", "<Plug>Lightspeed_omni_s" },
            { "n", "<M-S>", "<Plug>Lightspeed_omni_gs" },
            { "x", "<M-s>", "<Plug>Lightspeed_omni_s" },
            { "x", "<M-S>", "<Plug>Lightspeed_omni_gs" },
            { "o", "<M-s>", "<Plug>Lightspeed_omni_s" },
            { "o", "<M-S>", "<Plug>Lightspeed_omni_gs" },

            { "n", "gs", "<Plug>Lightspeed_gs" },
            { "n", "gS", "<Plug>Lightspeed_gS" },
            { "x", "gs", "<Plug>Lightspeed_gs" },
            { "x", "gS", "<Plug>Lightspeed_gS" },
            { "o", "gs", "<Plug>Lightspeed_gs" },
            { "o", "gS", "<Plug>Lightspeed_gS" },
        }
        for _, m in ipairs(default_keymaps) do
            vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
        end
    end,
    --
    event = "BufReadPost",
    opt = true,
    config = conf.lightspeed,
}

-- pretty neat
editor["mizlan/iswap.nvim"] = {
    cmd = { "ISwap", "ISwapWith" },
    config = function()
        require("iswap").setup({
            keys = "qwertyuiop",
            autoswap = true,
        })
    end,
}

editor["ziontee113/syntax-tree-surfer"] = {
    keys = {
        { "n", "vd" },
        { "n", "vu" },
        { "n", "vx" },
        { "n", "vn" },

        { "x", "J" },
        { "x", "K" },
        { "x", "H" },
        { "x", "L" },

        { "x", "<A-j>" },
        { "x", "<A-k>" },
    },

    config = function()
        local default_keymaps = {
            { "n", "vd", '<cmd>lua require("syntax-tree-surfer").move("n", false)<cr>' },
            { "n", "vu", '<cmd>lua require("syntax-tree-surfer").move("n", true)<cr>' },
            -- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
            { "n", "vx", '<cmd>lua require("syntax-tree-surfer").select()<cr>' },
            -- .select_current_node() will select the current node at your cursor
            { "n", "vn", '<cmd>lua require("syntax-tree-surfer").select_current_node()<cr>' },

            { "x", "J", '<cmd>lua require("syntax-tree-surfer").surf("next", "visual")<cr>' },
            { "x", "K", '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual")<cr>' },
            { "x", "H", '<cmd>lua require("syntax-tree-surfer").surf("parent", "visual")<cr>' },
            { "x", "L", '<cmd>lua require("syntax-tree-surfer").surf("child", "visual")<cr>' },

            { "x", "<A-j>", '<cmd>lua require("syntax-tree-surfer").surf("next", "visual", true)<cr>' },
            { "x", "<A-k>", '<cmd>lua require("syntax-tree-surfer").surf("prev", "visual", true)<cr>' },
        }
        for _, m in ipairs(default_keymaps) do
            vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
        end
    end,
}

-- editor["ggandor/leap.nvim"] = {
--     -- opt = true,
--     config = function()
--         require("leap").set_default_keymaps()
--     end,
-- }

editor["hrsh7th/vim-searchx"] = {
    event = { "CmdwinEnter", "CmdlineEnter" },
    setup = function()
        -- Overwrite / and ?.
        vim.keymap.set({ "n", "x" }, "?", "<Cmd>call searchx#start({ 'dir': 0 })<CR>")
        vim.keymap.set({ "n", "x" }, "/", "<Cmd>call searchx#start({ 'dir': 1 })<CR>")
        vim.keymap.set("c", "<A-;>", "<Cmd>call searchx#select()<CR>)")

        -- Move to next/prev match.
        vim.keymap.set({ "n", "x" }, "N", "<Cmd>call searchx#prev_dir()<CR>")
        vim.keymap.set({ "n", "x" }, "n", "<Cmd>call searchx#next_dir()<CR>")
        vim.keymap.set({ "c", "n", "x" }, "<A-z>", "<Cmd>call searchx#next()<CR>")
        vim.keymap.set({ "c", "n", "x" }, "<A-x>", "<Cmd>call searchx#prev()<CR>")

        -- Clear highlights
        vim.keymap.set("n", "<Esc><Esc>", "<Cmd>call searchx#clear()<CR>)")
    end,
    config = function()
        vim.api.nvim_exec(
            [=[
    let g:searchx = {}
    " Auto jump if the recent input matches to any marker.
    let g:searchx.auto_accept = v:true
    " The scrolloff value for moving to next/prev.
    let g:searchx.scrolloff = &scrolloff
    " To enable scrolling animation.
    let g:searchx.scrolltime = 500
    " To enable auto nohlsearch after cursor is moved
    let g:searchx.nohlsearch = {}
    let g:searchx.nohlsearch.jump = v:true
    " Marker characters.
    let g:searchx.markers = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.\zs')
    " Convert search pattern.
    function g:searchx.convert(input) abort
      if a:input !~# '\k'
        return '\V' .. a:input
      endif
      return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
    endfunction
    " Set highlight for markers
    highlight! link SearchxMarker DiffChange
    highlight! link SearchxMarkerCurrent WarningMsg
  ]=],
            false
        )
    end,
}
--max397574
-- REVISIT viv (13:14:11 - 30/03/22): Change this to maxes branch again if errors happen again
editor["folke/which-key.nvim"] = {
    opt = true,
    after = "nvim-treesitter",
    config = function()
        require("modules.editor.which_key")
    end,
}

editor["Mephistophiles/surround.nvim"] = {
    keys = { "<F3>" },
    config = function()
        require("surround").setup({
            mappings_style = "sandwich",
            pairs = {
                nestable = {
                    { "(", ")" },
                    { "[", "]" },
                    { "{", "}" },
                    { "/", "/" },
                    {
                        "*",
                        "*",
                    },
                },
                linear = { { "'", "'" }, { "`", "`" }, { '"', '"' } },
            },
            prefix = "<F3>",
        })
    end,
}

-- nvim-colorizer replacement
editor["rrethy/vim-hexokinase"] = {
    -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
    config = conf.hexokinase,
    run = "make hexokinase",
    opt = true,
    cmd = { "HexokinaseTurnOn", "HexokinaseToggle" },
}

-- Its hard for this because binds are weird
editor["booperlv/nvim-gomove"] = {
    event = { "CursorMoved", "CursorMovedI" },
    opt = true,
    config = conf.gomove,
}

editor["kevinhwang91/nvim-hlslens"] = {
    keys = { "/", "?", "*", "#" }, --'n', 'N', '*', '#', 'g'
    opt = true,
    config = conf.hlslens,
}

editor["mg979/vim-visual-multi"] = {
    keys = {
        "<Ctrl>",
        "<M>",
        "<C-n>",
        "<C-n>",
        "<M-n>",
        "<S-Down>",
        "<S-Up>",
        "<M-Left>",
        "<M-i>",
        "<M-Right>",
        "<M-D>",
        "<M-Down>",
        "<C-d>",
        "<C-Down>",
        "<S-Right>",
        "<C-LeftMouse>",
        "<M-LeftMouse>",
        "<M-C-RightMouse>",
    },
    opt = true,
    setup = conf.vmulti,
}

-- Currently needs to be calle , not sure if i have to lazy load this or not.
editor["andweeb/presence.nvim"] = {
    opt = true,
    config = conf.discord,
    requires = "plenary.nvim",
}

-- bad on startup time but i can change this i think.
editor["beauwilliams/focus.nvim"] = {
    cmd = {
        "FocusDisable",
        "FocusEnable",
        "FocusToggle",
        "FocusSplitNicely",
        "FocusSplitCycle",
        "FocusSplitLeft",
        "FocusSplitDown",
        "FocusSplitUp",
        "FocusSplitRight",
        "FocusEqualise",
        "FocusMaximise",
        "FocusMaxOrEqual",
    },
    module = "focus",
    config = function()
        require("focus").setup({
            excluded_filetypes = {
                "TelescopePrompt",
                "toggleterm",
                "Trouble",
                "NvimTree",
                "dapui_scopes",
                "dapui_breakpoints",
                "dapui_stacks",
                "diffview",
            },
        })
    end,
}

-- REMOVED FTERM

-- NORMAL mode:
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `[count]gcc` - Toggles the number of line given as a prefix-count
-- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- `gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

-- VISUAL mode:
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

-- NORMAL mode
-- `gco` - Insert comment to the next line and enters INSERT mode
-- `gcO` - Insert comment to the previous line and enters INSERT mode
-- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- NORMAL mode
-- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- `g>c` - Comments the current line using linewise comment
-- `g>b` - Comments the current line using blockwise comment
-- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- `g<c` - Uncomments the current line using linewise comment
-- `g<b`- Uncomments the current line using blockwise comment

-- VISUAL mode
-- `g>` - Comments the region using single line
-- `g<` - Unomments the region using single line

-- `gcw` - Toggle from the current cursor position to the next word
-- `gc$` - Toggle from the current cursor position to the end of line
-- `gc}` - Toggle until the next blank line
-- `gc5l` - Toggle 5 lines after the current cursor position
-- `gc8k` - Toggle 8 lines before the current cursor position
-- `gcip` - Toggle inside of paragraph
-- `gca}` - Toggle around curly brackets

-- # Blockwise

-- `gb2}` - Toggle until the 2 next blank line
-- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

editor["numToStr/Comment.nvim"] = {
    keys = { "g", "<ESC>" },
    config = conf.comment,
}

editor["LudoPinelli/comment-box.nvim"] = {
    keys = { "<Leader>cb", "<Leader>cc", "<Leader>cl", "<M-p>" },
    cmd = { "CBlbox", "CBcbox", "CBline", "CBcatalog" },
    opt = true,
    config = conf.comment_box,
}

editor["dhruvasagar/vim-table-mode"] = { cmd = { "TableModeToggle" } }

editor["jbyuki/venn.nvim"] = {
    cmd = "VBox",
}

-- fix terminal color
editor["0xAdk/nvim-terminal.lua"] = {
    opt = true,
    ft = { "log", "terminal" },
    config = function()
        require("terminal").setup()
    end,
}
editor["tpope/vim-abolish"] = { opt = true, cmd = { "Subvert", "Abolish" } }

editor["simnalamburt/vim-mundo"] = {
    opt = true,
    cmd = { "MundoToggle", "MundoShow", "MundoHide" },
    run = function()
        vim.cmd([[packadd vim-mundo]])
        vim.cmd([[UpdateRemotePlugins]])
    end,
    setup = function()
        -- body
        vim.g.mundo_prefer_python3 = 1
    end,
}

editor["mbbill/undotree"] = { opt = true, cmd = { "UndotreeToggle" } }

editor["AckslD/nvim-trevJ.lua"] = {
    module = "trevj",
    setup = function()
        vim.keymap.set("n", "<leader><leader>a", function()
            require("trevj").format_at_cursor()
        end)
    end,
    config = function()
        require("trevj").setup()
    end,
}

editor["chaoren/vim-wordmotion"] = {
    opt = true,
    fn = {
        "<Plug>WordMotion_w",
        "<Plug>WordMotion_b",
        "<Plug>WordMotion_gE",
    },
    keys = { "w", "W", "gE", "b", "B" },
}

editor["folke/zen-mode.nvim"] = {
    opt = true,
    requires = { "folke/twilight.nvim", opt = true, config = conf.twilight },
    cmd = { "ZenMode" },
    config = conf.zen,
}

editor["nvim-neorg/neorg"] = {
    branch = "main",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        { "max397574/neorg-kanban", ft = "norg", after = "neorg" },
    },
    config = function()
        require("modules.editor.neorg")
    end,
}

editor["famiu/bufdelete.nvim"] = {
    opt = true,
    cmd = { "Bdelete", "Bwipeout" },
}

editor["raimon49/requirements.txt.vim"] = {
    ft = { "requirements" },
}

editor["monaqa/dial.nvim"] = {
    keys = { "<C-a>", "<C-x>" },
    opt = true,
    config = function()
        local dial = require("dial.map")
        local augend = require("dial.augend")
        require("dial.config").augends:register_group({
            -- default augends used when no group name is specified
            default = {
                augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
            },

            -- augends used when group with name `mygroup` is specified
            mygroup = {
                augend.integer.alias.decimal,
                augend.constant.alias.bool, -- boolean value (true <-> false)
                augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
            },
        })
        local map = vim.keymap.set
        map("n", "<C-a>", dial.inc_normal(), { remap = false })
        map("n", "<C-x>", dial.dec_normal(), { remap = false })
        map("v", "<C-a>", dial.inc_visual(), { remap = false })
        map("v", "<C-x>", dial.dec_visual(), { remap = false })
        map("v", "g<C-a>", dial.inc_gvisual(), { remap = false })
        map("v", "g<C-x>", dial.dec_gvisual(), { remap = false })
    end,
}

editor["Pocco81/AutoSave.nvim"] = {
    cmd = { "ASToggle", "ASOn", "ASOff" },
    opt = true,
    config = conf.autosave,
}

editor["nyngwang/NeoZoom.lua"] = {
    opt = true,
    cmd = { "NeoZoomToggle" },
}

editor["rmagatti/alternate-toggler"] = {
    opt = true,
    cmd = "ToggleAlternate",
}

editor["max397574/nabla.nvim"] = {
    ft = { "tex", "norg" },
    opt = true,
    requires = { "nvim-lua/popup.nvim", opt = true, after = "nabla.nvim" },
}

editor["sindrets/winshift.nvim"] = {
    cmd = "WinShift",
    opt = true,
    config = conf.win_shift,
}

editor["declancm/cinnamon.nvim"] = {
    event = "WinScrolled",
    config = function()
        require("cinnamon").setup({
            extra_keymaps = true,
            scroll_limit = 150,
        })
    end,
}

return editor
