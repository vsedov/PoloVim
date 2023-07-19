local leader = "<leader>h"
local gitsigns = lambda.reqidx("gitsigns")
local function wrap(fn, ...)
    local args = { ... }
    local nargs = select("#", ...)
    return function()
        fn(unpack(args, nargs))
    end
end

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
        -- on_enter = function()
        --     vim.bo.modifiable = false
        --     gitsigns.toggle_linehl(true)
        --     gitsigns.toggle_deleted(true)
        -- end,
        -- on_exit = function()
        --     gitsigns.toggle_linehl(false)
        --     gitsigns.toggle_deleted(false)
        --     vim.cmd("echo") -- clear the echo area
        -- end,
        on_key = function()
            vim.wait(50)
        end,
        on_enter = function()
            vim.cmd("mkview")
            vim.cmd("silent! %foldopen!")
            -- vim.bo.modifiable = false
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
            gitsigns.toggle_deleted(true)
        end,
        on_exit = function()
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd("loadview")
            vim.api.nvim_win_set_cursor(0, cursor_pos)
            vim.cmd("normal zv")
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(false)
            gitsigns.toggle_deleted(false)
        end,
        mode = { "n", "v", "x", "o" },
        ["<ESC>"] = { nil, { exit = true } },
        ["<cr>"] = { ":silent lua lambda.clever_tcd()<cr>:Neogit<cr>", { exit = true, desc = "NeoGit" } },
        l = { ":Neogit log<CR>", { exit = true, nowait = true, desc = "Log" } },
        m = { ":Neogit merge<CR>", { exit = true, nowait = true, desc = "Merege" } },
        H = { ":Neogit branch<CR>", { exit = true, nowait = true, desc = "Branch" } },

        J = {
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gitsigns.next_hunk()
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
                    gitsigns.prev_hunk()
                end)
                return "<Ignore>"
            end,
            { expr = true, desc = "prev hunk" },
        },
        s = { gitsigns.stage_hunk, { exit = false, desc = "Stage Hunk" } },
        S = { gitsigns.stage_buffer, { exit = false, desc = "Stage Buffer" } },

        p = { gitsigns.preview_hunk, { desc = "Preview Hunk" } },
        u = { gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" } },
        x = { gitsigns.toggle_deleted, { nowait = true, desc = "Toggle Deleted" } },
        D = { gitsigns.diffthis, { desc = "Diff This" } },

        r = { gitsigns.reset_hunk, { desc = "Reset Hunk" } },
        R = { gitsigns.reset_buffer, { desc = "Reset Buffer" } },

        q = { wrap(gitsigns.setqflist, "all"), { desc = "Quickfix List All" } },
        Q = { wrap(gitsigns.setqflist), { desc = "Quickfix List" } },
        B = {
            function()
                gitsigns.blame_line({ full = true })
            end,
            { exit = true, desc = "blame_line" },
        },
        ["/"] = { gitsigns.show, { exit = true, desc = "Show" } },
        b = { gitsigns.blame_line, { desc = "Blame Line" } },
        M = { diffmaster, { silent = true, exit = true, desc = "DiffMaster" } },
        d = { ":DiffviewOpen<CR>", { silent = true, exit = true, desc = "DiffView" } },
        C = { ":GitConflictListQf<CR>", { exit = true, nowait = true, desc = "Conflict" } },
    },
}
local bracket = { "<cr>", "J", "K", "s", "S" }

local binds = {
    { "l", "m", "H" },
    { "r", "R", "x", "u" },
    { "D", "p", "b", "B", "q", "Q" },
    { "d", "M", "C", "/" },
}
return {
    config,
    "Git",
    binds,
    bracket,
    6,
    3,
}
