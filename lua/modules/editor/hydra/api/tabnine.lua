local leader = ";a"
local cmd = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local config = {
    Tabnine = {
        color = "red",
        mode = { "x", "n" },
        body = leader,

        ["<ESC>"] = { nil, { exit = true } },
        a = {
            function()
                require("tabnine.chat").open()
            end,
            { desc = "TN: Chat", nowait = true, silent = true, exit = true },
        },
        s = { cmd("TabnineStatus"), { desc = "TN: Status", nowait = true, silent = true, exit = true } },
        w = { cmd("TabnineHubUrl"), { desc = "TN: Hub", nowait = true, silent = true, exit = true } },
        ["<leader>"] = { cmd("TabnineToggle"), { desc = "TN: Toggle", nowait = true, silent = true } },
    },
}
return {
    config,
    "Tabnine",
    { { "<leader>" } },
    { "a", "s", "w" },
    6,
    3,
}
