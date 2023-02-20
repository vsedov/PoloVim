local config = {}
function config.syntax_surfer()
    require("modules.movement.syntax_surfer")
end

function config.hop()
    require("hop").setup({
        -- keys = 'etovxqpdygfblzhckisuran',
        quit_key = "<ESC>",
        jump_on_sole_occurrence = true,
        case_insensitive = true,
        multi_windows = true,
    })
    vim.keymap.set("n", "<leader><leader>s", "<cmd>HopWord<cr>", {})
    vim.keymap.set("n", "<leader><leader>j", "<cmd>HopChar1<cr>", {})
    vim.keymap.set("n", "<leader><leader>k", "<cmd>HopChar2<cr>", {})
    vim.keymap.set("n", "<leader><leader>w", "<cmd>HopLine<cr>", {})
    vim.keymap.set("n", "<leader><leader>l", "<cmd>HopLineStart<cr>", {})
    vim.keymap.set("n", "g/", "<cmd>HopVertical<cr>", {})

    vim.keymap.set("n", "g,", "<cmd>HopPattern<cr>", {})
end
-- use normal config for now
function config.gomove()
    require("gomove").setup({
        -- whether or not to map default key bindings, (true/false)
        map_defaults = true,
        -- what method to use for reindenting, ("vim-move" / "simple" / ("none"/nil))
        reindent_mode = "vim-move",
        -- whether to not to move past end column when moving blocks horizontally, (true/false)
        move_past_end_col = false,
        -- whether or not to ignore indent when duplicating lines horizontally, (true/false)
        ignore_indent_lh_dup = true,
    })
end

function config.iswap()
    require("iswap").setup({
        keys = "qwertyuiop",
        autoswap = true,
    })
end

function config.houdini()
    require("houdini").setup({
        mappings = { "jk", "AA", "II" },
        escape_sequences = {
            t = false,
            i = function(first, second)
                local seq = first .. second

                if vim.opt.filetype:get() == "terminal" then
                    return "" -- disabled
                end

                if seq == "AA" then
                    -- jump to the end of the line in insert mode
                    return "<BS><BS><End>"
                end
                if seq == "II" then
                    -- jump to the beginning of the line in insert mode
                    return "<BS><BS><Home>"
                end
                return "<BS><BS><ESC>"
            end,
            R = "<BS><BS><ESC>",
            c = "<BS><BS><C-c>",
        },
    })
end

