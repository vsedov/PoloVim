local Flash = lambda.reqidx("flash")

return {
    "f",
    "t",
    "F",
    "T",
    {
        "x",
        mode = { "o", "x" },
        function()
            -- Flash: exact mode, multi window, all directions, with a backdrop
            Flash.jump({
                search = { forward = true, wrap = false, multi_window = false },
            })
        end,
        desc = "Operator Pending Flash Forward",
    },
    {
        "X",
        mode = { "o", "x" },
        function()
            require("flash").jump({
                search = { forward = false, wrap = false, multi_window = false },
            })
        end,
        desc = "Operator Pending Flash Backward",
    },

    {
        "s",
        mode = { "n" },
        function()
            -- default options: exact mode, multi window, all directions, with a backdrop
            Flash.jump({
                search = { forward = true, wrap = false, multi_window = false },
            })
        end,
        desc = "Normal Mode Flash Forward",
    },
    {
        "S",
        mode = { "n" },
        function()
            Flash.jump({
                search = { forward = false, wrap = false, multi_window = false },
            })
        end,
        desc = "Normal Mode Flash Backward",
    },
    --
    {
        "S", -- trree hopper thing replacement in some sense
        mode = { "o", "x" },
        function()
            Flash.treesitter()
        end,
        desc = "Operator Pending Flash Treesitter",
    },

    --  ╭────────────────────────────────────────────────────────────────────╮
    --  │         Word Jumpers                                               │
    --  ╰────────────────────────────────────────────────────────────────────╯
    {
        "?",
        mode = { "n" },
        function()
            Flash.jump({ mode = "fuzzy" })
        end,
        desc = "Fuzzy search",
    },
    {
        "?",
        mode = { "o" },
        function()
            Flash.remote({ mode = "select" })
        end,
        desc = "Fuzzy Sel",
    },
    {
        "?",
        mode = "x",
        function()
            Flash.jump({ mode = "select" })
        end,
        desc = "Fuzzy Sel",
    },
    "/",
    {
        "<leader>W",
        mode = { "n", "o", "x" },
        function()
            Flash.jump({
                pattern = vim.fn.expand("<cword>"),
            })
        end,

        desc = "Flash Current word",
    },

    {
        "<S-cr>",

        mode = { "n", "o", "x" },
        function()
            ---@param opts Flash.Format
            local function format(opts)
                -- always show first and second label
                return {
                    { opts.match.label1, "FlashMatch" },
                    { opts.match.label2, "FlashLabel" },
                }
            end

            Flash.jump({
                search = { mode = "search" },
                label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                pattern = [[\<]],
                action = function(match, state)
                    state:hide()
                    Flash.jump({
                        search = { max_length = 0 },
                        highlight = { matches = false },
                        label = { format = format },
                        matcher = function(win)
                            -- limit matches to the current label
                            return vim.tbl_filter(function(m)
                                return m.label == match.label and m.win == win
                            end, state.results)
                        end,
                        labeler = function(matches)
                            for _, m in ipairs(matches) do
                                m.label = m.label2 -- use the second label
                            end
                        end,
                    })
                end,
                labeler = function(matches, state)
                    local labels = state:labels()
                    for m, match in ipairs(matches) do
                        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                        match.label2 = labels[(m - 1) % #labels + 1]
                        match.label = match.label1
                    end
                end,
            })
        end,

        desc = "Flash Current Screen",
    },

    {
        --  TODO: (vsedov) (21:59:14 - 24/06/23): Return this to normal if this is not viable
        "<c-s>",
        mode = { "n", "o", "x" },
        function()
            Flash.jump({
                search = {
                    multi_window = true,
                    mode = "textcase",
                },
            })
        end,
        desc = "Flash Current buffer",
    },
    {
        "<c-s>",
        mode = { "c" },
        function()
            Flash.toggle()
        end,
        desc = "Toggle Flash Search",
    },
    {
        "\\/",
        mode = { "n", "x", "o" },
        function()
            Flash.jump({
                pattern = ".", -- initialize pattern with any char
                search = {
                    mode = function(pattern)
                        -- remove leading dot
                        if pattern:sub(1, 1) == "." then
                            pattern = pattern:sub(2)
                        end
                        -- return word pattern and proper skip pattern
                        return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
                    end,
                },
                -- select the range
                jump = { pos = "range" },
            })
        end,
        desc = "Select any word",
    },
}
