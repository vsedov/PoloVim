local harpoon = require("harpoon")
local Path = require("plenary.path")

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
            color = "red",
            mode = { "n", "v", "x" },
            position = "bottom-right",
            ["<ESC>"] = { nil, { exit = true } },
            t = {
                function()
                    require("yeet").select_target()
                end,
                { nowait = true, exit = true, desc = "Yeet target" },
            },
            c = {
                function()
                    require("yeet").set_cmd()
                end,
                { nowait = true, exit = true, desc = "Yeet command" },
            },
            s = {
                function()
                    require("yeet").execute()
                end,
                { nowait = true, exit = true, desc = "Yeet Execute" },
            },
            o = {
                function()
                    require("yeet").toggle_post_write()
                end,
                { nowait = true, exit = true, desc = "Yeet Post Write" },
            },
            ["<cr>"] = {
                function()
                    require("yeet").execute(nil, { clear_before_yeet = false })
                end,
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
        color = "red",
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
            function()
                require("oqt").prompt_new_task()
            end,
            { nowait = true, exit = true, desc = "OS New Task" },
        },
        s = {
            function()
                harpoon.ui:toggle_quick_menu(harpoon:list("oqt"))
            end,
            { nowait = true, exit = true, desc = "OS List taks" },
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
                harpoon:list():append()
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

        ["<leader>"] = {
            function()
                lambda.clever_tcd()
                require("harpoon.cmd-ui").toggle_quick_menu()
            end,
            { nowait = true, exit = true, desc = "UI QMenu" },
        },

        W = {
            function()
                vim.ui.input({ prompt = "Harpoon > ", default = "1" }, function(index)
                    if index == nil or index == "" then
                        return
                    end

                    require("harpoon.ui").nav_file(tonumber(index))
                end)
            end,
            { nowait = true, desc = "Jump File", exit = true },
        },
        c = {
            function()
                require("harpoon.tmux").clear_all()
            end,
            { nowait = true, desc = "Clear All", exit = true },
        },
        -- I am adding this cause this feels like it can be faster
        z = {
            function()
                vim.ui.input({ prompt = "Harpoon , Enter Zoxide location : ", default = "." }, function(item)
                    vim.cmd.Tz(item)
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
            function()
                local list = require("harpoon"):list("tmux")
                harpoon.ui:toggle_quick_menu(list)
            end,
            { desc = "Open tmux view", noremap = true, exit = true, silent = true },
        },
        t = {
            function()
                local list = require("harpoon"):list("terminals")
                harpoon.ui:toggle_quick_menu(list)
            end,
            { desc = "Open Terminal", noremap = true, exit = true, silent = true },
        },
        d = {
            function()
                local list = require("harpoon"):list()
                for i, displayed in ipairs(list:display()) do
                    if Path:new(displayed):absolute() == vim.api.nvim_buf_get_name(0) then
                        list:removeAt(i)
                        return
                    end
                end
            end,
            { desc = "Remove current file from harpoon list", noremap = true, exit = true, silent = true },
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
    { "<CR>", "W", "G", "a", "A", "c", "<leader>" }, -- 9
    6,
    3,
    1,
    { Yeet },
}
