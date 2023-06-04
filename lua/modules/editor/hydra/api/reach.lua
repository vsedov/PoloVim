-- https://github.com/Reisen/vimless/blob/master/lua/plugins/hydra.lua
local cmd = vim.cmd
local leader = ";;"

local reach_options = {
    handle = "dynamic",
    show_current = true,
    sort = function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end,
}

-- Function to swap to the last buffer for this window.
local function swap_to_last_buffer()
    local last_buffer = vim.fn.bufnr("#")
    if last_buffer ~= -1 then
        vim.cmd("buffer " .. last_buffer)
    end
end

local bracket = { ";", "<cr>", "l", "m", "c" }

local config = {
    Reach = {
        color = "red",
        body = leader,
        mode = { "n", "v" },
        ["<ESC>"] = { nil, { exit = true } },

        [";"] = {
            function()
                require("reach").buffers(reach_options)
            end,
            { nowait = true, exit = true, desc = "Reach Buffers" },
        },
        m = {
            function()
                cmd("ReachOpen marks")
            end,
            { nowait = true, exit = true, desc = "Reach Marks" },
        },
        ["<cr>"] = {
            function()
                cmd("ReachOpen tabpages")
            end,
            { nowait = true, exit = true, desc = "Reach TabPage" },
        },
        c = {
            function()
                cmd("ReachOpen colorschemes")
            end,
            { nowait = true, exit = true, desc = "Reach Colour" },
        },
        l = {
            function()
                swap_to_last_buffer()
            end,
            { nowait = true, exit = true, desc = "Swap Last Buffer" },
        },

        w = {
            function()
                cmd("WorkspacesOpen")
            end,
            { nowait = true, exit = true, desc = "Workspace Open" },
        },
        a = {
            function()
                lambda.clever_tcd()
                cmd("WorkspacesAdd")
            end,
            { nowait = true, exit = true, desc = "Workspace Add" },
        },
        d = {
            function()
                lambda.clever_tcd()
                cmd("WorkspacesRemove")
            end,
            { nowait = true, exit = true, desc = "Workspace Remove" },
        },
        r = {
            function()
                lambda.clever_tcd()
                cmd("WorkspacesRename")
            end,
            { nowait = true, exit = true, desc = "Workspace Rename" },
        },
        n = {
            function()
                cmd("CybuNext")
            end,
            { nowait = true, exit = false, desc = "CybuNext" },
        },
        N = {
            function()
                cmd("CybuPrev")
            end,
            { nowait = true, exit = false, desc = "CybuPrev" },
        },
        ["]"] = {
            function()
                cmd("CybuLastusedPrev")
            end,
            { nowait = true, exit = false, desc = "CybuLastusedPrev" },
        },
        ["["] = {
            function()
                cmd("CybuLastusedNext")
            end,
            { nowait = true, exit = false, desc = "CybuLastusedNext" },
        },
    },
}
return {
    config,
    "Reach",
    { { "w", "a", "d", "r" }, { "n", "N", "[", "]" } },
    bracket,
    6,
    3,
}
