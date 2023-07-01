local Flash = lambda.reqidx("flash")

return {
    "f",
    "t",
    "F",
    "T",

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
        "x",
        mode = { "o", "x" },
        function()
            -- Flash: exact mode, multi window, all directions, with a backdrop
            Flash.jump({
                continue = true,
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
                continue = true,
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

    {
        "S", -- trree hopper thing replacement in some sense
        mode = { "o", "x" },
        function()
            Flash.treesitter()
        end,
        desc = "Operator Pending Flash Treesitter",
    },
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
            Flash.jump()
        end,

        desc = "Flash Current Screen",
    },
    {
        "<leader>ww",
        mode = { "n", "o", "x" },
        function()
            Flash.jump({
                search = { mode = "search" },
                label = { after = false, before = { 0, 0 }, uppercase = false },
                pattern = [[\<\|\>]],
                action = function(match, state)
                    state:hide()
                    Flash.jump({
                        search = { max_length = 0 },
                        label = { distance = false },
                        highlight = { matches = false },
                        matcher = function(win)
                            return vim.tbl_filter(function(m)
                                return m.label == match.label and m.win == win
                            end, state.results)
                        end,
                    })
                end,
                labeler = function(matches, state)
                    local labels = state:labels()
                    for m, match in ipairs(matches) do
                        match.label = labels[math.floor((m - 1) / #labels) + 1]
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
                    multi_window = false,
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
        "<leader>/",
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
                        return ([[\v<%s\w*>]]):format(pattern), ([[\v<%s]]):format(pattern)
                    end,
                },
                -- select the range
                jump = { pos = "range" },
            })
        end,
        desc = "Select any word",
    },
}
