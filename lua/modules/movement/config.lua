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
        mappings = { "jk", "aa", "ii", "jj", "kk" },
        check_modified = true,
        escape_sequences = {
            t = false,
            i = function(first, second)
                local seq = first .. second

                if vim.opt.filetype:get() == "terminal" or vim.bo.buftype == "terminal" then
                    return "" -- disabled
                end

                if seq == "kk" then
                    return "<bs><bs>()<esc>i"
                end
                if seq == "jj" then
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
    -- require("harpoon").setup({
    --     global_settings = {
    --         save_on_toggle = true,
    --         save_on_change = true,
    --         enter_on_sendcmd = true,
    --         tmux_autoclose_windows = true,
    --         excluded_filetypes = { "harpoon" },
    --         mark_branch = true,
    --     },
    -- })
    --
    -- require("telescope").load_extension("harpoon")

    -- Transistion to harpoon 2
    function update_config(win, fn)
        local config = vim.api.nvim_win_get_config(win)
        local res = fn(config)
        if res ~= nil then
            config = res
        end
        vim.api.nvim_win_set_config(win, config)
    end

    local harpoon = require("harpoon")

    local Extensions = require("harpoon.extensions")

    local tmux = {
        automated = true,
        encode = false,
        prepopulate = function(cb)
            vim.system({
                "tmux",
                "list-sessions",
            }, { text = true }, function(out)
                if out.code ~= 0 then
                    return
                end
                local sessions = out.stdout or ""
                local lines = {}
                for s in sessions:gmatch("[^\r\n]+") do
                    table.insert(lines, { value = s, context = { row = 1, col = 1 } })
                end
                cb(lines)
            end)
        end,
        select = function(list_item, _list, _option)
            local sessionName = string.match(list_item.value, "([^:]+)")
            vim.system({ "tmux", "switch-client", "-t", sessionName }, {}, function() end)
        end,
        remove = function(list_item, _list)
            local sessionName = string.match(list_item.value, "([^:]+)")
            vim.system({ "tmux", "kill-session", "-t", sessionName }, {}, function() end)
        end,
    }

    local terminals = {
        automated = true,
        encode = false,
        select_with_nil = true,
        -- TODO: merge list to maintain user-defined order and allow removal via buffer
        prepopulate = function()
            local bufs = vim.api.nvim_list_bufs()
            return vim.iter(bufs)
                :filter(function(buf)
                    return vim.bo[buf].buftype == "terminal"
                end)
                :map(function(buf)
                    local term = require("toggleterm.terminal").find(function(t)
                        return t.bufnr == buf
                    end)
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    if term then
                        if term.display_name and (#bufname == 0 or #bufname > #term.display_name) then
                            bufname = term.display_name
                        else
                            bufname = string.format("%s [%d]", term:_display_name(), term.id)
                        end
                    end
                    return {
                        value = bufname,
                        context = {
                            bufnr = buf,
                        },
                    }
                end)
                :totable()
        end,
        remove = function(list_item, _list)
            local bufnr = list_item.context.bufnr
            vim.schedule(function()
                if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
                    require("bufdelete").bufdelete(bufnr, true)
                end
            end)
        end,
        select = function(list_item, _list, _opts)
            if list_item.context.bufnr == nil or not vim.api.nvim_buf_is_valid(list_item.context.bufnr) then
                -- create a new terminal if the buffer is invalid
                local Terminal = require("toggleterm.terminal").Terminal
                local term = Terminal:new({
                    display_name = list_item.value,
                })
                term:open()
                list_item.context.bufnr = term.bufnr
            else
                -- jump to existing window containing the buffer
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if buf == list_item.context.bufnr then
                        vim.api.nvim_set_current_win(win)
                        return
                    end
                end
            end

            -- switch to the buffer if no window was found
            vim.api.nvim_set_current_buf(list_item.context.bufnr)

            Extensions.extensions:emit(Extensions.event_names.NAVIGATE, {
                list = _list,
                item = list_item,
                buffer = list_item.context.bufnr,
            })
        end,
    }
    local oqt = require("oqt")
    harpoon:setup({
        ["cmd"] = {

            -- When you call list:append() this function is called and the return
            -- value will be put in the list at the end.
            --
            -- which means same behavior for prepend except where in the list the
            -- return value is added
            --
            -- @param possible_value string only passed in when you alter the ui manual
            add = function(possible_value)
                -- get the current line idx
                local idx = vim.fn.line(".")

                -- read the current line
                local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
                if cmd == nil then
                    return nil
                end

                return {
                    value = cmd,
                    -- context = { ... any data you want ... },
                    content = string.format("%s", cmd),
                }
            end,

            --- This function gets invoked with the options being passed in from
            --- list:select(index, <...options...>)
            --- @param list_item {value: any, context: any}
            --- @param list { ... }
            --- @param option any
            select = function(list_item, list, option)
                -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
                vim.cmd(list_item.value)
            end,
        },
        oqt = oqt.harppon_list_config,
        settings = {
            save_on_toggle = true,
            -- sync_on_ui_close = true,
            key = function()
                return vim.uv.cwd() --[[@as string]]
            end,
        },
        tmux = tmux,
        terminals = terminals,
        default = {},
        menu = {
            width = vim.api.nvim_win_get_width(0) - 4,
        },
    })

    local Path = require("plenary.path")

    local titles = {
        ADD = "added",
        REMOVE = "removed",
    }

    local function notify(event, cx)
        if not cx then
            return
        end

        -- if cx.list and cx.list.config.automated then
        --   return
        -- end
        local path = Path:new(cx.item.value) --[[@as Path]]

        local display = path:make_relative(vim.uv.cwd()) or path:make_relative(vim.env.HOME) or path:normalize()
    end

    local function handler(evt)
        return function(...)
            notify(evt, ...)
        end
    end

    ---@param list HarpoonList
    ---@param items HarpoonListItem[]
    local function add_items(list, items)
        for _, item in ipairs(items) do
            local exists = false
            for _, list_item in ipairs(list.items) do
                if list.config.equals(item, list_item) then
                    exists = true
                    break
                end
            end
            if not exists then
                list:append(item)
            end
        end
    end

    ---@param list HarpoonList
    local function add_new_entries(list)
        ---@diagnostic disable-next-line: undefined-field
        if not list.config.prepopulate then
            return
        end

        local sync_items =
            ---@diagnostic disable-next-line: undefined-field
            list.config.prepopulate(function(items)
                if type(items) ~= "table" then
                    return
                end
                add_items(list, items)
                -- if ui is open, buffer needs to be updated
                -- so that items aren't removed immediately after being added
                vim.schedule(function()
                    local ui_buf = harpoon.ui.bufnr
                    if ui_buf and vim.api.nvim_buf_is_valid(ui_buf) then
                        local lines = list:display()
                        vim.api.nvim_buf_set_lines(ui_buf, 0, -1, false, lines)
                    end
                end)
            end)
        if sync_items and type(sync_items) == "table" then
            add_items(list, sync_items)
        end
    end

    ---@param list HarpoonList
    local function prepopulate(list)
        ---@diagnostic disable-next-line: undefined-field
        if list.config.prepopulate and list:length() == 0 then
            -- async via callback, or sync via return value
            local sync_items =
                ---@diagnostic disable-next-line: undefined-field
                list.config.prepopulate(function(items)
                    if type(items) ~= "table" then
                        return
                    end
                    for _, item in ipairs(items) do
                        list:append(item)
                    end
                    -- if ui is open, buffer needs to be updated
                    -- so that items aren't removed immediately after being added
                    vim.schedule(function()
                        local ui_buf = harpoon.ui.bufnr
                        if ui_buf and vim.api.nvim_buf_is_valid(ui_buf) then
                            local lines = list:display()
                            vim.api.nvim_buf_set_lines(ui_buf, 0, -1, false, lines)
                        end
                    end)
                end)
            if sync_items and type(sync_items) == "table" then
                for _, item in ipairs(sync_items) do
                    list:append(item)
                end
            end
        end
    end

    harpoon:extend({
        ADD = handler("ADD"),
        REMOVE = function(cx)
            notify("REMOVE", cx)
            if cx.list.config.remove then
                cx.list.config.remove(cx.item, cx.list)
            end
        end,
        UI_CREATE = function(cx)
            local win = cx.win_id
            vim.wo[win].cursorline = true
            vim.wo[win].signcolumn = "no"

            update_config(win, function(config)
                config.footer = harpoon.ui.active_list.name
                config.footer_pos = "center"
                return config
            end)

            vim.keymap.set("n", "<C-v>", function()
                harpoon.ui:select_menu_item({ vsplit = true })
            end, { buffer = cx.bufnr })
            vim.keymap.set("n", "<C-s>", function()
                harpoon.ui:select_menu_item({ split = true })
            end, { buffer = cx.bufnr })
        end,
        ---@param list HarpoonList
        LIST_READ = function(list)
            ---@diagnostic disable-next-line: undefined-field
            if list.config.automated then
                add_new_entries(list)
            end
        end,
        LIST_CREATED = prepopulate,
    })
    oqt.setup_keymaps()
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
