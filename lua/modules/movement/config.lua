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
end

-- use normal config for now
function config.gomove()
    require("gomove").setup({
        -- whether or not to map default key bindings, (true/false)
        map_defaults = false,
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

-- ["i|ll"] = map_cmd("()<esc>i", "()"):with_silent(),
-- ["i|lj"] = map_cmd("[]<esc>i", "[]"):with_silent(),
-- ["i|lm"] = map_cmd("{}<esc>i", "{}"):with_silent(),

function config.houdini()
    require("houdini").setup({
        mappings = { "jk", "AA", "II", "jj", "kk", "kj" },
        escape_sequences = {
            t = false,
            i = function(first, second)
                local seq = first .. second

                if vim.opt.filetype:get() == "terminal" or vim.bo.buftype == "terminal" then
                    return "" -- disabled
                end
                if seq == "kj" then
                    return "<BS><BS>()<esc>i"
                end
                if seq == "kk" then
                    return "<BS><BS>{}<esc>i"
                end
                if seq == "jj" then
                    return "<BS><BS>[]<esc>i"
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
    local sj = require("sj")
    local sj_cache = require("sj.cache")

    --- Configuration ------------------------------------------------------------------------

    sj.setup({
        prompt_prefix = "/",

  -- stylua: ignore
  highlights = {
    SjFocusedLabel = { bold = false, italic = false, fg = "#FFFFFF", bg = "#C000C0", },
    SjLabel =        { bold = true , italic = false, fg = "#000000", bg = "#5AA5DE", },
    SjLimitReached = { bold = true , italic = false, fg = "#000000", bg = "#DE945A", },
    SjMatches =      { bold = false, italic = false, fg = "#DDDDDD", bg = "#005080", },
    SjNoMatches =    { bold = false, italic = false, fg = "#DE945A",                 },
    SjOverlay =      { bold = false, italic = false, fg = "#345576",                 },
  },
        auto_jump = true, -- if true, automatically jump on the sole match
        forward_search = true, -- if true, the search will be done from top to bottom
        highlights_timeout = 0, -- if > 0, wait for 'updatetime' + N ms to clear hightlights (sj.prev_match/sj.next_match)
        max_pattern_length = 0, -- if > 0, wait for a label after N characters
        pattern_type = "vim", -- how to interpret the pattern (lua_plain, lua, vim, vim_very_magic)
        preserve_highlights = true, -- if true, create an autocmd to preserve highlights when switching colorscheme
        search_scope = "buffer", -- (current_line, visible_lines_above, visible_lines_below, visible_lines, buffer)
        select_window = false, -- if true, ask for a window to jump to before starting the search
        separator = ":", -- character used to split the user input in <pattern> and <label> (can be empty)
        update_search_register = true, -- if true, update the search register with the last used pattern
        use_last_pattern = false, -- if true, reuse the last pattern for next calls
        use_overlay = true, -- if true, apply an overlay to better identify labels and matches
        wrap_jumps = vim.o.wrapscan, -- if true, wrap the jumps when focusing previous or next label

        --- keymaps used during the search
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
            send_to_qflist = "<c-q>", --- send the search results to the quickfix list
        },
    })

    --- Keymaps ------------------------------------------------------------------------------

    vim.keymap.set("n", "!", function()
        sj.run({ select_window = true })
    end)

    vim.keymap.set("n", "<A-!>", function()
        sj.select_window()
    end)

    --- prev/next match -----------------------------------

    vim.keymap.set("n", "<A-,>", function()
        sj.prev_match()
        if sj_cache.options.search_scope:match("^buffer") then
            vim.cmd("normal! zzzv")
        end
    end)

    vim.keymap.set("n", "<A-;>", function()
        sj.next_match()
        if sj_cache.options.search_scope:match("^buffer") then
            vim.cmd("normal! zzzv")
        end
    end)

    --- redo ----------------------------------------------S
    vim.keymap.set("n", "<localleader>s", function()
        local relative_labels = sj_cache.options.relative_labels
        sj.redo({
            relative_labels = false,
            max_pattern_length = 1,
        })
        sj_cache.options.relative_labels = relative_labels
    end)

    vim.keymap.set("n", "<localleader>S", function()
        sj.redo({
            relative_labels = true,
            max_pattern_length = 1,
        })
    end)

    vim.keymap.set("n", ";/", function()
        vim.fn.setpos("''", vim.fn.getpos("."))
        sj.run({
            forward_search = false,
            search_scope = "buffer",
            update_search_register = true,
        })
    end)
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
                vim.treesitter.get_node({ 0, { cursor[1], cursor[2] }, { ignore_injections = ignore } }):range(),
                -- vim.treesitter.get_node,
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
    local function tsht()
        vim.api.nvim_set_hl(0, "TSNodeUnmatched", { link = "Comment" })
        vim.api.nvim_set_hl(0, "TSNodeKey", { link = "IncSearch" })
        return ":<C-U>lua require('tsht').nodes({ignore_injections = false})<CR>"
    end

    return {
        {
            "\\m",
            tsht,
            mode = { "o", "x" },
            expr = true,
            silent = true,
            desc = "treehopper: highlight current node",
        },
        {
            "H",
            function()
                return with_tsht() and ":<C-U>lua require('tsht').nodes({ignore_injections = false})<CR>"
                    or [[<Plug>(leap-ast)]]
            end,
            mode = { "o", "x", "n" },
            expr = true,
            silent = true,
            desc = "treehopper: highlight current node",
        },
        {
            "z<cr>",
            function()
                if with_tsht() then
                    require("tsht").nodes({ ignore_injections = false })
                else
                    vim.cmd("normal! v")
                    require("leap-ast").leap()
                end
                vim.cmd("normal! Vzf")
            end,
            mode = "n",
            silent = true,
            desc = "God Fold",
        },
        {
            "z;",
            function()
                vim.cmd("normal! v")
                require("leap-ast").leap()
                vim.cmd("normal! Vzf")
            end,
            mode = "n",
            silent = true,
        },
        desc = "leap fold",
    }
end
function config.asterisk_setup()
    vim.g["asterisk#keeppos"] = 1

    local default_keymaps = {
        { "n", "*", "<Plug>(asterisk-*)" },
        { "n", "#", "<Plug>(asterisk-#)" },
        { "n", "g*", "<Plug>(asterisk-g*)" },
        { "n", "g#", "<Plug>(asterisk-g#)" },
        { "n", "z*", "<Plug>(asterisk-z*)" },
        { "n", "gz*", "<Plug>(asterisk-gz*)" },
        { "n", "z#", "<Plug>(asterisk-z#)" },
        { "n", "gz#", "<Plug>(asterisk-gz#)" },
    }
    -- for _, m in ipairs(default_keymaps) do
    --     vim.keymap.set(m[1], m[2], m[3] .. "<Cmd>lua require('hlslens').start()<CR>", {})
    -- end
end

return config
