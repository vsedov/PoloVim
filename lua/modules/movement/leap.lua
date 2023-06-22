local M = {}
local api = vim.api
local leap_binds = [[
binds:
<[c,d,y]arb>: [C, D, Y] around remote block [marked by leap motion]
<yarw>: yank around remote word [marked by leap motion]

──────────────────────────────────────────────────────────────────────
<zfarp>: Delete/fold/comment/etc. paragraphs without leaving your position
<yaRp>: Clone text objects in the blink of an eye, even from another window
<yaRW>: Clone text objects in Insert mode
<cimw>: Fix a typo with a short, atomic command sequence
<drr>: Operate on distant lines
<y[num]rr>: Use count y3rr yanks 3 lines, just as 3yy would do
]]
lambda.command("LeapBinds", function()
    vim.notify(leap_binds)
end, { force = true })

function paranormal(targets)
    -- Get the :normal sequence to be executed.
    local input = vim.fn.input("normal! ")
    if #input < 1 then
        return
    end

    local ns = api.nvim_create_namespace("")

    -- Set an extmark as an anchor for each target, so that we can also execute
    -- commands that modify the positions of other targets (insert/change/delete).
    for _, target in ipairs(targets) do
        local line, col = unpack(target.pos)
        id = api.nvim_buf_set_extmark(0, ns, line - 1, col - 1, {})
        target.extmark_id = id
    end

    -- Jump to each extmark (anchored to the "moving" targets), and execute the
    -- command sequence.
    for _, target in ipairs(targets) do
        local id = target.extmark_id
        local pos = api.nvim_buf_get_extmark_by_id(0, ns, id, {})
        vim.fn.cursor(pos[1] + 1, pos[2] + 1)
        vim.cmd("normal! " .. input)
    end

    -- Clean up the extmarks.
    api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

function leap_to_window()
    local target_windows = require("leap.util").get_enterable_windows()
    local targets = {}
    for _, win in ipairs(target_windows) do
        local wininfo = vim.fn.getwininfo(win)[1]
        local pos = { wininfo.topline, 1 } -- top/left corner
        table.insert(targets, { pos = pos, wininfo = wininfo })
    end
    return targets, target_windows
end

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
local function search_win()
    local pat = vim.fn.getreg("/")
    require("leap-search").leap(pat, {}, { target_windows = { vim.api.nvim_get_current_win() } })
end

local function search_ref()
    if lambda.config.ui.use_illuminate then
        local ref = require("illuminate.reference").buf_get_references(vim.api.nvim_get_current_buf())
        if not ref or #ref == 0 then
            return false
        end

        local targets = {}
        for _, v in pairs(ref) do
            table.insert(targets, {
                pos = { v[1][1] + 1, v[1][2] + 1 },
            })
        end
        require("leap").leap({ targets = targets, target_windows = { vim.api.nvim_get_current_win() } })
    else
        require("leap-search").leap(
            vim.fn.expand("<cword>"),
            {},
            { target_windows = { vim.api.nvim_get_current_win() } }
        )
    end

    return true
end

function M.highlight()
    api.nvim_set_hl(0, "LeapBackdrop", { link = "Conceal" })

    api.nvim_set_hl(0, "LeapMatch", {
        fg = "white", -- for light themes, set to 'black' or similar
        bold = true,
        nocombine = true,
    })
    api.nvim_set_hl(0, "LeapLabelPrimary", {
        fg = "#ff2f87",
        bold = true,
        nocombine = true,
    })
end

local function binds()
    require("leap").add_default_mappings()
    local default_keymaps = {
        {
            { "n", "x", "o" },
            "<c-s>",
            function()
                require("leap").leap({ target_windows = { vim.fn.win_getid() } })
            end,
            "Leap Current Buffer",
        },
        {
            { "n", "x", "o" },
            "<S-cr>",
            function()
                require("leap").leap({
                    target_windows = vim.tbl_filter(function(win)
                        return api.nvim_win_get_config(win).focusable
                    end, api.nvim_tabpage_list_wins(0)),
                })
            end,
            "Jump all windows",
        },
        {
            { "n", "x", "o" },
            "\\<cr>",
            function()
                require("leap").leap({
                    target_windows = { vim.fn.win_getid() },
                    action = paranormal,
                    multiselect = true,
                })
            end,
            "multi_curosr_normal",
        },
        -- leap-from-window)
        {
            { "n", "x", "o" },
            "<c-p>",
            function()
                local targets, target_windows = leap_to_window()
                require("leap").leap({
                    target_windows = target_windows,
                    targets = targets,
                    action = function(target)
                        api.nvim_set_current_win(target.wininfo.winid)
                    end,
                })
            end,
            "leap_to_window",
        },
        {
            { "n", "x", "o" },
            "<c-e>",
            function()
                local winid = api.nvim_get_current_win()
                require("leap").leap({
                    target_windows = { winid },
                    targets = get_line_starts(winid),
                })
            end,
            "leap_to_line",
        },

        {
            { "n", "x" },
            "c/",
            function()
                require("leap-search").leap(nil, {
                    engines = {
                        { name = "string.find", plain = true, ignorecase = true },
                        { name = "kensaku.query" },
                    },
                    experimental = {
                        backspace = true,
                        autojump = true,
                        ctrl_v = true,
                    },
                    hl_group = "WarningMsg",
                }, { target_windows = { vim.api.nvim_get_current_win() } })
            end,
            "leap search",
        },
        {
            { "n" },
            "g/",
            function()
                require("leap-search").leap(vim.fn.getreg("/"), {
                    engines = {
                        { name = "string.find", plain = true, ignorecase = true },
                        { name = "kensaku.query" },
                    },
                    experimental = {
                        backspace = true,
                        autojump = false,
                        ctrl_v = true,
                    },
                    hl_group = "WarningMsg",
                }, { target_windows = { vim.api.nvim_get_current_win() } })
            end,
            "leap search current / reg",
        },
    }

    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], { noremap = true, silent = true, desc = m[4] })
        leap_binds = leap_binds .. m[2] .. " " .. m[4] .. "\n"
    end
    --  TODO: (vsedov) (06:52:06 - 03/06/23): For some reason this is required for this to even work
    vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)")
    vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)")
