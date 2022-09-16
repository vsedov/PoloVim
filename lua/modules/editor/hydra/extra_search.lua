local Hydra = require("hydra")
local match = lambda.lib.match
local when = lambda.lib.when
local loader = require("packer").loader
local cmd = require("hydra.keymap-util").cmd

local function azy_hydra()
    hint = [[
^^^^                  AzySearch                 ^^^^
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_f_: Files               _b_: Buffers
_F_: File-Content        _h_: Help
_q_: QuickFix
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
]]

    Hydra({
        name = "AzySearch",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "bottom-right",
                border = lambda.style.border.type_0,
            },
        },
        mode = { "n" },
        body = "<leader>az",
        heads = {
            { "f", require("azy.builtins").files(), {} },
            { "F", require("azy.builtins").files_contents(), { exit = true } },
            { "h", require("azy.builtins").help(), { exit = true } },
            { "b", require("azy.builtins").buffers(), { exit = true } },
            { "q", require("azy.builtins").quickfix(), { exit = true } },
            --[[ { "r", require("azy.builtins").lsp.references, { exit = true } }, ]]
            --[[ { "w", require("azy.builtins.lsp").references(), { exit = true } }, ]]
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
end
--  TODO: (vsedov) (23:50:57 - 16/09/22): Create hydras for fzy and command_t,
--  Ive been lazy and havent been bothered with it.
local function fzy_hydra() end

local function command_t_hydra()
    hint = [[
^^^^                  Command_T                 ^^^^
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
_f_: FindFile         _b_: Buffers
_g_: Git              _r_: RG
_<Enter>_: CommandT
^^^^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^^^^
]]
    loader("command-t")
    Hydra({
        name = "Command_T",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "bottom-right",
                border = lambda.style.border.type_0,
            },
        },
        mode = { "n" },
        body = "<leader>C",
        heads = {
            { "<Enter>", cmd("CommandT"), { exit = false } },
            { "f", cmd("CommandTFind"), { exit = false } },
            { "r", cmd("CommandTRipgrep"), { exit = false } },
            { "g", cmd("CommandTGit"), { exit = false } },
            { "b", cmd("CommandTBuffer"), { exit = false } },
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
end

when(lambda.config.extra_search.enable, function()
    for name, enable in pairs(lambda.config.extra_search.providers) do
        if enable == true then
            match(name)({
                use_azy = azy_hydra(),
                use_fzf_lua = fzy_hydra(),
                use_command_t = command_t_hydra(),
            })
        end
    end
end, function() end)
