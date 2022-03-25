local lspconfig = require("lspconfig")
local lsp_setup = require("modules.completion.lsp.utils")
lsp_setup.setup()

---Resolve the configuration for a server based on both common and user configuration
---@param name string
---@param user_config table [optional]
---@return table
local function enhance_attach(user_config)
    local config = lsp_setup.get_common_opts()
    if user_config then
        config = vim.tbl_deep_extend("force", config, user_config)
    end
    return config
end

lspconfig.jedi_language_server.setup(enhance_attach({
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
}))

lspconfig.gopls.setup(enhance_attach({
    filetypes = { "go" },
    cmd = { "gopls", "--remote=auto" },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
}))

lspconfig.tsserver.setup(enhance_attach())

local clangd_defaults = require("lspconfig.server_configurations.clangd")
local clangd_configs = vim.tbl_deep_extend(
    "force",
    clangd_defaults["default_config"],
    enhance_attach({
        cmd = {
            "clangd",
            "-j=16",
            "--background-index",
            "--clang-tidy",
            "--fallback-style=llvm",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
        },
    })
)
require("clangd_extensions").setup({
    server = clangd_configs,
    extensions = {
        autoSetHints = true,
        hover_with_actions = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = true,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
        },
      },
})

lspconfig.texlab.setup(enhance_attach({ require("modules.completion.lsp.providers.latex") }))

lspconfig.jsonls.setup(enhance_attach({
    cmd = { "vscode-json-languageserver", "--stdio" },
    filetypes = { "json", "jsonc" },
}))

lspconfig.sqls.setup(enhance_attach({
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
}))

-- -- You will have to Build a package for this .
lspconfig.rust_analyzer.setup(enhance_attach({
    filetypes = { "rust" },
    cmd = { "rust-analyzer" },
}))

lspconfig.vimls.setup(enhance_attach({
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
}))

-- local sumneko_root_path = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server"
-- local sumneko_binary = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server/bin/lua-language-server"
local runtime_path = {}
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local sumneko_lua_server = enhance_attach({
    -- cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    cmd = { "lua-language-server" },
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
                        -- vim.api.nvim_get_runtime_file("", false),
                        -- [table.concat({ vim.fn.stdpath("data"), "lua" }, "/")] = false,
                        -- vim.api.nvim_get_runtime_file("", false),
                        -- [vim.fn.expand("~") .. "/.config/nvim/lua"] = false,
                        -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    },
                    maxPreload = 200000,
                    preloadFileSize = 10000,
                },
            },
        },
    },
})

local luadev = require("lua-dev").setup({
    library = {
        vimruntime = true,
        types = true,
        -- makes everything lag
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