function config.sj()
    local colors = {
        black = "#000000",
        light_gray = "#DDDDDD",
        white = "#FFFFFF",

        blue = "#5AA5DE",
        dark_blue = "#345576",
        darker_blue = "#005080",

        green = "#40BC60",
        magenta = "#C000C0",
        orange = "#DE945A",
    }

    local sj = require("sj")
    sj.setup({
        pattern_type = "vim_very_magic",
        prompt_prefix = "/",
        search_scope = "buffer",

        highlights = {
            SjFocusedLabel = { fg = colors.white, bg = colors.magenta, bold = false, italic = false },
            SjLabel = { fg = colors.black, bg = colors.blue, bold = true, italic = false },
            SjLimitReached = { fg = colors.black, bg = colors.orange, bold = true, italic = false },
            SjMatches = { fg = colors.light_gray, bg = colors.darker_blue, bold = false, italic = false },
            SjNoMatches = { fg = colors.orange, bold = false, italic = false },
            SjOverlay = { fg = colors.dark_blue, bold = false, italic = false },
        },

        keymaps = {
            cancel = "<Esc>", -- cancel the search
            validate = "<CR>", -- jump to the focused match
            prev_match = "N", -- focus the previous match
            next_match = "n", -- focus the next match
            prev_pattern = "<C-p>", -- select the previous pattern while searching
            next_pattern = "<C-n>", -- select the next pattern while searching
            delete_prev_char = "<BS>", -- delete the previous character
            delete_prev_word = "<C-w>", -- delete the previous word
            delete_pattern = "<C-u>", -- delete the whole pattern
            restore_pattern = "<c-BS>", -- restore the pattern to the last version having matches
            send_to_qflist = "<c-#>", --- send the search results to the quickfix list
        },
    })
    vim.keymap.set("n", "<c-b>", function()
        sj.run({ select_window = true })
    end)

    vim.keymap.set("n", "<A-!>", function()
        sj.select_window()
    end)

    --- visible lines -------------------------------------

    vim.keymap.set({ "n", "o", "x" }, "<leader>sv", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            forward_search = false,
        })
    end, { desc = "CJ VL " })

    vim.keymap.set({ "n", "o", "x" }, "<leader>sV", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run()
    end, { desc = "CJ VL run" })

    vim.keymap.set("n", "<leader>sP", function()
        sj.run({
            max_pattern_length = 1,
            pattern_type = "lua_plain",
        })
    end, { desc = "CJ VL lua_plain" })

    --- buffer --------------------------------------------

    vim.keymap.set("n", "c/", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            forward_search = false,
            search_scope = "buffer",
            update_search_register = true,
        })
    end, { desc = "/" })

    vim.keymap.set("n", "c?", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            search_scope = "buffer",
            update_search_register = true,
        })
    end, { desc = "c?" })
    local sj_cache = require("sj.cache")
    --- current line --------------------------------------

    vim.keymap.set({ "n", "o", "x" }, "<leader>sc", function()
        sj.run({
            auto_jump = true,
            max_pattern_length = 1,
            pattern_type = "lua_plain",
            search_scope = "current_line",
            use_overlay = false,
        })
    end, { desc = "Current line " })

    --- prev/next match -----------------------------------

    vim.keymap.set("n", "<leader>sp", function()
        sj.prev_match()
        if sj_cache.options.search_scope:match("^buffer") then
            vim.cmd("normal! zzzv")
        end
    end, { desc = "Prev search " })

    vim.keymap.set("n", "<leader>sn", function()
        sj.next_match()
        if sj_cache.options.search_scope:match("^buffer") then
            vim.cmd("normal! zzzv")
        end
    end, { desc = "Next search " })

    --- redo ----------------------------------------------

    vim.keymap.set("n", "<leader>sr", function()
        local relative_labels = sj_cache.options.relative_labels
        sj.redo({
            relative_labels = false,
            max_pattern_length = 1,
        })
        sj_cache.options.relative_labels = relative_labels
    end, { desc = "Redo last " })

    vim.keymap.set("n", "<leader>sR", function()
        sj.redo({
            relative_labels = true,
            max_pattern_length = 1,
        })
    end, { desc = "Redo Relative " })
end

function config.harpoon_init()
    vim.keymap.set("n", [[<C-\>]], function()
        require("harpoon.term").gotoTerminal({
            idx = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()),
        })
    end, { desc = "harpoon: create and go to terminal" })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "harpoon",
        group = vim.api.nvim_create_augroup("Harpoon Augroup", { clear = true }),
        callback = function()
            vim.keymap.set("n", "<C-V>", function()
                local curline = vim.api.nvim_get_current_line()
                local working_directory = vim.fn.getcwd() .. "/"
                vim.cmd("vs")
                vim.cmd("e " .. working_directory .. curline)
            end, { buffer = true, noremap = true, silent = true })

            vim.keymap.set("n", "<C-H>", function()
                local curline = vim.api.nvim_get_current_line()
                local working_directory = vim.fn.getcwd() .. "/"

                vim.cmd("split")
                vim.cmd("e " .. working_directory .. curline)
            end, { buffer = true, noremap = true, silent = true })

            vim.keymap.set("n", "<C-T>", function()
                local curline = vim.api.nvim_get_current_line()
                local working_directory = vim.fn.getcwd() .. "/"

                vim.cmd("tabnew")
                vim.cmd("e " .. working_directory .. curline)
            end, { buffer = true, noremap = true, silent = true })
        end,
    })
end

function config.harpoon()
    require("harpoon").setup({
        global_settings = {
            save_on_toggle = true,
            save_on_change = true,
            enter_on_sendcmd = true,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
        },
    })

    require("telescope").load_extension("harpoon")
