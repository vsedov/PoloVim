local Hydra = require("hydra")

local function cmd(command)
    return table.concat({ "<Cmd>", command, "<CR>" })
end

local function vcmd(command)
    return table.concat({ [[<Esc><Cmd>]], command, [[<CR>]] })
end

local hint_visual = [[
_n_: Rename
_b_: Extract block
_e_: Extract function
_p_: Print var
_i_: Inline
_B_: ...to file
_f_: ...to file
_v_: Extract
_r_: Select refactor
_<Esc>_
]]
local hint_normal = [[
_n_: Rename
_b_: Extract block
_p_: Print var
_i_: Inline
_B_:   ... to file
_c_: Clear up
_q_: Format
_r_: Select refactor
_<Esc>_
]]

-- Normal Mode Version
Hydra({
    name = "Refactor",
    hint = hint_normal,
    config = {
        color = "blue",
        invoke_on_body = true,
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
    },
    mode = { "n" },
    body = "<leader>r",
    heads = {
        { "<Esc>", nil, { exit = true, nowait = true } },
        { "r", require("refactoring").select_refactor, { desc = "Select refactor" } },
        { "n", vim.lsp.buf.rename, { desc = "Rename" } },
        { "q", vim.lsp.buf.formatting, { desc = "Format buffer" } },
        {
            "i",
            cmd([[lua require('refactoring').refactor('Inline Variable')]]),
            { desc = "Inline variable" },
        },
        {
            "b",
            cmd([[lua require('refactoring').refactor('Extract Block')]]),
            { desc = "Extract block" },
        },
        {
            "B",
            cmd([[lua require('refactoring').refactor('Extract Block To File')]]),
            { desc = "Extract block to file" },
        },
        {
            "p",
            cmd("lua require('refactoring').debug.print_var({ normal = true })"),
            { desc = "Debug print" },
        },
        {
            "c",
            cmd("lua require('refactoring').debug.cleanup({})"),
            { desc = "Debug print cleanup" },
        },
    },
})
-- Visual Mode Version
Hydra({
    name = "Refactor",
    hint = hint_visual,
    config = {
        color = "teal",
        invoke_on_body = true,
        hint = {
            position = "bottom",
            border = "rounded",
        },
    },
    mode = { "v" },
    body = "<leader>R",
    heads = {
        { "<Esc>", nil, { exit = true, nowait = true } },
        { "r", require("refactoring").select_refactor, { desc = "Select refactor" } },
        { "n", vim.lsp.buf.rename, { desc = "Rename" } },
        {
            "i",
            cmd([[ lua require('refactoring').refactor('Inline Variable') ]]),
            { desc = "Inline variable" },
        },
        {
            "b",
            cmd([[ lua require('refactoring').refactor('Extract Block')]]),
            { desc = "Extract block" },
        },
        {
            "B",
            cmd([[ lua require('refactoring').refactor('Extract Block To File')]]),
            { desc = "Extract block to file" },
        },
        {
            "v",
            cmd("lua require('refactoring').debug.print_var({ normal = true })"),
            { desc = "Debug print" },
        },
        -- Visual Mode Only
        {
            "e",
            vcmd([[lua require('refactoring').refactor('Extract Function')]]),
            { desc = "Extract function" },
        },
        {
            "f",
            vcmd([[lua require('refactoring').refactor('Extract Function To File')]]),
            { desc = "Extract function to file" },
        },
        {
            "v",
            vcmd([[lua require('refactoring').refactor('Extract Variable')]]),
            { desc = "Extract variable" },
        },
        -- Debugging Prints
        {
            "p",
            cmd("lua require('refactoring').debug.print_var({})"),
            { desc = "Debug print cleanup" },
        },
    },
})
