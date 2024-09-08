return {
    {
        "treesitter.nvim",
        after = function()
            local conf = require("modules.treesitter.config")
            conf.treesitter_init()
            conf.nvim_treesitter()
        end,
    },
    {
        "nvim-various-textobjs",
        event = "BufWinEnter",
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
            opts = {
                useDefaultKeymaps = true,
                disabledKeymaps = {
                    "gc",
                },
            }
            require("various-textobjs").setup(opts)
        end,
    },
    {
        "nvim-treesitter-textsubjects",
        ft = { "lua", "rust", "go", "python", "javascript" },
        after = function()
            require("modules.treesitter.treesitter").textsubjects()
        end,
    },
    {
        "vim-matchup",
        event = "BufWinEnter",
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
        event = "BufWinEnter",
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
        event = "BufWinEnter",
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
        event = "BufWinEnter",
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
            local enable = true
            require("nvim-treesitter.configs").setup({
                indent = { enable = true, disable = { "python" } },
                textobjects = {
                    -- syntax-aware textobjects
                    enable = enable,
                    disable = { "elm" },
                    lsp_interop = {
                        enable = enable,
                        border = "single",
                        peek_definition_code = {
                            ["gl"] = "@function.outer",
                            ["gK"] = "@class.outer",
                        },
                    },
                    move = {
                        enable = enable,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["gnf"] = "@function.outer",
                            ["gnif"] = "@function.inner",
                            ["gnp"] = "@parameter.inner",
                            ["gnc"] = "@call.outer",
                            ["gnic"] = "@call.inner",
                        },
                        goto_next_end = {
                            ["gnF"] = "@function.outer",
                            ["gniF"] = "@function.inner",
                            ["gnP"] = "@parameter.inner",
                            ["gnC"] = "@call.outer",
                            ["gniC"] = "@call.inner",
                        },
                        goto_previous_start = {
                            ["gpf"] = "@function.outer",
                            ["gpif"] = "@function.inner",
                            ["gpp"] = "@parameter.inner",
                            ["gpc"] = "@call.outer",
                            ["gpic"] = "@call.inner",
                        },
                        goto_previous_end = {
                            ["gpF"] = "@function.outer",
                            ["gpiF"] = "@function.inner",
                            ["gpP"] = "@parameter.inner",
                            ["gpC"] = "@call.outer",
                            ["gpiC"] = "@call.inner",
                        },
                    },
                    select = {
                        enable = true,
                        include_surrounding_whitespace = true,

                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "ts: all function" },
                            ["if"] = { query = "@function.inner", desc = "ts: inner function" },
                            ["ac"] = { query = "@class.outer", desc = "ts: all class" },
                            ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
                            ["aC"] = { query = "@conditional.outer", desc = "ts: all conditional" },
                            ["iC"] = { query = "@conditional.inner", desc = "ts: inner conditional" },
                            -- FIXME: this is unusable
                            -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
                            -- ['ax'] = '@comment.outer',
                        },
                    },
                    swap = {
                        enable = enable,
                        swap_next = { ["[W"] = "@parameter.inner" },
                        swap_previous = { ["]W"] = "@parameter.inner" },
                    },
                },
            })

            -- print("loading ts")
            vim.cmd([[syntax on]])
        end,
    },
}