end
function config.quick_scope()
    vim.g.qs_max_chars = 256
    vim.g.qs_buftype_blacklist = { "terminal", "nofile", "startify", "qf", "mason" }
    vim.g.qs_lazy_highlight = 1

    require("utils.ui.highlights").plugin("QuickScope", {
        { QuickScopePrimary = { ctermfg = 155, fg = "#ff5fff", underline = true, italic = true, bold = true } },
        { QuickScopeSecondary = { ctermfg = 81, fg = "#5fffff", underline = true, italic = true, bold = true } },
    })
    local function disable_quick_scope()
        if vim.g.qs_enable == 1 then
            return vim.cmd("QuickScopeToggle")
        end
    end

    local function enable_quick_scope()
        if vim.g.qs_enable == 0 then
            return vim.cmd("QuickScopeToggle")
        end
    end
    lambda.augroup("LightspeedQuickscope", {
        {
            event = "ColorScheme",
            pattern = "*",
            command = function()
                require("utils.ui.highlights").plugin("QuickScope", {
                    {
                        QuickScopePrimary = {
                            ctermfg = 155,
                            fg = "#ff5fff",
                            italic = true,
                            bold = true,
                            underline = true,
                        },
                    },
                    {
                        QuickScopeSecondary = {
                            ctermfg = 81,
                            fg = "#5fffff",
                            italic = true,
                            bold = true,
                            underline = true,
                        },
                    },
                })
            end,
        },
    })
end

function config.grapple()
    require("grapple").setup({
        log_level = "warn",
        scope = "directory",
        save_path = vim.fn.stdpath("data") .. "/" .. "grapple.json",
        popup_options = {
            relative = "editor",
            width = 60,
            height = 12,
            style = "minimal",
            focusable = false,
            border = "single",
        },

        integrations = {
            resession = true,
        },
    })
end
function config.easymark()
    require("easymark").setup({
        position = "bottom", -- position choices: bottom|top|left|right
        height = 10, -- might have to reduce this
        width = 30,
        pane_action_keys = {
            close = "q", -- close mark window
            cancel = "<esc>", -- close the preview and get back to your last position
            refresh = "r", -- manually refresh
            jump = { "<cr>", "<tab>" }, -- jump to the mark
            jump_close = { "o" }, -- jump to the mark and close mark window
            toggle_mode = "t", -- toggle mark between "marked" and "unmacked" mode
            next = "j", -- next item
            previous = "k", -- preview item
        },
        mark_opts = {
            virt_text = "",
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        },
        auto_preview = true,
    })
end

function config.bookmark()
    require("bookmarks").setup({
        keymap = {
            toggle = "<tab><tab>", -- toggle bookmarks
            add = "\\a", -- add bookmarks
            jump = "<CR>", -- jump from bookmarks
            delete = "dd", -- delete bookmarks
            order = "<\\o", -- order bookmarks by frequency or updated_time
            show_desc = "\\sd",
        },
        width = 0.8, -- bookmarks window width:  (0, 1]
        height = 0.6, -- bookmarks window height: (0, 1]
        preview_ratio = 0.4, -- bookmarks preview window ratio (0, 1]
        preview_ext_enable = true, -- if true, preview buf will add file ext, preview window may be highlighed(treesitter), but may be slower.
        fix_enable = true, -- if true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.
        virt_text = "🐼", -- Show virt text at the end of bookmarked lines
        -- virt_text = "𐇬", -- Show virt text at the end of bookmarked lines
        virt_pattern = { "*.python", "*.go", "*.lua", "*.sh", "*.php", "*.rust" }, -- Show virt text only on matched pattern
    })
end

function config.treehopper()
    local function with_tsht()
        local ok = pcall(vim.treesitter.get_parser, 0)
        if not ok then
            return false
        end

        -- tsht does not support injection
        -- injected language could be detected by vim.inspect_pos().treesitter
        local cursor = vim.api.nvim_win_get_cursor(0)
        local function f(ignore)
            return {
                vim.treesitter.get_node_at_pos(0, cursor[1], cursor[2], { ignore_injections = ignore }):range(),
            }
        end

        local range_original = f(true)
        local range_injection = f(false)
        for i, v in pairs(range_original) do
            if range_injection[i] ~= v then
                return false
            end
        end

        -- otherwise, set highlight and return true
        vim.api.nvim_set_hl(0, "TSNodeUnmatched", { link = "Comment" })
        vim.api.nvim_set_hl(0, "TSNodeKey", { link = "IncSearch" })
        return true
    end
    vim.keymap.set({ "o", "x", "n" }, "H", function()
        return with_tsht() and ":<C-U>lua require('tsht').nodes()<CR>" or [[<Plug>(leap-ast)]]
    end, { expr = true, silent = true })

    vim.keymap.set("n", "zf", function()
        if with_tsht() then
            require("tsht").nodes()
        else
            vim.cmd("normal! v")
            require("leap-ast").leap()
        end
        vim.cmd("normal! Vzf")
    end, { silent = true })
end

return config
