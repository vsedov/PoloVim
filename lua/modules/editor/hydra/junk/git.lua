local Hydra = require("hydra")
local gitrepo = vim.fn.isdirectory(".git/index")
local cmd = require("hydra.keymap-util").cmd

local function wrap(fn, ...)
    local args = { ... }
    local nargs = select("#", ...)
    return function()
        fn(unpack(args, nargs))
    end
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(tostring(str), true, true, true)
end

local function diffmaster()
    local branch = "origin/master"
    local master = vim.fn.systemlist("git rev-parse --verify develop")
    if not master[1]:find("^fatal") then
        branch = "origin/master"
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

if gitrepo then
    require("lazy").load({ plugins = { "gitsigns.nvim", "vim-fugitive" } })

    local hint = [[
━━━━━━━━━━━━━━━━━━━━━
_<CR>_:Neogit
_J_: next hunk
_K_: prev hunk
━━━━━━━━━━━━━━━━━━━━━
_D_: diffthis
_p_: Preview H
_s_: stagehunk
_S_: stage buf
━━━━━━━━━━━━━━━━━━━━━
_r_: reset hunk
_R_: Reset Buffer
_x_: show del
_u_: ustage hunk
_b_: gutterView
_B_: BlameLine
━━━━━━━━━━━━━━━━━━━━━
_q_: Setqflist all
_Q_: Stqflist
━━━━━━━━━━━━━━━━━━━━━
_d_: diftree
_M_: difmast
_C_: conflict
_m_: merge
_H_: filehist
_l_: log
━━━━━━━━━━━━━━━━━━━━━
_/_ : show base
]]

    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        Hydra({
            name = "Git Mode",
            hint = hint,
            config = {
                color = "pink",
                invoke_on_body = true,
                hint = {
                    position = "middle-right",
                    border = "single",
                },
                on_enter = function()
                    vim.bo.modifiable = false
                    gitsigns.toggle_linehl(true)
                    gitsigns.toggle_deleted(true)
                end,
                on_exit = function()
                    gitsigns.toggle_linehl(false)
                    gitsigns.toggle_deleted(false)
                    vim.cmd("echo") -- clear the echo area
                end,
            },
            mode = { "n", "x", "v" },
            body = "<leader>h",
            heads = {
                {
                    "J",
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
                {
                    "K",
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

                { "s", ":Gitsigns stage_hunk<cr>", { exit = false, nowait = true } },

                { "u", gitsigns.undo_stage_hunk },
                { "S", gitsigns.stage_buffer },

                { "p", gitsigns.preview_hunk },
                { "x", gitsigns.toggle_deleted, { nowait = true } },
                { "r", gitsigns.reset_hunk },
                { "D", gitsigns.diffthis },
                { "R", ":Gitsigns reset_buffer<CR>", { silent = true } },

                { "q", wrap(gitsigns.setqflist, "all") },
                { "Q", wrap(gitsigns.setqflist) },
                {
                    "B",
                    function()
                        gitsigns.blame_line({ full = true })
                    end,
                    { desc = "blame_line" },
                },
                { "/", gitsigns.show, { exit = true } }, -- show the base of the file
                { "b", gitsigns.blame_line },

                { "d", ":DiffviewOpen<CR>", { silent = true, exit = true } },
                { "M", diffmaster, { silent = true, exit = true } },
                { "H", ":DiffviewFileHistory<CR>", { silent = true, exit = true } },

                { "<CR>", ":silent lua lambda.clever_tcd()<cr>:Neogit<cr>", { exit = true } },
                { "l", ":Neogit log<CR>", { exit = true, nowait = true } },
                { "m", ":Neogit merge<CR>", { exit = true, nowait = true } },
                { "C", ":GitConflictListQf<CR>" },
                { "<Esc>", nil, { exit = true, desc = false } },
            },
        })
    end
end
