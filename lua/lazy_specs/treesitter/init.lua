return {
    {
        "treesitter.nvim",
        event = "BufEnter",
        after = function()
            local conf = require("modules.treesitter.config")
            conf.nvim_treesitter()
        end,
    },
    {
        "nvim-various-textobjs",
        event = "BufEnter",
        keys = {
            {
                "aS",
                function()
                    require("various-textobjs").subword(false)
                end,
                mode = { "o", "x" },
                desc = "outer subword",
            },
            {
                "iS",
                function()
                    require("various-textobjs").subword(true)
                end,
                mode = { "o", "x" },
                desc = "inner subword",
            },
            {
                "ii",
                function()
                    if vim.fn.indent(".") == 0 then
                        require("various-textobjs").entireBuffer()
                    else
                        require("various-textobjs").indentation("inner", "inner")
                    end
                end,
                mode = { "o", "x" },
                desc = "inner indentation",
            },
            {
                "gx",

                function()
                    require("various-textobjs").url()
                    local foundURL = vim.fn.mode():find("v")
                    if foundURL then
                        vim.cmd.normal('"zy')
                        local url = vim.fn.getreg("z")
                        openURL(url)
                    else
                        -- find all URLs in buffer
                        local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
                        local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
                        local urls = {}
                        for url in bufText:gmatch(urlPattern) do
                            table.insert(urls, url)
                        end
                        if #urls == 0 then
                            return
                        end

                        -- select one, use a plugin like dressing.nvim for nicer UI for
                        -- `vim.ui.select`
                        vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
                            if choice then
                                openURL(choice)
                            end
                        end)
                    end
                end,
                mode = { "n" },
            },
            {
                "dsi",
                function()
                    -- select outer indentation
                    require("various-textobjs").indentation("outer", "outer")

                    -- plugin only switches to visual mode when a textobj has been found
                    local indentationFound = vim.fn.mode():find("V")
                    if not indentationFound then
                        return
                    end

                    -- dedent indentation
                    vim.cmd.normal({ "<", bang = true })

                    -- delete surrounding lines
                    local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
                    local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
                    vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
                    vim.cmd(tostring(startBorderLn) .. " delete")
                end,
                mode = "n",
                { desc = "Delete Surrounding Indentation" },
            },
        },
        after = function()
            require("various-textobjs").setup({ useDefaultKeymaps = true })
        end,
    },
    {
        "nvim-treesitter-textsubjects",
        event = "BufEnter",
        after = function()
            require("nvim-treesitter.configs").setup({
                textsubjects = {
                    enable = true,
                    prev_selection = ",", -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ["<c-;>"] = "textsubjects-smart",
                        ["'"] = "textsubjects-container-outer",
                        ["i;"] = "textsubjects-container-inner",
                        ["i;"] = {
                            "textsubjects-container-inner",
                            desc = "Select inside containers (classes, functions, etc.)",
                        },
                    },
                },
            })
        end,
    },
    {
        "vim-matchup",
        event = "BufEnter",
        keys = {
            {
                "<leader><leader>w",
                function()
                    vim.cmd([[MatchupWhereAmI!]])
                end,
            },
        },
        after = function()
            vim.g.loaded_matchit = 1
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
            -- vim.g.matchup_matchparen_offscreen = { method = "status_manual" }

            -- defer to better performance
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_deferred_show_delay = 50
            vim.g.matchup_matchparen_deferred_hide_delay = 500
            vim.cmd([[nmap <silent> <F7> <plug>(matchup-hi-surround)]])
            vim.cmd([[
            function! s:matchup_convenience_maps()
            xnoremap <sid>(std-I) I
            xnoremap <sid>(std-A) A
            xmap <expr> I mode()=='<c-v>'?'<sid>(std-I)':(v:count?'':'1').'i'
            xmap <expr> A mode()=='<c-v>'?'<sid>(std-A)':(v:count?'':'1').'a'
            for l:v in ['', 'v', 'V', '<c-v>']
                execute 'omap <expr>' l:v.'I%' "(v:count?'':'1').'".l:v."i%'"
                execute 'omap <expr>' l:v.'A%' "(v:count?'':'1').'".l:v."a%'"
            endfor
            endfunction
            call s:matchup_convenience_maps()
            ]])
        end,
    },
    {
        "equal.operator",
        keys = {
            {
                "il",
                mode = { "o", "x" },
                desc = "select inside RHS",
            },
            {
                "ih",
                mode = { "o", "x" },
                desc = "select inside LHS",
            },
            {
                "al",
                mode = { "o", "x" },
                desc = "select all RHS",
            },
            {
                "ah",
                mode = { "o", "x" },
                desc = "select all LHS",
            },
        },
    },
    {
        "nvim-treesitter-endwise",
        event = "BufEnter",
        after = function()
            -- Requires nvim-treesitter installed
            require("nvim-treesitter.configs").setup({
                endwise = {
                    enable = true,
                },
            })
        end,
    },
    {
        "hlargs.nvim",
        event = "BufEnter",
        after = function()
            require("hlargs").setup({
                color = "#ef9062",
                highlight = {},
                excluded_filetypes = {
                    "oil",
                    "trouble",
                    "vim",
                    "help",
                    "dashboard",
                    "packer",
                    "lazy",
                    "config",
                    "nofile",
                },
                paint_arg_declarations = true,
                paint_arg_usages = true,
                paint_catch_blocks = {
                    declarations = true,
                    usages = true,
                },
                extras = {
                    named_parameters = true,
                },
                hl_priority = 10000,
                excluded_argnames = {
                    declarations = {},
                    usages = {
                        python = { "self", "cls" },
                        lua = { "self" },
                    },
                },
                performance = {
                    parse_delay = 1,
                    slow_parse_delay = 50,
                    max_iterations = 400,
                    max_concurrent_partial_parses = 30,
                    debounce = {
                        partial_parse = 3,
                        partial_insert_mode = 100,
                        total_parse = 700,
                        slow_parse = 5000,
                    },
                },
            })
            lambda.command("HlargsEnable", function()
                require("hlargs").enable()
            end, {})
            lambda.command("HlargsDisable", function()
                require("hlargs").disable()
            end, {})
            lambda.command("HlargsToggle", function()
                require("hlargs").toggle()
            end, {})
        end,
    },

    {
        "hipairs",
        event = "BufEnter",
        after = function()
            function setkey(k)
                local function out(kk, v)
                    vim[k][kk] = v
                end

                return out
            end

            setglobal = setkey("g")
            setglobal("hiPairs_hl_matchPair", {
                term = "underline,bold",
                cterm = "underline,bold",
                ctermfg = "0",
                ctermbg = "180",
                gui = "underline,bold,italic",
                guifg = "#fb94ff",
                guibg = "NONE",
            })
        end,
    },
    {
        "guess-indent.nvim",
        event = "BufReadPost", -- "BufReadPost",
        cmd = "GuessIndent",
        after = function()
            require("guess-indent").setup({
                auto_cmd = true, -- Set to false to disable automatic execution
                filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
                    "netrw",
                    "neo-tree",
                    "tutor",
                },
                buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
                    "help",
                    "nofile",
                    "terminal",
                    "prompt",
                },
            })
        end,
    },
    {
        "nvim-treesitter-textobjects",
        event = "BufEnter",
        after = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = false,
                },
            })

            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`
            vim.keymap.set({ "x", "o" }, "af", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
            end)
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
            end)
        end,
    },
}
