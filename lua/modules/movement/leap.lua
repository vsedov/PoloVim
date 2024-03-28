local M = {}
local lib = require("modules.movement.flash.nav.lib")

local function _leap_bi()
    local winnr = vim.api.nvim_get_current_win()
    local pre_leap_pos = vim.api.nvim_win_get_cursor(winnr)
    require("leap").leap({
        target_windows = { winnr },
        inclusive_op = true,
    })
    local post_leap_pos = vim.api.nvim_win_get_cursor(winnr)

    -- If jumping behind original position
    local behind = (pre_leap_pos[1] > post_leap_pos[1])
        or ((pre_leap_pos[1] == post_leap_pos[1]) and (pre_leap_pos[2] > post_leap_pos[2]))
    return behind
end
local function leap_bi_o(inc)
    return function()
        local behind = _leap_bi()

        if inc == true or inc == 2 then
            if behind then
                vim.cmd("normal! h")
            else
                vim.cmd("normal! l")
            end
        elseif inc == false or inc == 0 then
            if behind then
                vim.cmd("normal! l")
            else
                vim.cmd("normal! h")
            end
        end
    end
end
local leap_select_state = { prev_input = nil }
local function leap_select(kwargs)
    kwargs = kwargs or {}
    if kwargs.inclusive_op == nil then
        kwargs.inclusive_op = true
    end

    local function get_input(bwd)
        vim.cmd('echo ""')
        local hl = require("leap.highlight")
        if vim.v.count == 0 and not (kwargs.unlabeled and vim.fn.mode(1):match("o")) then
            -- TODO: figure this out
            hl["apply-backdrop"](hl, bwd)
        end
        hl["highlight-cursor"](hl)
        vim.cmd("redraw")
        local ch = require("leap.util")["get-input-by-keymap"]({ str = ">" })
        hl["cleanup"](hl, { vim.fn.win_getid() })
        if not ch then
            return
        end
        -- Repeat with the previous input?
        local repeat_key = require("leap.opts").special_keys.repeat_search
        if ch == vim.api.nvim_replace_termcodes(repeat_key, true, true, true) then
            if leap_select_state.prev_input then
                ch = leap_select_state.prev_input
            else
                vim.cmd('echo "no previous search"')
                return
            end
        else
            leap_select_state.prev_input = ch
        end
        return ch
    end
    local function get_pattern(input)
        -- See `expand-to-equivalence-class` in `leap`.
        -- Gotcha! 'leap'.opts redirects to 'leap.opts'.default - we want .current_call!
        local chars = require("leap.opts").eq_class_of[input]
        if chars then
            chars = vim.tbl_map(function(ch)
                if ch == "\n" then
                    return "\\n"
                elseif ch == "\\" then
                    return "\\\\"
                else
                    return ch
                end
            end, chars or {})
            input = "\\(" .. table.concat(chars, "\\|") .. "\\)" -- "\(a\|b\|c\)"
        end
        return "\\V" .. (kwargs.multiline == false and "\\%.l" or "") .. input
    end
    local function get_targets(pattern, bwd)
        local search = require("leap.search")
        local bounds = search["get-horizontal-bounds"]()
        local get_char_at = require("leap.util")["get-char-at"]
        local match_positions = search["get-match-positions"](pattern, bounds, { ["backward?"] = bwd })
        local targets = {}
        for _, pos in ipairs(match_positions) do
            table.insert(targets, { pos = pos, chars = { get_char_at(pos, {}) } })
        end
        return targets
    end

    local targets2
    require("leap").leap({
        targets = function()
            local state = require("leap").state
            local pattern, pattern2
            if state.args.dot_repeat then
                pattern = state.dot_repeat_pattern
                pattern2 = state.dot_repeat_pattern2
            else
                local input = get_input(true)
                if not input then
                    return
                end
                pattern = get_pattern(input)

                local input2 = get_input(false)
                if not input2 then
                    return
                end
                pattern2 = get_pattern(input2)
                -- Do not save into `state.dot_repeat`, because that will be
                -- replaced by `leap` completely when setting dot-repeat.
                state.dot_repeat_pattern = pattern
                state.dot_repeat_pattern2 = pattern2
            end
            targets2 = get_targets(pattern2, false)
            return get_targets(pattern, true)
        end,
        inclusive_op = kwargs.inclusive_op,
        action = function(target)
            target.pos[2] = target.pos[2] - 1
            vim.api.nvim_win_set_cursor(0, target.pos)
            local feedkeys = vim.api.nvim_feedkeys
            feedkeys("o", "n", false)
            vim.schedule(function()
                -- TODO: AOT label this!
                require("leap").leap({
                    targets = targets2,
                    inclusive_op = kwargs.inclusive_op,
                    action = function(target)
                        target.pos[2] = target.pos[2] - 1
                        vim.api.nvim_win_set_cursor(0, target.pos)
                    end,
                })
            end)
        end,
    })
end

function highlight()
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Conceal" })

    vim.api.nvim_set_hl(0, "LeapMatch", {
        fg = "white", -- for light themes, set to 'black' or similar
        bold = true,
        nocombine = true,
    })
    vim.api.nvim_set_hl(0, "LeapLabelPrimary", {
        fg = "#ff2f87",
        bold = true,
        nocombine = true,
    })
