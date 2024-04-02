local config = {}
function config.syntax_surfer()
    require("modules.movement.syntax_surfer")
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

    -- Use cx to be consistent with vim-exchange
    vim.keymap.set("n", "<Leader>cx", "<Cmd>ISwap<CR>", { desc = "iswap: swap with next word" })
end

-- ["i|ll"] = map_cmd("()<esc>i", "()"):with_silent(),
-- ["i|lj"] = map_cmd("[]<esc>i", "[]"):with_silent(),
-- ["i|lm"] = map_cmd("{}<esc>i", "{}"):with_silent(),

function config.houdini()
    require("houdini").setup({
        mappings = { "jk", "AA", "II", "JJ", "KK" },
        check_modified = true,
        escape_sequences = {
            t = false,
            i = function(first, second)
                local seq = first .. second

                if vim.opt.filetype:get() == "terminal" or vim.bo.buftype == "terminal" then
                    return "" -- disabled
                end

                if seq == "KK" then
                    return "<bs><bs>()<esc>i"
                end
                if seq == "JJ" then
                    return "<bs><bs>[]<esc>i"
                end
                if seq == "AA" then
                    -- jump to the end of the line in insert mode
                    -- return "<bs><bs><end>"
                    return "<bs><bs><c-o>$"
                end

                if seq == "II" then
                    -- jump to the beginning of the line in insert modea
                    return "<bs><bs><c-o>^"
                end
                return "<bs><bs><esc>"
            end,
            r = "<bs><bs><esc>",
            c = "<bs><bs><c-c>",
            ["ic"] = "<BS><BS><ESC>",
            ["ix"] = "<BS><BS><ESC>",
            ["R"] = "<BS><BS><ESC>",
            ["Rc"] = "<BS><BS><ESC>",
            ["Rx"] = "<BS><BS><ESC>",
            ["Rv"] = "<BS><BS><ESC>",
            ["Rvc"] = "<BS><BS><ESC>",
            ["Rvx"] = "<BS><BS><ESC>",
            ["rm"] = "<ESC>",
            ["cv"] = ("<BS>"):rep(100) .. "vi<CR>",
        },
    })
end

function config.harpoon()
    require("modules.movement.harpoon")
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
            "S",
            tsht,
            mode = { "o", "x" },
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
function config.trailblazer()
    require("trailblazer").setup({
        auto_save_trailblazer_state_on_exit = true,
        auto_load_trailblazer_state_on_enter = true,
        mappings = {
            nv = {
                -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
                motions = {
                    new_trail_mark = "ma",
                    track_back = "mb",
                    peek_move_next_down = "mj",
                    peek_move_previous_up = "mk",
                    toggle_trail_mark_list = "md",
                },
                actions = {
                    delete_all_trail_marks = "mL",
                    paste_at_last_trail_mark = "mn",
                    paste_at_all_trail_marks = "mN",
                    set_trail_mark_select_mode = "mt",
                    switch_to_next_trail_mark_stack = "m[",
                    switch_to_previous_trail_mark_stack = "m]",
                    set_trail_mark_stack_sort_mode = "ms",
                },
            },
        },
    })
end

return config
