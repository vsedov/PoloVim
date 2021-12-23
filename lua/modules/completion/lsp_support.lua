local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local cmd = vim.api.nvim_command

local M = {}

local are_diagnostics_visible = true
---Toggle vim.diagnostics (visibility only).
---@return nil
M.toggle_diagnostics_visibility = function()
    if are_diagnostics_visible then
        vim.diagnostic.hide()
        are_diagnostics_visible = false
    else
        vim.diagnostic.show()
        are_diagnostics_visible = true
    end
end


local function __peek_definitin_callback(_, result)
    if result == nil or vim.tbl_isempty(result) then
        return nil
    end

    lsp.util.preview_location(result[1])
end

function M.peek_definition()
    return vim.lsp.buf_request(
        0,
        'textDocument/definition',
        lsp.util.make_position_params(),
        __peek_definitin_callback
    )
end

return M



