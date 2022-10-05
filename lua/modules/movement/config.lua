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
        limit_ft_matches = 20,
        repeat_ft_with_target_char = true,
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
end
function config.leap()
    require("utils.ui.highlights").plugin("leap", {
        theme = {
            ["*"] = {
                { LeapBackdrop = { fg = "#707070" } },
            },
            horizon = {
                { LeapLabelPrimary = { fg = "#ccff88", italic = true } },
                { LeapLabelSecondary = { fg = "#99ccff" } },
                { LeapLabelSelected = { fg = "Magenta" } },
            },
        },
    })
    require("leap").setup({
        equivalence_classes = { " \t\r\n", "([{", ")]}", "`\"'", ["\r"] = "¬" },
        max_highlighted_traversal_targets = 20,
        special_keys = {
            repeat_search = "<enter>",
            next_aot_match = "<enter>",
            next_match = { "<space>", "<c-[>" },
            prev_match = { "<tab>", "<c-]>" },
            next_group = "<space>",
            prev_group = "<tab>",
        },
    })
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
    local sj = require("sj")
    sj.setup({
        -- automatically jump on a match if it is the only one
        auto_jump = true,
        -- help to better identify labels and matches
        use_overlay = true,
        highlights = {
            -- used for the label before matches
            SjLabel = { bold = true },
            -- used for everything that is not a match
            SjOverlay = { bold = true, italic = true },
            -- used to highlight matches
            SjSearch = { bold = true },
            -- used in the cmd line when the pattern has no matches
            SjWarning = { bold = true },
        },
    })
    vim.keymap.set("n", "c/", sj.run)
end
return config
