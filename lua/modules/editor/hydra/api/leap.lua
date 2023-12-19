local api = vim.api
local leader = "<leader>S"
local function search(back)
    local pat = vim.fn.getreg("/")
    if vim.o.hlsearch then
        vim.o.hlsearch = false
        vim.o.hlsearch = true
    end
    local leapable = require("leap-search").leap(pat, {}, { backward = back })
    if not leapable then
        vim.cmd("normal! " .. (back and "N" or "n"))
    end
end
local config = {
    Leap = {
        color = "pink",
        body = leader,
        mode = { "n", "x", "v" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        S = {
            function()
                local pat = vim.fn.expand("<cword>")
                require("leap-search").leap(pat, {
                    engines = {
                        { name = "string.find", plain = true, ignorecase = true },
                        -- { name = "kensaku.query" }, -- to search Japanese string with romaji with
                    },
                    experimental = {
                        backspace = true,
                        autojump = true,
                        ctrl_v = true,
                    },
                    hl_group = "WarningMsg",
                    { target_windows = { api.nvim_get_current_win() } },
                })
            end,
            { nowait = true, silent = true, desc = "Leap Current Word " },
        },
        s = {
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
                }, {
                    target_windows = { vim.api.nvim_get_current_win() },
                })
            end,
            { nowait = true, silent = true, exit = true, desc = "Leap Search Word" },
        },
        n = {
            function()
                search()
            end,
            { nowait = true, silent = true, desc = "Leap Match Next" },
        },
        N = {
            function()
                search(true)
            end,
            { nowait = true, silent = true, desc = "Leap Match Prev" },
        },
    },
}

return {
    config,
    "Leap",
    { { "n", "N" } },
    { "s", "S" },
    6,
    3,
    1,
}
