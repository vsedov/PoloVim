local leader = "<leader>h"
local gitrepo = vim.fn.isdirectory(".git/index")
local function wrap(fn, ...)
    local args = { ... }
    local nargs = select("#", ...)
    return function()
        fn(unpack(args, nargs))
    end
end

-- Check if git is here

local function diffmaster()
    local branch = "origin/master"
    local master = vim.fn.systemlist("git rev-parse --verify develop")
    if not master[1]:find("^fatal") then
        branch = "origin/develop"
    else
        master = vim.fn.systemlist("git rev-parse --verify master")
        if not master[1]:find("^fatal") then
            branch = "origin/master"
        else
            master = vim.fn.systemlist("git rev-parse --verify main")
            if not master[1]:find("^fatal") then
                branch = "origin/main"
            end
        end
    end
    local current_branch = vim.fn.systemlist("git branch --show-current")[1]
    -- git rev-list --boundary feature/FDEL-3386...origin/main | grep "^-"
    -- local cmd = string.format([[git rev-list --boundary %s...%s | grep "^-"]], current_branch, branch)
    local cmd = string.format([[git merge-base %s %s ]], branch, current_branch)
    local hash = vim.fn.systemlist(cmd)[1]

    if hash then
        vim.notify("DiffviewOpen " .. hash)
        vim.cmd("DiffviewOpen " .. hash)
    else
        vim.notify("DiffviewOpen " .. branch)
        vim.cmd("DiffviewOpen " .. branch)
    end
end

local config = {
    Git = {
        color = "pink",
        body = leader,
        position = "bottom-right",
        on_enter = function()
            if gitrepo then
                vim.cmd("mkview")
                vim.cmd("silent! %foldopen!")
                -- vim.bo.modifiable = false
                -- if vim.
                require("gitsigns").toggle_signs(true)
                require("gitsigns").toggle_linehl(true)
                require("gitsigns").toggle_deleted(true)
            end
        end,
        on_exit = function()
            if gitrepo then
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd("loadview")
                vim.api.nvim_win_set_cursor(0, cursor_pos)
                vim.cmd("normal zv")
                require("gitsigns").toggle_signs(true)
                require("gitsigns").toggle_linehl(false)
                require("gitsigns").toggle_deleted(false)
            end
        end,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        ["<cr>"] = { ":silent lua lambda.clever_tcd()<cr>:Neogit<cr>", { exit = true, desc = "NeoGit" } },
        c = { ":Neogit commit<CR>", { exit = true, nowait = true, desc = "Commit" } },
        l = { ":Neogit log<CR>", { exit = true, nowait = true, desc = "Log" } },
        m = { ":Neogit merge<CR>", { exit = true, nowait = true, desc = "Merege" } },
        H = { ":Neogit branch<CR>", { exit = true, nowait = true, desc = "Branch" } },

        J = {
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    require("gitsigns").next_hunk()
                end)
                return "<Ignore>"
            end,
            { expr = true, desc = "next hunk" },
        },
        K = {
            function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    require("gitsigns").prev_hunk()
                end)
                return "<Ignore>"
            end,
            { expr = true, desc = "prev hunk" },
        },
        s = {
            function()
                require("gitsigns").stage_hunk()
            end,
            { exit = false, desc = "Stage Hunk" },
        },
        S = {
            function()
                require("gitsigns").stage_buffer()
            end,
            { exit = false, desc = "Stage Buffer" },
        },

        p = {
            function()
                require("gitsigns").preview_hunk()
            end,
            { desc = "Preview Hunk" },
        },
        u = {
            function()
                require("gitsigns").undo_stage_hunk()
            end,
            { desc = "Undo Stage Hunk" },
        },
        x = {
            function()
                require("gitsigns").toggle_deleted()
            end,
            { nowait = true, desc = "Toggle Deleted" },
        },
        D = {
            function()
                require("gitsigns").diffthis()
            end,
            { desc = "Diff This" },
        },

        r = {
            function()
                require("gitsigns").reset_hunk()
            end,
            { desc = "Reset Hunk" },
        },
        R = {
            function()
                require("gitsigns").reset_buffer()
            end,
            { desc = "Reset Buffer" },
        },

        q = {
            function()
                wrap(require("gitsigns").setqflist, "all")()
            end,
            { desc = "Quickfix List All" },
        },
        Q = {
            function()
                wrap(require("gitsigns").setqflist)()
            end,
            { desc = "Quickfix List" },
        },
        B = {
            function()
                require("gitsigns").blame_line({ full = true })
            end,
            { exit = true, desc = "blame_line" },
        },
        b = {
            function()
                require("gitsigns").blame_line()
            end,
            { desc = "Blame Line" },
        },
        M = { diffmaster, { silent = true, exit = true, desc = "DiffMaster" } },
        d = { ":DiffviewOpen<CR>", { silent = true, exit = true, desc = "DiffView" } },
        C = { ":GitConflictListQf<CR>", { exit = true, nowait = true, desc = "Conflict" } },
    },
}
local bracket = { "<cr>", "J", "K", "s", "S" }

local binds = {
    { "c", "l", "m", "H" },
    { "r", "R", "x", "u" },
    { "D", "p", "b", "B", "q", "Q" },
    { "d", "M", "C" },
}
return {
    config,
    "Git",
    binds,
    bracket,
    6,
    3,
}
