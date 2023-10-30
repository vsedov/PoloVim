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
local function leap_bi_n()
    require("leap").leap({ target_windows = { vim.api.nvim_get_current_win() }, inclusive_op = true })
end
local function leap_bi_x(inc)
    return function()
        local behind = _leap_bi()

        if inc == true or inc == 2 then
            if not behind then
                vim.cmd("normal! l")
            end
        elseif inc == false or inc == 0 then
            if behind then
                vim.cmd("normal! 2l")
            else
                vim.cmd("normal! h")
            end
        elseif inc == 1 then
            if behind then
                vim.cmd("normal! l")
            end
        end
    end
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

        safe_labels = { "s", "f", "n", "u", "t", "/", "S", "F", "N", "L", "H", "M", "U", "G", "T", "?", "Z" },
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
            "/",
            "z",
            "S",
            "F",
            "N",
            "J",
            "K",
            "L",
            "H",
            "O",
            "D",
            "W",
            "E",
            "M",
            "B",
            "U",
            "Y",
            "V",
            "R",
            "G",
            "T",
            "C",
            "X",
            "?",
            "Z",
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

        { "s", "<Plug>(leap-forward-to)", mode = "n", desc = "Leap Fwd" },
        { "S", "<Plug>(leap-backward-to)", mode = "n", desc = "Leap Bwd" },
        { "x", "<Plug>(leap-forward-till)", mode = { "o", "x" }, desc = "Leap Fwd" },
        { "X", "<Plug>(leap-backward-till)", mode = { "o", "x" }, desc = "Leap Bwd" },

        -- {
        --     "h", -- semi-inclusive
        --     function()
        --         require("leap").leap({ inclusive_op = true })
        --     end,
        --     mode = "x",
        --     desc = "Leap f",
        -- },
            {
            "H", -- semi-inclusive
                function()
                require("leap").leap({ backward = true, offset = 1, inclusive_op = true })
                end,
            mode = "x",
            desc = "Leap F",
        },
        { "h", leap_bi_o(1), mode = "o", desc = "Leap SemiInc" },
        { "H", leap_bi_o(2), mode = "o", desc = "Leap Incl." },
        { "<leader>f", leap_bi_o(2), mode = "o", desc = "Leap Inc" },
        { "<leader>t", leap_bi_o(0), mode = "o", desc = "Leap Exc" },
        {
            O.select_remote,
            function()
                lib.leap_remote()
            end,
            desc = "Leap Remote",
            mode = "o",
            },
            {
            "rp",
            mode = "n",
            desc = "Remote Paste",
            lib.remote_paste("h"),
            },
            {
            "rP",
            mode = "n",
            desc = "Remote Paste line",
            lib.remote_paste("h", "<leader>p"),
        },
        -- TODO: y<motion><something><leap><motion>
        -- TODO: why is this not working??
        {
            "rx",
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
            "rX",
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
        {
            ";r",
            mode = { "n" },
            desc = "Remote Replace",
            function()
                vim.api.nvim_feedkeys("r", "m", false)
                vim.schedule(lib.leap_remote)
                end,
            },
        }
end

return M
