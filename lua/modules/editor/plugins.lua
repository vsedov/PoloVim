local editor = {}

local conf = require("modules.editor.config")

-- alternatives: steelsojka/pears.nvim
-- windwp/nvim-ts-autotag  'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue'
-- windwp/nvim-autopairs

editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }

-- editor["windwp/nvim-autopairs"] = {
--     -- keys = {{'i', '('}},
--     -- keys = {{'i'}},
--     requires = "nvim-treesitter",
--     after = { "nvim-cmp" }, -- "nvim-treesitter", nvim-cmp "nvim-treesitter", coq_nvim
--     -- event = "InsertEnter",  --InsertCharPre
--     -- after = "hrsh7th/nvim-compe",
--     config = conf.autopairs,
--     opt = true,
-- }

editor["ZhiyuanLck/smart-pairs"] = {
    -- commit = "045c96b3ac7fce57a12064f98987e916594e5a1b",
    event = "InsertEnter",
    opt = true,
    config = function()
        require("pairs"):setup({
            enter = {
                enable_mapping = false,
            },
            space = {
                enable_mapping = true,
            },
        })
    end,
    after = { "nvim-cmp" },
}

editor["kana/vim-niceblock"] = {
    opt = true,
}

-- I like this plugin, but 1) offscreen context is slow
-- 2) it not friendly to lazyload and treesitter startup
-- editor["andymass/vim-matchup"] = {
--   opt = true,
--   event = {"CursorMoved", "CursorMovedI"},
--   cmd = {'MatchupWhereAmI?'},
--   config = function()
--     vim.g.matchup_enabled = 1
--     vim.g.matchup_surround_enabled = 1
--     -- vim.g.matchup_transmute_enabled = 1
--     vim.g.matchup_matchparen_deferred = 1
--     vim.g.matchup_matchparen_offscreen = {method = 'popup'}
--     vim.cmd([[nnoremap <c-s-k> :<c-u>MatchupWhereAmI?<cr>]])
--   end
-- }

editor["gbprod/yanky.nvim"] = {
    keys = {
        "<C-v>",
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
            { "n", "p", "<Plug>(YankyPutAfter)" },
            { "n", "P", "<Plug>(YankyPutBefore)" },

            { "x", "p", "<Plug>(YankyPutAfter)" },
            { "x", "P", "<Plug>(YankyPutBefore)" },

            { "n", "<leader>p", "<Plug>(YankyGPutAfter)" },
            { "n", "<leader>P", "<Plug>(YankyGPutBefore)" },

            { "x", "<leader>p", "<Plug>(YankyGPutAfter)" },
            { "x", "<leader>P", "<Plug>(YankyGPutBefore)" },

            { "n", "<Leader>n", "<Plug>(YankyCycleForward)" },
            { "n", "<Leader>N", "<Plug>(YankyCycleBackward)" },
        }
        for _, m in ipairs(default_keymaps) do
            vim.keymap.set(m[1], m[2], m[3], {})
        end
    end,
    config = function()
        require("yanky").setup({
            ring = {
                -- i have a op pc
                history_length = 50,
                storage = "shada",
            },
        })
    end,
}

