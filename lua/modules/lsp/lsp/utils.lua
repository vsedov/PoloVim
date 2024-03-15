-- https://github.com/IndianBoy42/dot.nvim/blob/main/lua/utils/lsp.lua
local M = {}
local api = vim.api
local cmd = vim.cmd
local vfn = vim.fn
local lsp = vim.lsp
-- local diags = lsp.diagnostic
local diags = vim.diagnostic
-- TODO: reduce nested lookups for performance (\w+\.)?(\w+\.)?\w+\.\w+\(

local getmark = api.nvim_buf_get_mark
local feedkeys = api.nvim_feedkeys
local termcodes = vim.api.nvim_replace_termcodes
local function t(k)
    return termcodes(k, true, true, true)
end

-- Format a range using LSP
function M.format_range_operator()
    local old_func = vim.go.operatorfunc
    _G.op_func_formatting = function()
        local start = getmark(0, "[")
        local finish = getmark(0, "]")
        lsp.buf.format({
            range = { start = start, ["end"] = finish },
        })
        vim.go.operatorfunc = old_func
        _G.op_func_formatting = nil
    end
    vim.go.operatorfunc = "v:lua.op_func_formatting"
    feedkeys("g@", "n", false)
end

-- TODO: Figure out the easiest way to implement this
function M.range_diagnostics(opts, buf_nr, start, finish)
    start = start or getmark(0, "[")
    finish = finish or getmark(0, "]")

    vim.notify("Unimplemented", vim.log.levels.ERROR)
end

-- Preview definitions and things
-- TODO: most buf_request could probably just use vim.lsp.buf + on_list_handler
local function preview_location_callback(_, result)
    if result == nil or vim.tbl_isempty(result) then
        return nil
    end
    lsp.util.preview_location(result[1], {
        border = "rounded",
    })
end

function M.preview_location_at(name)
    return function()
        local params = lsp.util.make_position_params()
        return lsp.buf_request(0, "textDocument/" .. name, params, preview_location_callback)
    end
end

function M.view_location_split_callback(split_cmd)
    local util = vim.lsp.util
    local log = require("vim.lsp.log")

    -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
    local function handler(_, result, ctx)
        if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
        end
        local oe = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

        if split_cmd then
            cmd(split_cmd)
        end

        if vim.tbl_islist(result) then
            util.jump_to_location(result[1], oe)

            if #result > 1 then
                util.set_qflist(util.locations_to_items(result))
                api.nvim_command("copen")
                api.nvim_command("wincmd p")
            end
        else
            util.jump_to_location(result, oe)
        end
    end

    return handler
end

function M.view_location_split(name, split_cmd)
    local cb = M.view_location_split_callback(split_cmd)
    return function()
        local params = lsp.util.make_position_params()
        params.context = {
            includeDeclaration = true,
        }
        return lsp.buf_request(0, "textDocument/" .. name, params, cb)
    end
end

function M.view_location_pick(name)
    local cb = M.view_location_pick_callback(name)
    return function()
        local params = lsp.util.make_position_params()
        params.context = {
            includeDeclaration = true,
        }
        return lsp.buf_request(0, "textDocument/" .. name, params, cb)
    end
end

function M.toggle_diagnostics(b)
    if vim.diagnostic.is_disabled(b) then
        diags.enable(b or 0)
    else
        diags.disable(b or 0)
    end
end
function M.disable_diagnostic(b)
    diags.disable(b or 0)
end
function M.enable_diagnostic(b)
    diags.enable(b or 0)
end

function M.toggle_diag_lines(enable)
    if enable == nil then
        enable = not vim.diagnostic.config().virtual_lines
    end
    if enable then
        vim.diagnostic.config({
            virtual_lines = require("langs").diagnostic_config_all.virtual_lines,
            virtual_text = false,
        })
    else
        vim.diagnostic.config({
            virtual_lines = false,
            virtual_text = require("langs").diagnostic_config_all.virtual_text,
        })
    end
end

-- TODO: Implement codeLens handlers
function M.show_codelens()
    -- cmd [[ autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh() ]]
    -- cmd(
    --   [[
    --   augroup lsp_codelens_refresh
    --     autocmd! * <buffer>
    --     autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
    --   augroup END
    --   ]],
    --   false
    -- )

    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local codelens = lsp.codelens
    for k, v in pairs(clients) do
        codelens.display(nil, 0, k)
    end
end

function M.run_any_codelens(select)
    local codelens = lsp.codelens.get(0)
    select = select or vim.ui.select
    select(codelens, {
        prompt = "CodeLens actions:",
        format_item = function(item)
            local title = item.command.title .. ": "
            if item.command.arguments[1] then
                title = title .. item.command.arguments[1].kind .. " " .. item.command.arguments[1].label
            end

            return title
        end,
    }, function(selected)
        if not selected then
            return
        end

        local cursor = vim.api.nvim_win_get_cursor(0)
        local start = selected.range.start
        vim.api.nvim_win_set_cursor(0, { start.line + 1, start.character })
        vim.lsp.codelens.run()
        vim.api.nvim_win_set_cursor(0, cursor)
    end)
end

-- Jump between diagnostics
-- TODO: clean up and remove the deprecate functions
function M.diag_line(opts)
    diags.open_float(vim.tbl_deep_extend("keep", opts or {}, { scope = "line" }))
end
function M.diag_cursor(opts)
    diags.open_float(vim.tbl_deep_extend("keep", opts or {}, { scope = "cursor" }))
end
function M.diag_buffer(opts)
    diags.open_float(vim.tbl_deep_extend("keep", opts or {}, { scope = "buffer" }))
end

function M.hover(handler)
    if type(handler) == "table" then
        local config = handler
        handler = function(err, result, ctx)
            vim.lsp.handlers.hover(err, result, ctx, config)
        end
    end
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/hover", params, handler)
end
function M.auto_hover()
    local auto_hover = vim.api.nvim_create_augroup("auto_hover", {})
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = auto_hover,
        callback = function()
            if vim.b.cursor_hold_hover then
                return
            end
            M.hover({
                focusable = false,
                border = "single",
            })
            vim.b.cursor_hold_hover = true
        end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = auto_hover,
        callback = function()
            vim.b.cursor_hold_hover = false
        end,
    })
