local harpoon = require("harpoon")
local Path = require("plenary.path")

local function safe(fn, fallback)
    return function()
        local ok = pcall(fn)
        if not ok and fallback then
            pcall(fallback)
        end
    end
end

local api = vim.api

local leader = "<cr>"

local h_conf = lambda.config.movement.harpoon
local function harpoon_ns()
    return api.nvim_create_namespace("harpoon_sign")
end
api.nvim_set_hl(0, "HarpoonSign", { fg = "#8aadf4", bold = true })

local function harpoon_sign(row)
    api.nvim_buf_set_extmark(0, harpoon_ns(), row - 1, -1, {
        sign_text = " ", -- check your `signcolumn` option
        sign_hl_group = "HarpoonSign",
    })
end

local function harpoon_add()
    api.nvim_buf_clear_namespace(0, harpoon_ns(), 0, -1)
    harpoon_sign(vim.fn.line("."))
    harpoon:list():append()
end

local Yeet = {
    {
        Yeet = {
            mode = { "n", "v", "x" },
            position = "bottom-right",
            ["<ESC>"] = { nil, { exit = true } },
            t = {
                safe(function() require("yeet").select_target() end),
                { nowait = true, exit = true, desc = "Yeet target" },
            },
            c = {
                safe(function() require("yeet").set_cmd() end),
                { nowait = true, exit = true, desc = "Yeet command" },
            },
            s = {
                safe(function() require("yeet").execute() end),
                { nowait = true, exit = true, desc = "Yeet Execute" },
            },
            o = {
                safe(function() require("yeet").toggle_post_write() end),
                { nowait = true, exit = true, desc = "Yeet Post Write" },
            },
            ["<cr>"] = {
                safe(function() require("yeet").execute(nil, { clear_before_yeet = false }) end),
                { nowait = true, exit = true, desc = "Yeet Execute" },
            },
        },
    },
    "Yeet",
    { { "t", "c", "o" } },
    { "<cr>", "s" },

    6,
    4,
    1,
}

local config = {
    Harpoon = {
        body = leader,
        mode = { "n" },
        position = "bottom-right",

        ["<ESC>"] = { nil, { exit = true } },
        A = {
            function()
                harpoon_add()
            end,
            { nowait = true, exit = true, desc = "Harpoon Add" },
        },
        S = {
            safe(
                function() require("oqt").prompt_new_task() end,
                function() vim.notify("oqt not available", vim.log.levels.WARN) end
            ),
            { nowait = true, exit = true, desc = "OS New Task" },
        },
        s = {
            safe(
                function() harpoon.ui:toggle_quick_menu(harpoon:list("oqt")) end,
                function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
            ),
            { nowait = true, exit = true, desc = "OS List tasks" },
        },

        ["<CR>"] = {
            function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            { nowait = true, exit = true, desc = "Quick Menu" },
        },
        G = {
            function()
                h_conf.goto_harpoon = not h_conf.goto_harpoon
                vim.notify("Goto Harpoon " .. tostring(h_conf.goto_harpoon))
            end,
            { nowait = true, exit = true, desc = "Toggle Goto" },
        },

        a = {
            function()
                harpoon:list():add()
            end,
            { nowait = true, exit = true, desc = "Add File" },
        },
        n = {
            function()
                harpoon:list():next()
            end,
            { nowait = true, exit = false, desc = "Next File" },
        },
        N = {
            function()
                harpoon:list():prev()
            end,
            { nowait = true, exit = false, desc = "Prev File" },
        },

        W = {
            function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            { nowait = true, desc = "Quick Menu", exit = true },
        },
        c = {
            safe(
                function() require("harpoon.tmux").clear_all() end,
                function() harpoon:list():clear() end
            ),
            { nowait = true, desc = "Clear All", exit = true },
        },
        z = {
            function()
                vim.ui.input({ prompt = "Harpoon , Enter Zoxide location : ", default = "." }, function(item)
                    if not item or item == "" then return end
                    local ok = pcall(vim.cmd.Tz, item)
                    if not ok then
                        pcall(vim.cmd, "cd " .. vim.fn.shellescape(item))
                    end
                end)
            end,
            { nowait = true, desc = "Zoxide", exit = true },
        },
        w = {
            function()
                vim.ui.input({ prompt = "Harpoon , command ", default = "." }, function(item)
                    if item == "." then
                        return
                    end
                    harpoon:list("oqt"):append(item)
                end)
            end,
            { nowait = true, desc = "Overseer Tasks Add", exit = true },
        },

        ["<bs>"] = {
            safe(
                function() harpoon.ui:toggle_quick_menu(harpoon:list("tmux")) end,
                function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
            ),
            { desc = "Open tmux view", noremap = true, exit = true, silent = true },
        },
        t = {
            safe(
                function() harpoon.ui:toggle_quick_menu(harpoon:list("terminals")) end,
                function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
            ),
            { desc = "Open Terminal", noremap = true, exit = true, silent = true },
        },
        f = {
            safe(
                function() harpoon.ui:toggle_quick_menu(harpoon:list("files")) end,
                function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
            ),
            { desc = "Open Files", noremap = true, exit = true, silent = true },
        },
        ["<leader>"] = {
            function()
                harpoon:list("files"):append()
            end,
            { nowait = true, exit = true, desc = "FileAppend" },
        },

        o = { function() end, { exit = true, desc = "Yeet" } },
    },
}

return {
    config,
    "Harpoon",
    {
        {
            "w",
            "s",
            "S",
        },
        {
            "z",
            "n",
            "N",
        },
        {
            "<bs>",
            "t",
            "d",
        },
    }, -- 3
    { "<CR>", "W", "G", "a", "A", "c", "<leader>", "f" }, -- 9
    6,
    3,
    1,
    { Yeet },
}