end

local O = {
    goto_prefix = ";;",
    goto_next = "]",
    goto_previous = "[",
    goto_next_outer = "]]",
    goto_previous_outer = "[[",
    goto_next_end = "<leader>]", -- ")",
    goto_previous_end = "<leader>[", -- "(",
    goto_next_outer_end = "<leader>]]", -- "))",
    goto_previous_outer_end = "<leader>[[", -- "((",
    select = "&",
    select_dynamic = "m",
    select_remote = "r",
    select_remote_dynamic = "ir",
    select_outer = "<M-S-7>", -- M-&
    select_next = "in",
    select_previous = "iN",
    select_next_outer = "an",
    select_previous_outer = "aN",
}

O.goto_prev = O.goto_previous
O.goto_prev_outer = O.goto_previous_outer
O.goto_prev_end = O.goto_previous_end -- "(",
O.goto_prev_outer_end = O.goto_previous_outer_end -- "((",
O.select_prev = O.select_previous
O.select_prev_outer = O.select_previous_outer

local api = vim.api

function M.leap_config()
    require("leap").setup({
        max_phase_one_targets = nil,
        highlight_unlabeled_phase_one_targets = true,
        max_highlighted_traversal_targets = 10000,
        case_sensitive = false,
        -- equivalence_classes = { " \t", "\r\n" },
        equivalence_classes = { " \t\r\n" },
        substitute_chars = { ["\r"] = "¬", ["\n"] = "¬" },

        -- safe_labels = { "s", "f", "n", "u", "t", "/", "S", "F", "N", "L", "H", "M", "U", "G", "T", "?", "Z" },
        labels = {
            "s",
            "f",
            "n",
            "j",
            "k",
            "l",
            "h",
            "o",
            "d",
            "w",
            "e",
            "m",
            "b",
            "u",
            "y",
            "v",
            "r",
            "g",
            "t",
            "c",
            "x",
        },

        special_keys = {
            repeat_search = "]",
            next_phase_one_target = "[",
            next_target = { "<enter>", ";" },
            prev_target = { "<tab>", "," },
            next_group = "<space>",
            prev_group = "<tab>",
            multi_accept = "<enter>",
            multi_revert = "<backspace>",
        },
    })
    lambda.augroup("leap", {
        {
            event = { "ColorScheme" },
            targets = "*",
            command = function()
                require("leap").init_highlight(true)
                highlight()
            end,
        },
    })
    vim.defer_fn(function()
        highlight()
    end, 900)
end

function M.keys()
    return {
        { "<leader>f", "<Plug>(leap-forward-to)", mode = "x", desc = "Leap f" },
        { "<leader>t", "<Plug>(leap-forward-till)", mode = "x", desc = "Leap t" },
        { "<leader>F", "<Plug>(leap-backward-to)", mode = "x", desc = "Leap F" },
        { "<leader>T", "<Plug>(leap-backward-till)", mode = "x", desc = "Leap T" },
        -- -- { "s", leap_bi_n, mode = "n", desc = "Leap" },
        -- { "f", leap_bi_x(1), mode = "x", desc = "Leap" },
        -- { "<leader>f", leap_bi_x(2), mode = "x", desc = "Leap Inc" },
        -- { "<leader>t", leap_bi_x(0), mode = "x", desc = "Leap Exc" },
        { "h", leap_bi_o(1), mode = "o", desc = "Leap SemiInc" },
        { "H", leap_bi_o(2), mode = "o", desc = "Leap Incl." },
        { "<leader>f", leap_bi_o(2), mode = "o", desc = "Leap Inc" },
        { "<leader>t", leap_bi_o(0), mode = "o", desc = "Leap Exc" },
        { "r", leap_bi_o(0), mode = "o", desc = "Leap Exc" },

        {
            O.select_remote,
            function()
                lib.leap_remote()
            end,
            desc = "Leap Remote",
            mode = "o",
        },
        {
            ";rp",
            mode = "n",
            desc = "Remote Paste",
            lib.remote_paste("h"),
        },
        {
            ";rP",
            mode = "n",
            desc = "Remote Paste line",
            lib.remote_paste("h", "<leader>p"),
        },
        -- TODO: y<motion><something><leap><motion>
        -- TODO: why is this not working??
        {
            ";rx",
            mode = "n",
            desc = "Exchange <motion1> with <motion2>",
            function()
                lib.swap_with(
                    {},
                    nil,
                    -- "r"
                    vim.schedule_wrap(lib.leap_remote)
                )
            end,
        },
        {
            ";rX",
            mode = "n",
            desc = "Exchange V<motion1> with V<motion2>",
            function()
                lib.swap_with(
                    { exchange = {
                        visual_mode = "V",
                    } },
                    nil,
                    vim.schedule_wrap(lib.leap_remote)
                )
            end,
        },
        -- {
        --     "rx",
        --     mode = "x",
        --     -- TODO: figure this out
        -- },
        {
            ";_",
            mode = { "n" },
            desc = "Remote Replace",
            function()
                vim.api.nvim_feedkeys(";r", "m", false)
                vim.schedule(lib.leap_remote)
            end,
        },
    }
end

return M
