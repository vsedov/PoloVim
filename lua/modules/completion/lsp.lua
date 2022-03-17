local lspconfig = require("lspconfig")
-- local configs = require("lspconfig/configs")
-- local global = require("core.global")
-- local lsp = require("vim.lsp")
-- local fn = vim.fn
-- local api = vim.api

local util = require("utils.helper")

if not packer_plugins["telescope.nvim"].loaded then
    vim.cmd([[packadd telescope.nvim]])
end
if not packer_plugins["nvim-lsp-installer"].loaded then
    vim.cmd([[packadd nvim-lsp-installer]])
end

local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local border = {
    -- { "╔", "FloatBorder" },
    -- { "═", "FloatBorder" },
    -- { "╗", "FloatBorder" },
    -- { "║", "FloatBorder" },
    -- { "╝", "FloatBorder" },
    -- { "═", "FloatBorder" },
    -- { "╚", "FloatBorder" },
    -- { "║", "FloatBorder" },

    { "🭽", "FloatBorder" },
    { "▔", "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕", "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁", "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏", "FloatBorder" },

    --   { "┏", "FloatBorder" },
    --   { "━", "FloatBorder" },
    --   { "┓", "FloatBorder" },
    --   { "┃", "FloatBorder" },
    --   { "┛", "FloatBorder" },
    --   { "━", "FloatBorder" },
    --   { "┗", "FloatBorder" },
    --   { "┃", "FloatBorder" },
    --
    --   {  "▛","FloatBorder"},
    --   {  "▀","FloatBorder"},
    --   {  "▜","FloatBorder"},
    --   {  "▐","FloatBorder"},
    --   {  "▟","FloatBorder"},
    --   {  "▄","FloatBorder"},
    --   {  "▙","FloatBorder"},
    --   {  "▌","FloatBorder"},

    --   { "╭", "FloatBorder" },
    --   { "─", "FloatBorder" },
    --   { "╮", "FloatBorder" },
    --   { "│", "FloatBorder" },
    --   { "╯", "FloatBorder" },
    --   { "─", "FloatBorder" },
    --   { "╰", "FloatBorder" },
    --   { "│", "FloatBorder" },
}

local codes = {
    no_matching_function = {
        message = " Can't find a matching function",
        "redundant-parameter",
        "ovl_no_viable_function_in_call",
    },
    empty_block = {
        message = " That shouldn't be empty here",
        "empty-block",
    },
    missing_symbol = {
        message = " Here should be a symbol",
        "miss-symbol",
    },
    expected_semi_colon = {
        message = " Remember the `;` or `,`",
        "expected_semi_declaration",
        "miss-sep-in-table",
        "invalid_token_after_toplevel_declarator",
    },
    redefinition = {
        message = " That variable was defined before",
        "redefinition",
        "redefined-local",
    },
    no_matching_variable = {
        message = " Can't find that variable",
        "undefined-global",
        "reportUndefinedVariable",
    },
    trailing_whitespace = {
        message = " Remove trailing whitespace",
        "trailing-whitespace",
        "trailing-space",
    },
    unused_variable = {
        message = " Don't define variables you don't use",
        "unused-local",
    },
    unused_function = {
        message = " Don't define functions you don't use",
        "unused-function",
    },
    useless_symbols = {
        message = " Remove that useless symbols",
        "unknown-symbol",
    },
    wrong_type = {
        message = " Try to use the correct types",
        "init_conversion_failed",
    },
    undeclared_variable = {
        message = " Have you delcared that variable somewhere?",
        "undeclared_var_use",
    },
    lowercase_global = {
        message = " Should that be a global? (if so make it uppercase)",
        "lowercase-global",
    },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
})
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.diagnostic.config({
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = {
        focusable = false,
        scope = "cursor",
        format = function(diagnostic)
            local diag = vim.deepcopy(diagnostic)
            print("diagnostic:")
            dump(diagnostic)

            if not util.isempty(diagnostic.user_data) then
                local code = diagnostic.user_data.lsp.code

                for _, table in pairs(codes) do
                    if vim.tbl_contains(table, code) then
                        return table.message
                    end
                end
            end

            if diagnostic.code then
                diag.message = string.format("%s [%s]", diag.message, diag.code):gsub("1. ", "")
            end

            return diag.message
        end,

        header = " Diagnostic",
        pos = 1,
        prefix = function(diagnostic, i, total)
            local icon, highlight
            if diagnostic.severity == 1 then
                icon = ""
                highlight = "DiagnosticError"
            elseif diagnostic.severity == 2 then
                icon = ""
                highlight = "DiagnosticWarn"
            elseif diagnostic.severity == 3 then
                icon = ""
                highlight = "DiagnosticInfo"
            elseif diagnostic.severity == 4 then
                icon = ""
                highlight = "DiagnosticHint"
            end
            return i .. "/" .. total .. " " .. icon .. "  ", highlight
        end,
    },
})