end
local hover_hydra
-- Easily repeatable hover
function M.repeatable_hover(hover, k)
    hover = hover or vim.lsp.buf.hover
    if false then
        k = k or "h"
        if not hover_hydra then
            hover_hydra = require("hydra")({
                mode = { "n", "x" },
                hint = false,
                body = nil,
                heads = {
                    { "h", hover, { desc = "LSP Hover" } },
                    {
                        "<esc>",
                        function()
                            hover() -- TODO: how to do this better?
                            vim.api.nvim_win_close(0, true)
                        end,
                        { desc = "Close", exit = true, private = true },
                    },
                },
            })
        end
        return function()
            hover()
            hover_hydra:activate()
        end
    else
        hover()
    end
end

function M.get_highest_diag(ns, bufnr)
    local diag_list = vim.diagnostic.get(bufnr, { namespace = ns })
    local highest = vim.diagnostic.severity.HINT
    for _, diag in ipairs(diag_list) do
        local sev = diag.severity
        if sev < highest then
            highest = sev
        end
    end
    -- return highest
end
function M.diag_next(opts)
    diags.goto_next(vim.tbl_extend("keep", opts or {}, {
        enable_popup = true,
        severity = M.get_highest_diag(),
    }))
end
function M.diag_prev(opts)
    diags.goto_prev(vim.tbl_extend("keep", opts or {}, {
        enable_popup = true,
        severity = M.get_highest_diag(),
    }))
end

function M.error_next()
    M.diag_next({ severity = vim.diagnostic.severity.ERROR })
end
function M.error_prev()
    M.diag_prev({ severity = vim.diagnostic.severity.ERROR })
end

function M.format(opts)
    opts = opts or { async = true }
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.lsp.buf.format(vim.tbl_extend("force", {

        bufnr = buf,
        group = augroup,
        filter = function(client)
            if have_nls then
                return client.name == "null-ls"
            end
            return client.name ~= "null-ls"
        end,
    }, opts))
end

M.format_on_save = function(m)
    vim.g.Format_on_save_mode = m
    -- TODO: only if client has formatting
    local id = vim.api.nvim_create_augroup("format_on_save", { clear = true })

    local cb = function()
        local mode = vim.b.Format_on_save_mode
        if mode == nil then
            mode = vim.g.Format_on_save_mode
        end
        if type(mode) == "string" and mode:sub(1, 3) == "mod" then
            cmd("FormatModifications")
        elseif mode == true or mode == "all" then
            local ok, _ = pcall(M.format, { timeout_ms = 1000 })
            if not ok then
                vim.notify("Error running format on save", vim.log.levels.ERROR)
                vim.b.Format_on_save_mode = false
            end
        end
    end
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = cb,
        group = id,
    })
end

M.format_on_save_toggle = function(dict)
    dict = dict or vim.b
    return function()
        if not dict.Format_on_save_mode then
            dict.Format_on_save_mode = dict.Format_on_save_mode_last
        else
            dict.Format_on_save_mode_last = dict.Format_on_save_mode
            dict.Format_on_save_mode = false
        end
    end
end

-- vim.lsp.buf.cancel_formatting = function(bufnr)
--     vim.schedule(function()
--         bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
--         for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
--             for id, request in pairs(client.requests or {}) do
--                 if
--                     request.type == "pending"
--                     and request.bufnr == bufnr
--                     and request.method == "textDocument/formatting"
--                 then
--                     client.cancel_request(id)
--                 end
--             end
--         end
--     end)
-- end

M.on_attach = function(on_attach, group)
    if type(group) == "string" then
        group = vim.api.nvim_create_augroup(group, { clear = true })
    end
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

M.document_highlight = function(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        local id = vim.api.nvim_create_augroup("document_highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = id,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            buffer = bufnr,
            group = id,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end
end

M.inlay_hints = vim.lsp.inlay_hint or vim.lsp.buf.inlay_hint or function(...) end

return M
