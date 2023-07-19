-- https://github.com/IndianBoy42/dot.nvim/blob/main/lua/utils/lsp.lua
local M = {}
local api = vim.api
local cmd = vim.cmd
local vfn = vim.fn
local lsp = vim.lsp
local diags = vim.diagnostic
-- TODO: reduce nested lookups for performance (\w+\.)?(\w+\.)?\w+\.\w+\(

local getmark = api.nvim_buf_get_mark
local feedkeys = api.nvim_feedkeys
local termcodes = vim.api.nvim_replace_termcodes

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

local hover_hydra
-- Easily repeatable hover
function M.repeatable_hover(hover, k)
    local hover_type = function()
        if not lambda.config.lsp.use_hover and not lambda.config.lsp.use_navigator then
            vim.cmd([[Lspsaga hover_doc]])
        else
            require("hover").hover()
        end
    end
    hover = hover or hover_type
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
function M.hover(handler)
    if type(handler) == "table" then
        local config = handler
        handler = function(err, result, ctx)
            vim.lsp.handlers.hover(err, result, ctx, config)
            -- require("hover").hover()
        end
    end
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/hover", params, handler)
end
return M
