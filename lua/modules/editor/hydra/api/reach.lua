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

local bracket = { "<cr>", "l", "m", "c" }

local config = {
    Reach = {
        color = "red",
        body = leader,
        mode = { "n", "v" },
        ["<ESC>"] = { nil, { exit = true } },
        on_enter = function()
            require("reach").buffers(reach_options)
        end,
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
        k = {
            function()
                cmd("CybuLastusedPrev")
            end,
            { nowait = true, exit = false, desc = "CybuLastusedPrev" },
        },
        j = {
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
    { { "n", "N", "j", "k" } },
    bracket,
    6,
    3,
}
