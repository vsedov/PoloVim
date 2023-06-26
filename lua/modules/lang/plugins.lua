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
    config = conf.debugprint,
})

lang({ "yardnsm/vim-import-cost", cmd = "ImportCost", config = true })

lang({ "nanotee/luv-vimdocs", ft = "lua" })

-- -- -- builtin lua functions
lang({ "milisims/nvim-luaref", ft = "lua" })

lang({
    "rafcamlet/nvim-luapad",
    ft = "lua",
    config = conf.luapad,
})

lang({
    "Weissle/persistent-breakpoints.nvim",
    lazy = true,
    config = true,
})

lang({
    "mfussenegger/nvim-dap",
    lazy = true,
    config = conf.dap_config,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            opts = {
                windows = { indent = 2 },
                floating = { border = lambda.style.border.type_0 },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        position = "left",
                        size = 20,
                    },
                    { elements = { { id = "repl", size = 0.9 } }, position = "bottom", size = 10 },
                },
            },
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                enabled = true, -- enable this plugin (the default)
                enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true, -- show stop reason when stopped for exceptions
                commented = false, -- prefix virtual text with comment string
                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
                display_callback = function(variable, buf, stackframe, node, options)
                    if options.virt_text_pos == "inline" then
                        return " = " .. variable.value
                    else
                        return variable.name .. " = " .. variable.value
                    end
                end,
                -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

                -- experimental features:
                all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
            },
        },
        { "LiadOz/nvim-dap-repl-highlights", config = true },
        "ofirgall/goto-breakpoints.nvim",
        "mfussenegger/nvim-dap-python",
        "jay-babu/mason-nvim-dap.nvim",
    },
})
