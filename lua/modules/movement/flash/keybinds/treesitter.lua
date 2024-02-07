local Flash = lambda.reqidx("flash")
local lib = require("modules.movement.flash.nav.lib")
local gen_dyn_matcher = function(gen_query, check)
    if type(gen_query) ~= "function" then
        vim.notify(
            "@param{gen_query} in function{gen_dyn_matcher} must be a function that returns the treesitter query string",
            vim.log.levels.ERROR
        )
        return
    end
    check = check or "full"

    return function(win, state)
        local wininfo = vim.fn.getwininfo(win)[1]
        local wintop = wininfo.topline - 1 ---@type number
        local winbot = wininfo.botline + 1 ---@type number
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_filetype = vim.fn.getbufvar(buf, "&filetype") or "lua"
        local pattern_string = state.pattern.pattern

        local ranges = {} ---@type TSNode[]
        local matches = {} ---@type Flash.Match[]

        local parser = vim.treesitter.get_parser(buf)
        local syntax_tree = parser:parse()[1]
        local root = syntax_tree:root()
        local search_query = vim.treesitter.query.parse(buf_filetype, gen_query(pattern_string))

        for _, node, _ in search_query:iter_captures(root, buf, wintop, winbot) do
            table.insert(ranges, { node:range() })
        end

        for _, range in ipairs(ranges) do
            ---@type Flash.Match
            local match = {
                pos = { range[1] + 1, range[2] },
                end_pos = { range[3] + 1, range[4] - 1 },
            }
            local start_in_view = match.pos[1] > wintop and match.pos[1] < winbot
            local end_in_view = match.end_pos[1] > wintop and match.end_pos[1] < winbot
            local fully_in_view = start_in_view and end_in_view

            local test ---@type boolean
            if check == "end" then
                test = end_in_view
            end
            if check == "start" then
                test = start_in_view
            end
            if check == "full" then
                test = fully_in_view
            end

            if test then
                table.insert(matches, match)
            end
        end

        return matches
    end
end
local basic_query = function(pattern_string)
    return ([[
  (
  (identifier) @capture
  (#match? @capture "^%s")
  )
  ]]):format(pattern_string)
end
local O = {
    goto_prefix = ";;",
    goto_next = ";;",
    goto_previous = ";;",
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
O.select_prev = O.select_previous

return {
    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Remote Jumps  and treesitter bindings                      │
    --  ╰────────────────────────────────────────────────────────────────────╯

    {
        "<cr>",
        mode = { "o", "x" },
        function()
            Flash.remote()
        end,
        desc = "Remote Jump",
    },
    {
        "R",
        function()
            Flash.treesitter_search({
                label = { before = true, after = true, style = "inline" },
                remote_op = { restore = true },
            })
        end,
        mode = { "n" },
        desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
    },
    {
        "M",
        function()
            Flash.treesitter_search({
                label = { before = true, after = true, style = "inline" },
                remote_op = { restore = true },
            })
        end,
        mode = { "x", "o" },
        desc = "Treesitter Search | show labeled treesitter nodes around the search matches",
    },

    {
        O.select_remote_dynamic,
        mode = { "o", "x" },
        desc = "Remote Node",
        function()
            require("flash").jump({ mode = "remote_ts" })
        end,
    },
    {
        O.goto_next .. O.select_remote_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = "remote_ts", treesitter = { starting_from_pos = true } })
        end,
        desc = "Select node",
    },
    {
        O.goto_prev .. O.select_remote_dynamic,
        mode = { "o", "x" },
        function()
            require("flash").jump({ mode = "remote_ts", treesitter = { ending_at_pos = true } })
        end,
        desc = "Select node",
    },
    {
        O.goto_next .. O.select_remote_dynamic,
        mode = "n",
        function()
            require("flash").jump({ mode = "remote_ts", treesitter = { end_of_node = true }, jump = { pos = "end" } })
        end,
        desc = "Jump to end of node",
    },
    {
        O.goto_prev .. O.select_remote_dynamic,
        mode = "n",
        function()
            require("flash").jump({
                mode = "remote_ts",
                treesitter = { start_of_node = true },
                jump = { pos = "start" },
            })
        end,
        desc = "Jump to start of node",
    },
    {
        O.goto_prefix .. "w", -- TODO: stop verbs from being labels
        -- TODO: allow searching continuations
        function()
            require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cword>") })
        end,
        desc = "Flash <cword>",
    },
    {
        O.goto_prefix .. "W",
        function()
            require("flash").jump({ mode = "textcase", pattern = vim.fn.expand("<cWORD>") })
        end,
        desc = "Flash <cWORD>",
    },
    {
        O.goto_prefix .. "n",
        function()
            require("flash").jump({ continue = true })
        end,
        desc = "Continue Flash",
    },
    {
        "rix", -- TODO: better keymap?
        -- FIXME: its broken??
        mode = { "x", "n" },
        desc = "Exchange <motion1> with <node>",
        function()
            lib.swap_with({ mode = "remote_ts" })
        end,
    },
    -- TODO: y<motion><something><leap><motion>
    {
        "rx",
        mode = { "n", "x" },
        desc = "Exchange <motion1> with <motion2>",
        -- TODO: use leap?
        function()
            lib.swap_with()
        end,
    },
    {
        "rxx",
        mode = { "n", "x" },
        desc = "Exchange V<motion1> with V<motion2>",
        -- TODO: use leap?
        function()
            lib.swap_with({ exchange = {
                visual_mode = "V",
            } })
        end,
    },
    {
        ";R",
        mode = { "n" },
        desc = "Remote Replace",
        function()
            vim.api.nvim_feedkeys(";r", "m", false)

            vim.schedule(function()
                require("flash").jump({ mode = "remote_ts" })
            end)
        end,
    },
    -- TODO: Copy there, Paste here
    { -- FIXME: this
        ";ry",
        mode = { "x", "n" },
        desc = "Replace with <remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        ";rd",
        mode = { "x", "n" },
        desc = "Replace with d<remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        ";rc",
        mode = { "x", "n" },
        desc = "Replace with c<remote-motion>",
        function()
            lib.swap_with({ exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        ";rY",
        mode = { "n" },
        desc = "Replace with <node>",
        function()
            lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        ";rD",
        mode = { "x", "n" },
        desc = "Replace with d<node>",
        function()
            lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
        end,
    },
    { -- FIXME: this
        ";rC",
        mode = { "x", "n" },
        desc = "Replace with c<node>",
        function()
            lib.swap_with({ mode = "remote_ts", exchange = { not_there = true } })
        end,
    },
    {
        "u", -- unit textobject
        mode = { "o", "x" },
        function()
            Flash.treesitter({
                filter = function(matches)
                    ---@param m Flash.Match.TS
                    -- for all matches,  match[n+1] should use previous match[n] label. Do in reverse order, to prevet copying first label to all matches
                    for i = #matches, 2, -1 do
                        matches[i].label = matches[i - 1].label
                    end
                    table.remove(matches, 1) -- remove first match, as it is same as word under cursor thus redundant with word motion
                end,
                label = {
                    rainbow = {
                        enabled = true,
                    },
                },
            })
        end,
    },
    {
        ";rw",
        function()
            Flash.jump({
                matcher = gen_dyn_matcher(basic_query),
                -- select the range
                jump = { pos = "range" },
            })
        end,
        mode = { "n" },
    },
}
