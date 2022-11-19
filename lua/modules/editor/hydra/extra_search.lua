local Hydra = require("hydra")
local match = lambda.lib.match
local when = lambda.lib.when
local loader = require("packer").loader
local cmd = require("hydra.keymap-util").cmd

local function azy_hydra()
    local hint = [[
_f_: Find Files
_s_: find string
_q_: QuickFix
_h_: Help
_b_: Buffers

_w_: WorkspaceSymbols
_r_: references
_d_: DocumentSymbol
_<Esc>_ exit
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
        body = ";A",
        heads = {
            { "b", require("azy.builtins").buffers(), { exit = false } },

            { "f", require("azy.builtins").files(), { exit = true, silent = true } },
            { "s", require("azy.builtins").files_contents(), { exit = true } },
            { "h", require("azy.builtins").help(), { exit = true } },
            { "q", require("azy.builtins").quickfix(), { exit = true } },
            { "w", require("azy.builtins").lsp.workspace_symbols(), { exit = true } },
            { "r", require("azy.builtins").lsp.references(), { exit = true } },
            { "d", require("azy.builtins").lsp.document_symbol(), { exit = true } },
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
end
--  TODO: (vsedov) (23:50:57 - 16/09/22): Create hydras for fzy and command_t,
--  Ive been lazy and havent been bothered with it.
local function fzy_hydra() end

when(lambda.config.extra_search.enable, function()
    for name, enable in pairs(lambda.config.extra_search.providers) do
        if enable == true then
            match(name)({
                use_azy = azy_hydra(),
                use_fzf_lua = fzy_hydra(),
            })
        end
    end
end, function() end)
