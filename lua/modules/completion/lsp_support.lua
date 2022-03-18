local lsp = vim.lsp
local lsp_conf = {}
local are_diagnostics_visible = true
---Toggle vim.diagnostics (visibility only).
---@return nil
lsp_conf.toggle_diagnostics_visibility = function()
    if are_diagnostics_visible then
        vim.diagnostic.hide()
        are_diagnostics_visible = false
    else
        vim.diagnostic.show()
        are_diagnostics_visible = true
    end
end

function lsp_conf.parse_diagnostic(diagnostic)
    return diagnostic.message
end

function lsp_conf.preview_location(location, context, before_context)
    -- location may be LocationLink or Location (more useful for the former)
    context = context or 15
    before_context = before_context or 0
    local uri = location.targetUri or location.uri
    if uri == nil then
        return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
    end

    local range = location.targetRange or location.range
    local contents = vim.api.nvim_buf_get_lines(
        bufnr,
        range.start.line - before_context,
        range["end"].line + 1 + context,
        false
    )
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    return vim.lsp.util.open_floating_preview(contents, filetype, { border = "single" })
end

function lsp_conf.preview_location_callback(_, result)
    local context = 15
    if result == nil or vim.tbl_isempty(result) then
        return nil
    end
    if vim.tbl_islist(result) then
        lsp_conf.floating_buf, lsp_conf.floating_win = lsp_conf.preview_location(result[1], context)
    else
        lsp_conf.floating_buf, lsp_conf.floating_win = lsp_conf.preview_location(result, context)
    end
end

function lsp_conf.PeekDefinition()
    if vim.tbl_contains(vim.api.nvim_list_wins(), lsp_conf.floating_win) then
        vim.api.nvim_set_current_win(lsp_conf.floating_win)
    else
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, "textDocument/definition", params, lsp_conf.preview_location_callback)
    end
end

function lsp_conf.PeekTypeDefinition()
    if vim.tbl_contains(vim.api.nvim_list_wins(), lsp_conf.floating_win) then
        vim.api.nvim_set_current_win(lsp_conf.floating_win)
    else
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, "textDocument/typeDefinition", params, lsp_conf.preview_location_callback)
    end
end

function lsp_conf.PeekImplementation()
    if vim.tbl_contains(vim.api.nvim_list_wins(), lsp_conf.floating_win) then
        vim.api.nvim_set_current_win(lsp_conf.floating_win)
    else
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, "textDocument/implementation", params, lsp_conf.preview_location_callback)
    end
end

return lsp_conf
