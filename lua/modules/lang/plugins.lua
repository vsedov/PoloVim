local conf = require("modules.lang.config")
local lang = require("core.pack").package

-- -- Inline functions dont seem to work .
lang({
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = conf.refactor,
})

-- -- -- -- OPTIM(vsedov) (01:01:25 - 14/08/22): If this gets used more, i will load this
-- -- -- on startup, using lazy.lua
lang({
    "andrewferrier/debugprint.nvim",
    lazy = true,
    keys = {
        { "g?p", mode = "n" },
        { "g?P", mode = "n" },
        { "g?v", mode = "n" },
        { "g?V", mode = "n" },
        { "g?l", mode = "n" },
        { "g?L", mode = "n" },
        { "g?V", mode = "v" },
        { "g?v", mode = "v" },
        { "g?o", mode = "x" },
        { "g?O", mode = "x" },
    },
    cmd = "DeleteDebugPrints",
    config = true,
})

lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", config = true })
lang({ "nanotee/luv-vimdocs", ft = "lua" })
-- -- -- builtin lua functions
lang({ "milisims/nvim-luaref", ft = "lua" })

lang({
    "Weissle/persistent-breakpoints.nvim",
    lazy = true,
    config = true,
})

lang({
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            lazy = true,
            opts = {},
            config = function(_, opts)
                -- setup dap config by VsCode launch.json file
                -- require("dap.ext.vscode").load_launchjs()
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            lazy = true,
            opts = {
                enabled = true, -- enable this plugin (the default)
            },
        },
        { "LiadOz/nvim-dap-repl-highlights", config = true, lazy = true },
        { "ofirgall/goto-breakpoints.nvim", lazy = true },
        { "rcarriga/cmp-dap" },
        {
            "jay-babu/mason-nvim-dap.nvim",

            dependencies = "mason.nvim",
            lazy = true,
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {
                    -- Update this to ensure that you have the debuggers for the langs you want
                    "debugpy",
                },
            },
        },
    },
    config = conf.dap_config,
})
lang({
    "mfussenegger/nvim-dap-python",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    ft = { "python" },
    lazy = true,
    config = function()
        local dap_python = require("dap-python")
        local function find_debugpy_python_path()
            -- Return the path to the debugpy python executable if it is
            -- installed in $VIRTUAL_ENV, otherwise get it from Mason
            if vim.env.VIRTUAL_ENV or require("modules.lsp.lsp.providers.python.utils.python_help").in_any_env() then
                return vim.fn.exepath("python3")
            end

            local mason_registry = require("mason-registry")
            local path = mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
            return path
        end

        local dap_python_path = find_debugpy_python_path()
        dap_python.setup(dap_python_path)
    end,
})