-- -- -- wrap open_float to inspect diagnostics and use the severity color for border
-- -- -- https://neovim.discourse.group/t/lsp-diagnostics-how-and-where-to-retrieve-severity-level-to-customise-border-color/1679
vim.diagnostic.open_float = (function(orig)
    return function(bufnr, opts)
        local line_number = vim.api.nvim_win_get_cursor(0)[1] - 1
        local opts = opts or {}

        local diagnostics = vim.diagnostic.get(opts.bufnr or 0, { lnum = line_number })
        local max_severity = vim.diagnostic.severity.HINT
        for _, d in ipairs(diagnostics) do
            if d.severity < max_severity then
                max_severity = d.severity
            end
        end
        local border_color = ({
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
        })[max_severity]
        opts.border = border
        orig(bufnr, opts)
    end
end)(vim.diagnostic.open_float)

vim.api.nvim_set_hl(0, "DiagnosticHeader", { fg = "#56b6c2", bold = true })
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
        vim.g.cursorhold_updatetime = 100
        -- vim.diagnostic.open_float()
        local current_cursor = vim.api.nvim_win_get_cursor(0)
        local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }
        -- Show the popup diagnostics window,
        -- but only once for the current cursor location (unless moved afterwards).
        if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
            vim.w.lsp_diagnostics_last_cursor = current_cursor
            vim.diagnostic.open_float()
        end
    end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.offsetEncoding = { "utf-16" }

capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}

capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

capabilities.textDocument.codeAction = {
    -- dynamicRegistration = false;
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = {
                "quickfix",
                "refactor",
                "refactor.extract",
                "refactor.inline",
                "refactor.rewrite",
                "source",
                "source.organizeImports",
            },
        },
    },
}

function _G.reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd([[edit]])
end

function _G.open_lsp_log()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
end

local function lsp_highlight_document(client, bufnr)
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            buffer = bufnr,
        })
    end
end
local tex_preview_settings = {}
local forward_search_executable = "zathura"
local sumatrapdf_args = {
    "-reuse-instance",
    "%p",
    "-forward-search",
    "%f",
    "%l",
}
local evince_args = { "-f", "%l", "%p", '"code -g %f:%l"' }
local okular_args = { "--unique", "file:%p#src:%l%f" }
local zathura_args = { "--synctex-forward", "%l:1:%f", "%p" }
local qpdfview_args = { "--unique", "%p#src:%f:%l:1" }
local skim_args = { "%l", "%p", "%f" }

if forward_search_executable == "C:/Users/{User}/AppData/Local/SumatraPDF/SumatraPDF.exe" then
    tex_preview_settings = sumatrapdf_args
elseif forward_search_executable == "evince-synctex" then
    tex_preview_settings = evince_args
elseif forward_search_executable == "okular" then
    tex_preview_settings = okular_args
elseif forward_search_executable == "zathura" then
    tex_preview_settings = zathura_args
elseif forward_search_executable == "qpdfview" then
    tex_preview_settings = qpdfview_args
elseif forward_search_executable == "/Applications/Skim.app/Contents/SharedSupport/displayline" then
    tex_preview_settings = skim_args
end

vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")
vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")

local enhance_attach = function(client, bufnr)
    -- api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- I dont want any formating on python files.
    lsp_highlight_document(client, bufnr)

    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
end

lspconfig.gopls.setup({
    filetypes = { "go" },
    cmd = { "gopls", "--remote=auto" },
    on_attach = enhance_attach,
    capabilities = capabilities,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
})