editor["ggandor/lightspeed.nvim"] = {
    -- as = "lightspeed",
    -- commit = "4d8359a30b26ee5316d0e7c79af08b10cb17a57b",
    keys = {
        "<Plug>Lightspeed_s",
        "<Plug>Lightspeed_S",
        "<Plug>Lightspeed_x",
        "<Plug>Lightspeed_X",
        "<Plug>Lightspeed_f",
        "<Plug>Lightspeed_F",
        "<Plug>Lightspeed_t",
        "<Plug>Lightspeed_T",
        "<Plug>Lightspeed_gs",
        "<Plug>Lightspeed_gS",
        "<Plug>Lightspeed_omni_s",
        "<Plug>Lightspeed_omni_gs",
    },
    setup = function()
        local default_keymaps = {
            { "n", "s", "<Plug>Lightspeed_s" },
            { "n", "S", "<Plug>Lightspeed_S" },
            { "x", "s", "<Plug>Lightspeed_s" },
            { "x", "S", "<Plug>Lightspeed_S" },
            { "o", "z", "<Plug>Lightspeed_s" },
            { "o", "Z", "<Plug>Lightspeed_S" },
            { "o", "x", "<Plug>Lightspeed_x" },
            { "o", "X", "<Plug>Lightspeed_X" },

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

            { "n", "f", "<Plug>Lightspeed_f" },
            { "n", "F", "<Plug>Lightspeed_F" },
            { "x", "f", "<Plug>Lightspeed_f" },
            { "x", "F", "<Plug>Lightspeed_F" },
            { "o", "f", "<Plug>Lightspeed_f" },
            { "o", "F", "<Plug>Lightspeed_F" },

            { "n", "t", "<Plug>Lightspeed_t" },
            { "n", "T", "<Plug>Lightspeed_T" },
            { "x", "t", "<Plug>Lightspeed_t" },
            { "x", "T", "<Plug>Lightspeed_T" },
            { "o", "t", "<Plug>Lightspeed_t" },
            { "o", "T", "<Plug>Lightspeed_T" },
        }
        for _, m in ipairs(default_keymaps) do
            vim.keymap.set(m[1], m[2], m[3], { silent = true })
        end
    end,

    -- event = "BufReadPost",
    -- opt = true,
    config = conf.lightspeed,
}

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
editor["max397574/which-key.nvim"] = {
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

-- editor["kevinhwang91/nvim-hlslens"] = {
--   -- keys = {"/", "?", '*', '#'}, --'n', 'N', '*', '#', 'g'
--   -- opt = true,
--   -- config = conf.hlslens
-- }

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
    cmd = { "FocusNicely", "FocusToggle", "FocusEnable" },
    module = "focus",
    config = function()
        require("focus").setup({
            cursorline = false,
            number = false,
            signcolumn = false,
            colorcolumn = { enable = true, width = tonumber(vim.o.colorcolumn) },
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

-- TODO do shit to this
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
editor["AndrewRadev/splitjoin.vim"] = {
    opt = true,
    cmd = { "SplitjoinJoin", "SplitjoinSplit" },
    setup = function()
        vim.g.splitjoin_split_mapping = ""
        vim.g.splitjoin_join_mapping = ""
    end,
    -- keys = {'<space>S', '<space>J'}
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
    -- branch = "neorg-export",
    -- requires = { "max397574/neorg-zettelkasten" },
    config = function()
        require("modules.editor.neorg")
    end,
}

editor["famiu/bufdelete.nvim"] = {
    opt = true,
    cmd = { "Bdelete", "Bwipeout" },
}

editor["nvim-lua/popup.nvim"] = {
    opt = true,
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
        local augend = require("dial.augend")
        local map = vim.keymap.set
        map("n", "<C-a>", dial.inc_normal(), { remap = false })
        map("n", "<C-x>", dial.dec_normal(), { remap = false })
        map("v", "<C-a>", dial.inc_visual(), { remap = false })
        map("v", "<C-x>", dial.dec_visual(), { remap = false })
        map("v", "g<C-a>", dial.inc_gvisual(), { remap = false })
        map("v", "g<C-x>", dial.dec_gvisual(), { remap = false })
    end,
}

-- Latest dont work .
editor["sidebar-nvim/sidebar.nvim"] = {
    ft = { "python", "lua", "c", "cpp", "prolog" },
    -- Section is loaded through cache .
    opt = true,
    branch = "dev",
    config = conf.side_bar,
}

editor["nyngwang/NeoZoom.lua"] = {
    event = "BufRead",
    after = "which-key.nvim",
    config = function()
        require("which-key").register({ g = { z = { "<Cmd>NeoZoomToggle<CR>", "Toggle Zoom" } } }, { prefix = "<c-w>" })
    end,
}

editor["rmagatti/alternate-toggler"] = {
    opt = true,
    cmd = "ToggleAlternate",
}

editor["max397574/nabla.nvim"] = {
    opt = true,
    -- commit = "ba9559798ac5bdb029cbebaa8751f61e2f024f40",
    ft = "norg",
    requires = { "nvim-lua/popup.nvim" },
}

return editor
