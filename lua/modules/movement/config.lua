local config = {}
function config.syntax_surfer()
    require("modules.movement.syntax_surfer")
end

function config.lightspeed()
    require("lightspeed").setup({
        ignore_case = false,
        exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
        --- s/x ---
        jump_to_unique_chars = { safety_timeout = 400 },
        match_only_the_start_of_same_char_seqs = true,
        force_beacons_into_match_width = true,
        -- Display characters in a custom way in the highlighted matches.
        substitute_chars = { ["\r"] = "¬" },
        -- Leaving the appropriate list empty effectively disables "smart" mode,
        -- and forces auto-jump to be on or off.
        -- These keys are captured directly by the plugin at runtime.
        special_keys = {
            next_match_group = "<space>",
            prev_match_group = "<tab>",
        },
        --- f/t ---
        limit_ft_matches = nil,
        repeat_ft_with_target_char = false,
    })
    local default_keymaps = {
        { "n", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "x", "<c-s>", "<Plug>Lightspeed_omni_s" },
        { "o", "<c-s>", "<Plug>Lightspeed_omni_s" },

        { "x", "cs", "<Plug>Lightspeed_omni_gs" },
        { "n", "cs", "<Plug>Lightspeed_omni_gs" },
        { "o", "cs", "<Plug>Lightspeed_omni_gs" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
    end

    vim.g.lightspeed_last_motion = ""
    lambda.augroup("lightspeed_last_motion", {
        {

            event = "User",
            pattern = { "LightspeedSxEnter" },
            command = function()
                vim.g.lightspeed_last_motion = "sx"
            end,
        },
        {
            event = "User",
            pattern = { "LightspeedFxEnter" },
            command = function()
                vim.g.lightspeed_last_motion = "fx"
            end,
        },
    })

    local search_types = {
        ["<c-[>"] = ";",
        ["<c-]>"] = ",",
    }

    for k, v in pairs(search_types) do
        vim.keymap.set("n", k, function()
            return vim.g.lightspeed_last_motion == "sx" and "<Plug>Lightspeed_" .. v .. "_sx"
                or "<Plug>Lightspeed_" .. v .. "_ft"
        end, { expr = true, noremap = true })
    end
    -- I want to test something out actually
    vim.keymap.set("n", "f", "f")
    vim.keymap.set("n", "F", "F")
    vim.keymap.set("n", "t", "t")
    vim.keymap.set("n", "T", "T")
end
function config.leap()
    require("utils.ui.highlights").plugin("leap", {
        theme = {
            ["*"] = {
                { LeapBackdrop = { link = "Comment" } },
            },
        },
    })
    require("leap").setup({
        max_highlighted_traversal_targets = 20,
        special_keys = {
            repeat_search = "<enter>",
            next_match = "<space>",
            prev_match = "<C-space>",
            next_group = "<tab>",
            prev_group = "<S-tab>",
        },
        equivalence_classes = { " \t\r\n" },
        substitute_chars = { ["\t\r\n"] = "¬" },
    })
    -- vim.cmd[[autocmd ColorScheme * lua require('leap').init_highlight(true)]]
    require("leap").set_default_keymaps()

    local function get_line_starts(winid)
        local wininfo = vim.fn.getwininfo(winid)[1]
        local cur_line = vim.fn.line(".")

        -- Get targets.
        local targets = {}
        local lnum = wininfo.topline
        while lnum <= wininfo.botline do
            local fold_end = vim.fn.foldclosedend(lnum)
            -- Skip folded ranges.
            if fold_end ~= -1 then
                lnum = fold_end + 1
            else
                if lnum ~= cur_line then
                    table.insert(targets, { pos = { lnum, 1 } })
                end
                lnum = lnum + 1
            end
        end
        -- Sort them by vertical screen distance from cursor.
        local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)["row"]
        local function screen_rows_from_cur(t)
            local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])["row"]
            return math.abs(cur_screen_row - t_screen_row)
        end
        table.sort(targets, function(t1, t2)
            return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
        end)

        if #targets >= 1 then
            return targets
        end
    end

    -- Usage:
    local function leap_to_line()
        winid = vim.api.nvim_get_current_win()
        require("leap").leap({
            target_windows = { winid },
            targets = get_line_starts(winid),
        })
    end

    function leap_to_window()
        target_windows = require("leap.util").get_enterable_windows()
        local targets = {}
        for _, win in ipairs(target_windows) do
            local wininfo = vim.fn.getwininfo(win)[1]
            local pos = { wininfo.topline, 1 } -- top/left corner
            table.insert(targets, { pos = pos, wininfo = wininfo })
        end

        require("leap").leap({
            target_windows = target_windows,
            targets = targets,
            action = function(target)
                vim.api.nvim_set_current_win(target.wininfo.winid)
            end,
        })
    end
    -- The following example showcases a custom action, using `multiselect`. We're
    -- executing a `normal!` command at each selected position (this could be even
    -- more useful if we'd pass in custom targets too).

    function paranormal(targets)
        -- Get the :normal sequence to be executed.
        local input = vim.fn.input("normal! ")
        if #input < 1 then
            return
        end

        local ns = vim.api.nvim_create_namespace("")

        -- Set an extmark as an anchor for each target, so that we can also execute
        -- commands that modify the positions of other targets (insert/change/delete).
        for _, target in ipairs(targets) do
            local line, col = unpack(target.pos)
            id = vim.api.nvim_buf_set_extmark(0, ns, line - 1, col - 1, {})
            target.extmark_id = id
        end

        -- Jump to each extmark (anchored to the "moving" targets), and execute the
        -- command sequence.
        for _, target in ipairs(targets) do
            local id = target.extmark_id
            local pos = vim.api.nvim_buf_get_extmark_by_id(0, ns, id, {})
            vim.fn.cursor(pos[1] + 1, pos[2] + 1)
            vim.cmd("normal! " .. input)
        end

        -- Clean up the extmarks.
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end

    local default_keymaps = {
        {
            { "n", "x", "o" },
            "cs",
            function()
                require("leap").leap({
                    target_windows = vim.tbl_filter(function(win)
                        return vim.api.nvim_win_get_config(win).focusable
                    end, vim.api.nvim_tabpage_list_wins(0)),
                })
            end,
            "Searching in all windows (including the current one) on the tab page.",
        },

        {
            { "n", "o", "x" },
            "<c-s>",
            function()
                require("leap").leap({ target_windows = { vim.fn.win_getid() } })
            end,
            "Bidirectional search in the current window is just a specific case of the",
        },

        { "n", "<localleader><localleader>", leap_to_line, "linewise motion" },
        {
            "n",
            "cS",
            leap_to_window,
            "Window pick use <bp> and <enter>",
        },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { desc = m[4], noremap = true, silent = true })
    end
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
        prompt_prefix = "Pattern ? ",
        search_scope = "visible_lines",

        highlights = {
            SjFocusedLabel = { fg = colors.white, bg = colors.magenta, bold = false, italic = false },
            SjLabel = { fg = colors.black, bg = colors.blue, bold = true, italic = false },
            SjLimitReached = { fg = colors.black, bg = colors.orange, bold = true, italic = false },
            SjMatches = { fg = colors.light_gray, bg = colors.darker_blue, bold = false, italic = false },
            SjNoMatches = { fg = colors.orange, bold = false, italic = false },
            SjOverlay = { fg = colors.dark_blue, bold = false, italic = false },
        },

        keymaps = {
            prev_match = "<C-p>", -- focus the previous label and match
            next_match = "<C-n>", -- focus the next label and match
            send_to_qflist = "<C-q>", --- send search result to the quickfix list
        },
    })

    vim.keymap.set("n", "c/", sj.run)
    vim.keymap.set({ "n", "o", "v" }, "c?", function()
        sj.run({
            auto_jump = true,
            max_pattern_length = 1,
            pattern_type = "lua_plain",
            search_scope = "current_line",
            use_overlay = false,
        })
    end)
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
    vim.cmd([[
            highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
            highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
        ]])

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
            event = "User",
            pattern = "LightspeedSxEnter",
            command = disable_quick_scope,
        },
        {
            event = "User",
            pattern = "LightspeedSxLeave",
            command = enable_quick_scope,
        },
        {
            event = "ColorScheme",
            pattern = "*",
            command = "highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline",
        },
        {
            event = "ColorScheme",
            pattern = "*",
            command = "highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline",
        },
    })
end
return config
