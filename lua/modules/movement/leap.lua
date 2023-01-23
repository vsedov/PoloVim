local M = {}
local api = vim.api

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

function leap_to_window()
    target_windows = require("leap.util").get_enterable_windows()
    local targets = {}
    for _, win in ipairs(target_windows) do
        local wininfo = vim.fn.getwininfo(win)[1]
        local pos = { wininfo.topline, 1 } -- top/left corner
        table.insert(targets, { pos = pos, wininfo = wininfo })
    end
    return targets, target_windows
end

function binds()
    require("leap").add_default_mappings()
    local default_keymaps = {
        {
            { "n", "x", "o" },
            "<c-s>",
            function()
                require("leap").leap({ target_windows = { vim.fn.win_getid() } })
            end,
        },
        {
            { "n", "x", "o" },
            "cS",
            function()
                require("leap").leap({
                    target_windows = vim.tbl_filter(function(win)
                        return vim.api.nvim_win_get_config(win).focusable
                    end, vim.api.nvim_tabpage_list_wins(0)),
                })
            end,
        },
        {
            { "n", "x", "o" },
            "<c-]>",
            function()
                require("leap").leap({
                    target_windows = { vim.fn.win_getid() },
                    action = paranormal,
                    multiselect = true,
                })
            end,
        },
        {
            { "n", "x", "o" },
            "<c-#>",
            function()
                targets, target_windows = leap_to_window()
                require("leap").leap({
                    target_windows = target_windows,
                    targets = targets,
                    action = function(target)
                        vim.api.nvim_set_current_win(target.wininfo.winid)
                    end,
                })
            end,
        },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true })
    end
end

function leap_setup()
    require("leap").setup({
        max_phase_one_targets = nil,
        highlight_unlabeled_phase_one_targets = true,
        max_highlighted_traversal_targets = 50,
        case_sensitive = false,
        equivalence_classes = { " \t", "\r\n" },
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
end
function M.leap_config()
    leap_setup()
    binds()
    highlight()
end
function M.leap_spooky()
    require("leap-spooky").setup({
        affixes = {
            remote = { window = "r", cross_window = "R" },
            magnetic = { window = "m", cross_window = "M" },
        },
        paste_on_remote_yank = true,
    })
end

function M.leap_flit()
    require("flit").setup({
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "nvo",
        multiline = true,
        opts = { equivalence_classes = { " \t", "\r\n" } },
    })
end

return M
