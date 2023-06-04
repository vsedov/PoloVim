local leader = "<leader>c"
local utils = require("modules.editor.hydra.repl_utils")
local run_cmd_with_count = utils.run_cmd_with_count

local config = {
    Repl = {
        body = leader,
        mode = { "n", "v" },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
        S = {
            run_cmd_with_count("REPLStart aichat"),
            { nowait = true, desc = "Start an Aichat REPL", exit = true },
        },
        f = {
            run_cmd_with_count("REPLFocus aichat"),
            { nowait = true, desc = "Focus on Aichat REPL", exit = true },
        },
        h = {
            run_cmd_with_count("REPLHide aichat"),
            { nowait = true, desc = "Hide Aichat REPL", exit = true },
        },
        s = {
            run_cmd_with_count("REPLSendMotion aichat"),
            { nowait = true, desc = "Send current line to Aichat", exit = true },
        },
        q = {
            run_cmd_with_count("REPLClose aichat"),
            { nowait = true, desc = "Quit Aichat", exit = true },
        },
        c = {
            "<CMD>REPLCleanup<CR>",
            { nowait = true, desc = "Clear aichat REPLs.", exit = true },
        },
    },
}
return {
    config,
    "Repl",
    { { "q", "c" } },
    { "S", "s", "f", "h" },
    6,
    3,
}