lspconfig.tsserver.setup({
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        enhance_attach(client)
    end,
})
require("clangd_extensions").setup({})
local clangd_flags = {
    "--background-index",
    "--cross-file-rename",
    "--offset-encoding=utf-16",
    "--clang-tidy-checks=clang-diagnostic-*,clang-analyzer-*,-*,bugprone*,modernize*,performance*,-modernize-pass-by-value,-modernize-use-auto,-modernize-use-using,-modernize-use-trailing-return-type",
}
-- Need to configer this for xmake soon
lspconfig.clangd.setup({
    cmd = { "clangd", unpack(clangd_flags) },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    settings = {
        texlab = {
            auxDirectory = nil,
            bibtexFormatter = "texlab",
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "%f",
                },
                on_save = false,
                forward_search_after = false,
            },
            chktex = {
                on_open_and_save = false,
                on_edit = false,
            },
            forward_search = {
                executable = nil,
                args = {},
            },
            latexindent = {
                ["local"] = nil,
                modify_line_breaks = false,
            },
            diagnostics = {
                virtual_text = { spacing = 0, prefix = "" },
                signs = true,
                underline = true,
            },
            linters = { "chktex" },
            auto_save = false,
            ignore_errors = {},
            diagnosticsDelay = 300,
            formatterLineLength = 120,
            forwardSearch = {
                args = tex_preview_settings,
                executable = forward_search_executable,
            },
            latexFormatter = "latexindent",
        },
    },
    on_attach = enhance_attach,
    capabilities = capabilities,
})

lspconfig.texlab.setup({
    -- cmd = { os.getenv("HOME") .."/.local/share/nvim/lsp_servers//latex/texlab" },
    cmd = { "texlab" },
    filetypes = { "tex", "bib" },
    on_attach = enhance_attach,
    capabilities = capabilities,
})

lspconfig.jedi_language_server.setup({
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    on_attach = enhance_attach,
    capabilities = capabilities,
})

lspconfig.jsonls.setup({
    cmd = { "vscode-json-languageserver", "--stdio" },
    filetypes = { "json", "jsonc" },
    on_attach = enhance_attach,
    capabilities = capabilities,
})

lspconfig.sqls.setup({
    filetypes = { "sql", "mysql" },
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    settings = {
        sqls = {
            connections = {
                {
                    name = "sqlite3-project",
                    adapter = "sqlite3",
                    filename = "/home/viv/GitHub/TeamProject2022_28/ARMS/src/main/resources/db/DummyARMS.sqlite",
                    projectPaths = "/home/viv/GitHub/TeamProject2022_28/ARMS/",
                },
            },
        },
    },

    -- cmd = { "sql-language-server", "up", "--method", "stdio" },
    on_attach = enhance_attach,
    capabilities = capabilities,
})

-- You will have to Build a package for this .
lspconfig.rust_analyzer.setup({
    filetypes = { "rust" },
    cmd = { "rust-analyzer" },
    capabilities = capabilities,
    on_attach = enhance_attach,
})

lspconfig.vimls.setup({
    on_attach = enhance_attach,
    capabilities = capabilities,

    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
        diagnostic = {
            enable = true,
        },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
            runtimepath = true,
        },
        iskeyword = "@,48-57,_,192-255,-#",
        runtimepath = "",
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true,
        },
        vimruntime = "",
    },
})

-- local sumneko_root_path = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server"
-- local sumneko_binary = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server/bin/lua-language-server"
local runtime_path = {}
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local sumneko_lua_server = {
    -- cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    cmd = { "lua-language-server" },
    on_attach = enhance_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                runtime = {
                    path = runtime_path,
                    version = "LuaJIT",
                },
                diagnostics = {
                    enable = true,
                    globals = { "vim", "dump", "hs", "lvim" },
                },
                workspace = {
                    -- remove all of this, as it slows things down
                    library = {
                        vim.api.nvim_get_runtime_file("", false),
                        [table.concat({ vim.fn.stdpath("data"), "lua" }, "/")] = false,
                        vim.api.nvim_get_runtime_file("", false),
                        [vim.fn.expand("~") .. "/.config/nvim/lua"] = false,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = false,
                        [vim.fn.expand("$VIMRUNTIME/lua")] = false,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
            },
        },
    },
}

local luadev = require("lua-dev").setup({
    library = {
        vimruntime = true,
        types = true,
        -- makes everything lag
        plugins = false, -- toggle this to get completion for require of all plugins
        plugins = { "nvim-notify", "plenary.nvim" },
    },
    lspconfig = sumneko_lua_server,
})

lspconfig.sumneko_lua.setup(luadev)

require("nvim-lsp-installer").settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

lsp_installer.on_server_ready(function(server)
    local opts = {}
    -- (optional) Customize the options passed to the server
    if server.name == "jdtls" then
        return
    end
    server:setup(opts)
    -- vim.cmd([[ do User LspAttachBuffers ]])
end)
