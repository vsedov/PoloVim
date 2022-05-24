local enhance_attach = require("modules.lsp.lsp.utils").enhance_attach

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
                    globals = {
                        "vim",
                        "dump",
                        "hs",
                        "lvim",
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "pending",
                        "teardown",
                        "packer_plugins",
                    },
                },
                completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
                workspace = {
                    -- remove all of this, as it slows things down
                    library = {
                        -- vim.api.nvim_get_runtime_file("", true),
                        -- [table.concat({ vim.fn.stdpath("data"), "lua" }, "/")] = false,
                        -- vim.api.nvim_get_runtime_file("", false),
                        -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    },
                    maxPreload = 1000,
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
        plugins = { "nvim-notify", "plenary.nvim" },
    },
    lspconfig = sumneko_lua_server,
})
require("lspconfig").sumneko_lua.setup(luadev)
