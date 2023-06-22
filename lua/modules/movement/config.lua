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