end

function leap_setup()
    require("leap").setup({
        max_phase_one_targets = nil,
        highlight_unlabeled_phase_one_targets = true,
        max_highlighted_traversal_targets = 10000,
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
    vim.cmd([[autocmd ColorScheme * lua require('leap').init_highlight(true)]])
end

function M.leap_config()
    leap_setup()
    binds()
end
local function createLeapSpookyEntry(keySequence, actionName, options, desc)
    return {
        keySequence,
        function()
            require("leap").leap({
                target_windows = { vim.fn.win_getid() },
                action = require("leap-spooky").spooky_action(function()
                    return actionName
                end, options),
            })
        end,
        desc = desc,
        mode = { "v", "x", "o" },
    }
end

function M.leap_spooky()
    local entries = {
        -- NOTE: (vsedov) (17:02:45 - 13/06/23): This is for internal buffers only,
        -- if you wish to use the RR, then you would have to implement that in another variant in
        -- a sense
        createLeapSpookyEntry("irf", "vif", { keeppos = true }, "Inner function"),
        createLeapSpookyEntry("irc", "vic", { keeppos = true }, "Inner Classes"),
        createLeapSpookyEntry("irs", "vis", { keeppos = true }, "Inner Scopes"),
        createLeapSpookyEntry("imf", "vif", { keeppos = true }, "Inner function"),
        createLeapSpookyEntry("imc", "vic", { keeppos = true }, "Inner Classes"),
        createLeapSpookyEntry("ims", "vis", { keeppos = true }, "Inner Scopes"),
        createLeapSpookyEntry("arf", "vaf", { keeppos = true }, "Around function"),
        createLeapSpookyEntry("arc", "vac", { keeppos = true }, "Around Classes"),
        createLeapSpookyEntry("ars", "vas", { keeppos = true }, "Around Scopes"),
        createLeapSpookyEntry("amf", "vaf", { keeppos = true }, "Around function"),
        createLeapSpookyEntry("amc", "vac", { keeppos = true }, "Around Classes"),
        createLeapSpookyEntry("ams", "vas", { keeppos = true }, "Around Scopes"),

        { "am", mode = { "o" }, desc = "Leap magnet" },
        { "im", mode = { "o" }, desc = "Leap magnet" },
        { "mm", mode = { "o" }, desc = "Leap magnet line" },
        { "aM", mode = { "o" }, desc = "Leap magnet (windows)" },
        { "iM", mode = { "o" }, desc = "Leap magnet (windows)" },
        { "MM", mode = { "o" }, desc = "Leap magnet line (windows)" },
        { "ar", mode = { "o" }, desc = "Leap remote" },
        { "ir", mode = { "o" }, desc = "Leap remote" },
        { "rr", mode = { "o" }, desc = "Leap remote line" },
        { "aR", mode = { "o" }, desc = "Leap remote (windows)" },
        { "iR", mode = { "o" }, desc = "Leap remote (windows)" },
        { "RR", mode = { "o" }, desc = "Leap remote line (windows)" },
    }

    return entries
end

function M.leap_flit()
    require("flit").setup({
        keys = { f = "f", F = "F", t = "t", T = "T" },
        labeled_modes = "nvoi",
        multiline = true,
        opts = { equivalence_classes = { " \t", "\r\n" } },
    })
end

function M.leap_search()
    -- https://github.com/hydeik/dotfiles/blob/main/private_dot_config/nvim/lua/rc/plugins/leap.lua
    -- https://github.com/atusy/dotfiles/blob/main/dot_config/nvim/lua/plugins.lua#L2
    if lambda.config.movement.use_lasterisk then
        return {
            {
                "*",
                function()
                    require("lasterisk").search()
                    search_win()
                end,
                desc = "Search cword",
            },
            {
                "*",
                function()
                    require("lasterisk").search({ is_whole = false })
                    require("hlslens").start()
                    vim.schedule(search_win)
                    return "<C-\\><C-N>"
                end,
                mode = { "x" },
                expr = true,
                desc = "Search cword",
            },
            {
                "g*",
                function()
                    require("lasterisk").search({ is_whole = false })
                    require("hlslens").start()
                    search_win()
                end,
                desc = "Search cword",
            },
            {
                "#",
                function()
                    if search_ref() then
                        return
                    end
                    require("lasterisk").search()
                    require("hlslens").start()
                    search_win()
                end,
                desc = "Search cword (ref)",
            },
            {
                "#",
                function()
                    require("lasterisk").search({ is_whole = false })
                    require("hlslens").start()

                    vim.schedule(search_win)
                    return "<C-\\><C-N>"
                end,
                mode = { "x" },
                expr = true,
                desc = "Search cword",
            },
            {
                "g#",
                function()
                    require("lasterisk").search({ is_whole = false })
                    require("hlslens").start()
                    vim.schedule(search_win)
                end,
                desc = "Search cword",
            },
        }
    elseif lambda.config.movement.use_asterisk then
        return {}
    end
end

return M
