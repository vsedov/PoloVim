local utils = require("modules.editor.hydra.repl_utils")
local run_cmd_with_count = utils.run_cmd_with_count
local ft_to_repl = utils.ft_to_repl

require("hydra")({
    name = "REPL",
    body = ";<leader>",

    mode = "n",
    config = {
        color = "amaranth",
        invoke_on_body = true,
        hint = {
            -- border = lambda.style.border.type_0,
            position = "bottom-right",
        },
    },
    -- body = main_leader,
    hint = [[
REPL commands:
^ ^ _S_: Start an REPL  ^ ^
^ ^ _f_: Focus on REPL  ^ ^
^ ^ _v_: View REPLs in telescope ^ ^
^ ^ _h_: Hide REPL     ^ ^
^ ^ _s_: Send current line to REPL ^ ^
^ ^ _l_: Send line to REPL ^ ^
^ ^ _q_: Quit REPL     ^ ^
^ ^ _c_: Clear REPLs   ^ ^
^ ^ _w_: Swap REPLs    ^ ^
^ ^ _?_: Start an REPL from available REPL metas ^ ^
^ ^ _a_: Attach current buffer to a REPL  ^ ^
^ ^ _d_: Detach current buffer to any REPL ^ ^
^ ^ _<esc>_: Quit     ^ ^
]],

    heads = {
        {
            "S",
            function()
                run_cmd_with_count("REPLStart " .. ft_to_repl[vim.bo.filetype])()
            end,
            { exit = true, desc = "Start an REPL" },
        },
        {
            "f",
            run_cmd_with_count("REPLFocus"),
            { exit = true, desc = "Focus on REPL" },
        },
        {
            "v",
            "<CMD>Telescope REPLShow<CR>",
            { exit = true, desc = "View REPLs in telescope" },
        },
        {
            "h",
            run_cmd_with_count("REPLHide"),
            { exit = true, desc = "Hide REPL" },
        },
        {
            "s",
            run_cmd_with_count(" REPLSendOperator"),
            { exit = true, desc = "Send current line to REPL" },
        },
        {
            "l",
            run_cmd_with_count("REPLSendLine"),
            { exit = true, desc = "Send line to REPL" },
        },
        {
            "q",
            run_cmd_with_count("REPLClose"),
            { exit = true, desc = "Quit REPL" },
        },
        { "c", "<CMD>REPLCleanup<CR>", { exit = true, desc = "Clear REPLs" } },
        { "w", "<CMD>REPLSwap<CR>", { exit = true, desc = "Swap REPLs" } },
        {
            "?",
            run_cmd_with_count("REPLStart"),
            { exit = true, desc = "Start an REPL from available REPL metas" },
        },
        {
            "a",
            "<CMD>REPLAttachBufferToREPL<CR>",
            { exit = true, desc = "Attach current buffer to a REPL" },
        },
        {
            "d",
            "<CMD>REPLDetachBufferToREPL<CR>",
            { exit = true, desc = "Detach current buffer to any REPL" },
        },
        {
            "<esc>",
            nil,
            { exit = true, desc = "quit" },
        },
    },
})
vim.keymap.set("n", ";;r", utils.send_a_code_chunk, {
    desc = "send a code chunk",
    expr = true,
    buffer = 0,
})
